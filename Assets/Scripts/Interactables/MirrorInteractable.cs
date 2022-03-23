using System.Linq;
using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MirrorInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] private Transform pivot;
    [SerializeField] private Transform particle;
    [SerializeField] private MirrorInteractable targetMirror;
    [SerializeField] private float timedelay;
    [SerializeField] private bool useRayCast;
    [SerializeField] private float raycastDistance = 20;

    private float distance;
    private Vector3 originalPos;
    private bool canInteract, isComplete;
    private MirrorInteractable _targetMirror;

    public UnityEvent OnBegin;
    public UnityEvent OnEnd;

    private void Awake()
    {
        canInteract = true;
        isComplete = false;
        originalPos = particle.localPosition;
    }
    private void Update()
    {
        if (CanInteract() == false && IsComplete() == false && _targetMirror)
        {
            particle.position = Vector3.MoveTowards(particle.position, _targetMirror.transform.TransformPoint(_targetMirror.originalPos), (distance / timedelay) * Time.deltaTime);
        }
    }
    public void Interact(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        isComplete = true;
        canInteract = true;

        if (actor.GetActorComponent<IActorIdentity>(0).characterIdentifier == 0)
        {


            _targetMirror = targetMirror;

            if (useRayCast)
            {
                if (Physics.Raycast(transform.position + transform.forward * 0.5f + Vector3.up * 1, transform.forward, out RaycastHit hit, raycastDistance, ~(1 << LayerMask.NameToLayer("Character")), QueryTriggerInteraction.Ignore))
                {
                    if (hit.transform)
                    {
                        if (hit.transform.GetComponent<MirrorInteractable>())
                        {
                            if (Vector3.Dot(hit.transform.forward, transform.forward) < 0)
                            {
                                _targetMirror = hit.transform.GetComponent<MirrorInteractable>();
                            }
                        }
                        else
                        {
                            Debug.Log($"Mirror raycast hit: {hit.transform.name}");
                        }
                    }
                }
            }

            if (pivot == null || _targetMirror == null) { return; }

            particle.localPosition = originalPos;
            isComplete = false;
            canInteract = false;

            StartCoroutine(TimeDelay(data));

            Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);
        }
    }

    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);
        particle.gameObject.SetActive(true);

        distance = Vector3.Distance(particle.transform.parent.TransformPoint(originalPos), _targetMirror.transform.position);

        OnBegin?.Invoke();

        yield return new WaitForSeconds(timedelay);

        Vector3 targetMirrorPivotRotation = _targetMirror.pivot.eulerAngles;
        actor.transform.eulerAngles = new Vector3(0, targetMirrorPivotRotation.y, 0);
        isComplete = true;
        canInteract = true;
        particle.transform.localPosition = originalPos;
        particle.gameObject.SetActive(false);
        actor.transform.position = _targetMirror.pivot.position;
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);

        OnEnd?.Invoke();
    }
    private void OnDrawGizmos()
    {
        if (useRayCast)
        {
            Gizmos.DrawLine(transform.position + Vector3.up + transform.forward * 0.5f, transform.position + Vector3.up + transform.forward * raycastDistance);
            return;
        }
        if (!targetMirror) return;
        if (!particle) return;
        Gizmos.DrawLine(particle.position, targetMirror.pivot.position);
    }

    public bool CanInteract() => canInteract;
    public bool IsComplete() => isComplete;

}
