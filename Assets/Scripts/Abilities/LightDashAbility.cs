using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class LightDashAbility : MonoBehaviour, IAbility
{
    private bool canPerform = true;
    private bool isComplete = true;
    private Transform _directioner;
    private List<Vector3> _path;

    [SerializeField] private float dashDistance;
    [SerializeField] private float dashTime;
    [SerializeField] private float cooldown;
    [SerializeField] private Rigidbody _rigidbody;
    public GameObject lightningObj;
    public GameObject speedModeAura;





    [SerializeField] [RequireInterface(typeof(IMover))] Object _mover;
    public IMover mover => (IMover)_mover;
    [SerializeField] [RequireInterface(typeof(IInput))] Object _input;
    public IInput input => (IInput)_input; 
    
    [SerializeField][RequireInterface(typeof(IDamageable))] Object _damageable;
    public IDamageable damageable => (IDamageable)_damageable;

    private void Start()
    {
        canPerform = true;
        isComplete = true;
        lightningObj.SetActive(false);
        speedModeAura.SetActive(false);

        _directioner = new GameObject("Directioner").transform;
        _directioner.SetParent(this.transform);
        _directioner.localPosition = Vector3.zero;
    }

    private void Update()
    {
    }

    public bool CanPerform()
    {
        return canPerform;
    }

    public bool IsComplete()
    {
        return isComplete;
    }

    //Here you perform the ability
    public void Perform()
    {
        StartCoroutine(StartAbility());
    }

    private void FixedUpdate()
    {
        
    }

    IEnumerator StartAbility()
    {
        canPerform = false;
        isComplete = false;

        Debug.Log("Perform new ability!!");

        damageable.isActive = false;

        speedModeAura.SetActive(true);
        lightningObj.SetActive(true);

        float time = 0;

        var mask = ~LayerMask.GetMask(new string[] { "TransparentShadow" });

        int iterations = 20;
        List<Vector3> path = new List<Vector3>();
        path.Add(_rigidbody.transform.position);

        Vector3 direction = new Vector3(input.absAxis.x, 0, input.absAxis.y).normalized;
        RaycastHit hit;
        for(int i = 0; i < iterations; i++)
        {
            if(Physics.Raycast(path[i] + Vector3.up * 0.05f, direction, out hit, dashDistance / iterations, mask, QueryTriggerInteraction.Ignore))
            {
                float angle = Vector3.Angle(hit.normal, Vector3.up);
                if (angle <= 60)
                {
                    angle *= Mathf.Deg2Rad;
                    float up = Mathf.Cos(angle) * dashDistance / iterations;
                    float fwd = Mathf.Sin(angle) * dashDistance / iterations;
                    if (Physics.Raycast(path[i] + Vector3.up * (up + 0.05f) + direction * fwd, Vector3.down, out hit, dashDistance / iterations * 2, mask, QueryTriggerInteraction.Ignore))
                    {
                        path.Add(hit.point);
                    }
                    else
                    {
                        path.Add(path[i]);
                    }
                }
                else
                {
                    path.Add(path[i]);
                }
            }
            else
            {
                if(Physics.Raycast(path[i] + Vector3.up * 0.05f + direction * dashDistance / iterations, Vector3.down, out hit, dashDistance / iterations* 2, mask, QueryTriggerInteraction.Ignore))
                {
                    path.Add(hit.point);
                }
                else
                {
                    path.Add(path[i] + direction * dashDistance / iterations);
                }
            }
        }

        _path = path;

        while(time <= dashTime)
        {
            //

            int pathIndex = Mathf.CeilToInt((time / dashTime) * (path.Count - 1));
            pathIndex = Mathf.Clamp(pathIndex, 1, path.Count - 1);

            _rigidbody.position = Vector3.MoveTowards(_rigidbody.position, path[pathIndex], dashDistance / dashTime * Time.deltaTime);

            yield return null;

            time += Time.deltaTime;
        }

        _rigidbody.position = path[path.Count - 1];

        isComplete = true;
        yield return new WaitForSeconds(0.24f);

        damageable.isActive = true;

        lightningObj.SetActive(false);
        //This is a cooldown for the ability
        yield return new WaitForSeconds(cooldown-0.24f);
        speedModeAura.SetActive(false);

        Debug.Log("Ability is available");

        canPerform = true;
    }

    void OnDrawGizmos()
    {
        if(_path != null)
        {
            for(int i = 1; i < _path.Count; i++)
            {
                Gizmos.DrawLine(_path[i - 1], _path[i]);
            }
        }
    }
}
