using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class DarkDashAbility : MonoBehaviour, IAbility
{
    private bool _canPerform = true;
    private bool _isComplete = true;
    private bool _obstacleAhead = false;//?
    private float _allowedDistance = 0;
    private LayerMask _mask;//?


    [SerializeField] float time = 0.5f;
    [SerializeField] float distance = 1f;
    [SerializeField] float cooldown = 1f;
    [SerializeField] [RequireInterface(typeof(IActor))] Object _actor;//?
    [SerializeField] List<Collider> colliders;//?
    [SerializeField] Rigidbody rigidBody;
    [SerializeField] GameObject effect;
    [SerializeField] GameObject effectUp;
    [SerializeField] GameObject effectMove;

    public UnityEvent OnDashStart;
    public UnityEvent OnDashComplete;

    private IActor actor => ((IActor)_actor);

    internal void Awake()
    {
        _mask = LayerMask.GetMask(new string[] { "Obstacle", "Ground" });
    }

    internal void FixedUpdate()
    {
        bool canDash = true;
        RaycastHit hit;
        if (Physics.SphereCast(actor.transform.position + Vector3.up - actor.transform.forward * 0.5f, 0.5f, actor.transform.forward, out hit, distance + 0.5f, ~0, QueryTriggerInteraction.Ignore))
        {
            if (!hit.transform.CompareTag("DarkDashable"))
            {
                //Debug.Log($"hit default obstacle: {hit.transform.name}");
                _allowedDistance = hit.distance - 0.5f;
                if (_allowedDistance > distance) _allowedDistance = 0;
                canDash = false;
            }
            //Debug.Log($"Dark dash hit obstacle:{hit.transform.gameObject.name}");
        }

        if (canDash)
        {
            if (Physics.OverlapSphere(actor.transform.position + Vector3.up * 1 + actor.transform.forward * distance, 0.5f, _mask, QueryTriggerInteraction.Ignore).Length > 0)
            {
                _obstacleAhead = true;
                if (Physics.SphereCast(actor.transform.position + Vector3.up, 0.5f, actor.transform.forward, out hit, distance, _mask, QueryTriggerInteraction.Ignore))
                {
                    _allowedDistance = hit.distance;
                    if (_allowedDistance > distance) _allowedDistance = 0;
                    //Debug.Log($"Dark dash hit obstacle:{hit.transform.gameObject.name}");
                }
            }
            else
            {
                _obstacleAhead = false;
                _allowedDistance = distance;
            }
        }
        if (_allowedDistance > 0)
        {
            for (float i = _allowedDistance / 4f; i <= _allowedDistance; i += _allowedDistance / 4f)
            {
                Vector3 checkPosition = actor.transform.position + actor.transform.forward * i;
                bool isLight = LightTypeCalculator.IsPositionLighted(checkPosition);
                bool isEmpty = !Physics.Raycast(checkPosition + Vector3.up * 0.5f, Vector3.down, 1.1f, _mask, QueryTriggerInteraction.Ignore);
                if (isEmpty)
                {
                    _allowedDistance = i - _allowedDistance / 4f;
                    break;
                }
                else if (isLight)
                {
                    _allowedDistance = i - _allowedDistance / 4f;
                    break;
                }
            }
        }
    }

    public bool CanPerform()
    {
        return _canPerform;
    }

    public bool IsComplete()
    {
        return _isComplete;
    }

    public void Perform()
    {
        StartCoroutine(PerformCoroutine());
    }

    private IEnumerator PerformCoroutine()
    {
        float dist = _allowedDistance;

        _canPerform = false;
        _isComplete = false;

        rigidBody.isKinematic = true;
        colliders.ForEach(x => x.enabled = false);
        actor.transform.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);

        GameObject.Instantiate(effect, actor.transform.position, Quaternion.identity);
        GameObject movingEffect = GameObject.Instantiate(effectMove, actor.transform.position, Quaternion.identity);
        float timer = time;

        OnDashStart?.Invoke();

        while(timer > 0)
        {
            if (true || !_obstacleAhead)
            {
                actor.transform.position += actor.transform.forward * Time.deltaTime * dist / time;
                movingEffect.transform.position = actor.transform.position;
            }
            timer -= Time.deltaTime;
            yield return null;
        }

        rigidBody.isKinematic = false;
        colliders.ForEach(x => x.enabled = true);
        actor.transform.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);

        _isComplete = true;
        GameObject.Instantiate(effectUp, actor.transform.position, Quaternion.identity);

        OnDashComplete?.Invoke();

        yield return new WaitForSeconds(cooldown);

        _canPerform = true;
    }
}