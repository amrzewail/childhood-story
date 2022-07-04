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
    [SerializeField] private float dashSpeed;
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
        float startTime = Time.time;
        //while(Time.time < startTime + dashTime)
        //{

        //    mover.Move(input.absAxis,dashSpeed);
        //    _rigidbody.useGravity = false;

        //    yield return null;
        //}

        _rigidbody.AddForce(new Vector3(input.absAxis.x, 0, input.absAxis.y).normalized * 20 - Physics.gravity, ForceMode.Impulse);


        yield return new WaitForSeconds(dashTime);

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
}
