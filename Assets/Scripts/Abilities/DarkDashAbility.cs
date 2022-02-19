using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class DarkDashAbility : MonoBehaviour, IAbility
{
    private bool _canPerform = true;
    private bool _isComplete = true;
    private bool _obstacleAhead = false;
    private float _allowedDistance = 0;


    [SerializeField] float time = 0.5f;
    [SerializeField] float distance = 1f;
    [SerializeField] float cooldown = 1f;
    [SerializeField] [RequireInterface(typeof(IActor))] Object _actor;
    [SerializeField] List<Collider> colliders;
    [SerializeField] Rigidbody rigidBody;
    [SerializeField] GameObject effect;

    private IActor actor => ((IActor)_actor);

    internal void FixedUpdate()
    {
        if (Physics.OverlapSphere(actor.transform.position + Vector3.up * 1 + actor.transform.forward * distance, 0.5f).Length > 0)
        {
            _obstacleAhead = true;
            if(Physics.SphereCast(actor.transform.position + Vector3.up, 0.5f, actor.transform.forward, out RaycastHit hit))
            {
                _allowedDistance = hit.distance;
                if (_allowedDistance > distance) _allowedDistance = 0;
            }
        }
        else
        {
            _obstacleAhead = false;
            _allowedDistance = distance;
        }

        if (_allowedDistance > 0)
        {
            for (float i = _allowedDistance / 4f; i <= _allowedDistance; i += _allowedDistance / 4f)
            {
                bool isLight = LightTypeCalculator.IsPositionLighted(actor.transform.position + actor.transform.forward * i);
                if (isLight)
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

        float timer = time;

        while(timer > 0)
        {
            if (true || !_obstacleAhead)
            {
                actor.transform.position += actor.transform.forward * Time.deltaTime * dist / time;

            }
            timer -= Time.deltaTime;
            yield return null;
        }

        rigidBody.isKinematic = false;
        colliders.ForEach(x => x.enabled = true);
        actor.transform.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);

        _isComplete = true;
        GameObject.Instantiate(effect, actor.transform.position, Quaternion.identity);


        yield return new WaitForSeconds(cooldown);

        _canPerform = true;
    }
}
