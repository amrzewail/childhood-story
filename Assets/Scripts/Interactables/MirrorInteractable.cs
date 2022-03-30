using System.Linq;
using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MirrorInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] private Transform pivot;
    [SerializeField] private Transform center;
    [SerializeField] private Transform particle;
    [SerializeField] private Transform particleTrail;
    [SerializeField] private MirrorInteractable targetMirror;
    [SerializeField] private float timedelay;
    [SerializeField] private bool useRayCast;
    [SerializeField] private float raycastDistance = 20;

    private float distance;
    private bool canInteract, isComplete;
    private MirrorInteractable _targetMirror;

    public UnityEvent OnBegin;
    public UnityEvent OnEnd;

    private void Awake()
    {
        canInteract = true;
        isComplete = false;
    }
    private void Update()
    {
        if (CanInteract() == false && IsComplete() == false && _targetMirror)
        {
            particle.position = Vector3.MoveTowards(particle.position, _targetMirror.center.position, (distance / timedelay) * Time.deltaTime);
        }

        _targetMirror = targetMirror;

        if (useRayCast)
        {
            if (RaycastFrontMirror(out MirrorInteractable m))
            {
                _targetMirror = m;
            }
        }
        if (_targetMirror)
        {
            particleTrail.gameObject.SetActive(true);
            particleTrail.position = Vector3.Lerp(center.position, _targetMirror.center.position, Mathf.Pow(Mathf.Sin(Time.time * 2), 2));
        }
        else
        {
            particleTrail.gameObject.SetActive(false);
        }
    }
    public void Interact(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        isComplete = true;
        canInteract = true;

        if (actor.GetActorComponent<IActorIdentity>(0).characterIdentifier == 1)
        {
            _targetMirror = targetMirror;

            if (useRayCast)
            {
                if(RaycastFrontMirror(out MirrorInteractable m))
                {
                    _targetMirror = m;
                }
            }

            if (pivot == null || _targetMirror == null) { return; }

            particle.position = center.position;
            isComplete = false;
            canInteract = false;

            StartCoroutine(TimeDelay(data));

            Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);
        }
    }

    private bool RaycastFrontMirror(out MirrorInteractable m)
    {
        if (Physics.Raycast(center.position, transform.forward, out RaycastHit hit, raycastDistance, ~(1 << LayerMask.NameToLayer("Character")), QueryTriggerInteraction.Ignore))
        {
            if (hit.transform)
            {
                if ((m = hit.transform.GetComponent<MirrorInteractable>()))
                {
                    if (Vector3.Dot(hit.transform.forward, transform.forward) < 0)
                    {
                        return true;
                    }
                }
                else
                {
                    Debug.Log($"Mirror raycast hit: {hit.transform.name}");
                }
            }
        }
        m = null;
        return false;
    }

    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);
        particle.gameObject.SetActive(true);

        distance = Vector3.Distance(center.position, _targetMirror.center.position);

        OnBegin?.Invoke();

        yield return new WaitForSeconds(timedelay);

        Vector3 targetMirrorPivotRotation = _targetMirror.pivot.eulerAngles;
        actor.transform.eulerAngles = new Vector3(0, targetMirrorPivotRotation.y, 0);
        isComplete = true;
        canInteract = true;
        particle.transform.position = center.position;
        particle.gameObject.SetActive(false);
        actor.transform.position = _targetMirror.pivot.position;
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);

        OnEnd?.Invoke();
    }
    private void OnDrawGizmos()
    {
        if (useRayCast)
        {
            Gizmos.DrawLine(center.position, transform.position + Vector3.up + transform.forward * raycastDistance);
            return;
        }
        if (!targetMirror) return;
        if (!particle) return;
        Gizmos.DrawLine(center.position, targetMirror.pivot.position);
    }

    public bool CanInteract() => canInteract;
    public bool IsComplete() => isComplete;

}
