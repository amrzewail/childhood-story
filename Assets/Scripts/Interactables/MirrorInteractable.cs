using System.Linq;
using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] private Transform pivot;
    [SerializeField] private Transform particle;
    [SerializeField] private MirrorInteractable mirror;
    private bool caninteract, iscomplete;
    [SerializeField] private float timedelay;
    private float distance;
    private Vector3 originalPos;


    private void Awake()
    {
        originalPos = particle.position;
    }
    private void Update()
    {
        if (CanInteract() == false && IsComplete() == false)
        {
            particle.position = Vector3.MoveTowards(particle.position, mirror.transform.position, (distance / timedelay) * Time.deltaTime);
        }
    }
    public void Interact(IDictionary<string, object> data)
    {
        particle.position = originalPos;
        iscomplete = false;
        caninteract = false;
        if (pivot == null || mirror == null) { return; }

        IActor actor = (IActor)data["actor"];
        StartCoroutine(TimeDelay(data));

        Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);
    }

    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);
        particle.gameObject.SetActive(true);

        distance = Vector3.Distance(originalPos, mirror.transform.position);

        yield return new WaitForSeconds(timedelay);

        Vector3 eulerRotation = mirror.pivot.eulerAngles;
        actor.transform.eulerAngles = new Vector3(0, eulerRotation.y, 0);
        iscomplete = true;
        caninteract = true;
        particle.transform.position = originalPos;
        particle.gameObject.SetActive(false);
        actor.transform.position = mirror.pivot.position;
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);
    }
    private void OnDrawGizmos()
    {
        if (!mirror) return;
        Gizmos.DrawLine(transform.position, mirror.pivot.position);
    }

    public bool CanInteract() => caninteract;



    public bool IsComplete() => iscomplete;

    // Start is called before the first frame update

}
