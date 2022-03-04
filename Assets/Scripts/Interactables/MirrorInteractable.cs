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

    private float distance;
    private Vector3 originalPos;
    private bool canInteract, isComplete;

    public UnityEvent OnBegin;
    public UnityEvent OnEnd;

    private void Awake()
    {
        canInteract = true;
        isComplete = false;
        originalPos = particle.position;
    }
    private void Update()
    {
        if (CanInteract() == false && IsComplete() == false)
        {
            particle.position = Vector3.MoveTowards(particle.position, targetMirror.originalPos, (distance / timedelay) * Time.deltaTime);
        }
    }
    public void Interact(IDictionary<string, object> data)
    {
        particle.position = originalPos;
        isComplete = false;
        canInteract = false;
        if (pivot == null || targetMirror == null) { return; }

        IActor actor = (IActor)data["actor"];
        StartCoroutine(TimeDelay(data));

        Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);
    }

    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);
        particle.gameObject.SetActive(true);

        distance = Vector3.Distance(originalPos, targetMirror.transform.position);

        OnBegin?.Invoke();

        yield return new WaitForSeconds(timedelay);

        Vector3 targetMirrorPivotRotation = targetMirror.pivot.eulerAngles;
        actor.transform.eulerAngles = new Vector3(0, targetMirrorPivotRotation.y, 0);
        isComplete = true;
        canInteract = true;
        particle.transform.position = originalPos;
        particle.gameObject.SetActive(false);
        actor.transform.position = targetMirror.pivot.position;
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);

        OnEnd?.Invoke();
    }
    private void OnDrawGizmos()
    {
        if (!targetMirror) return;
        if (!particle) return;
        Gizmos.DrawLine(particle.position, targetMirror.pivot.position);
    }

    public bool CanInteract() => canInteract;
    public bool IsComplete() => isComplete;

}
