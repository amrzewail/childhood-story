using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InvisibleAbility : MonoBehaviour, IAbility
{
    //this is property canPerform
    private bool canPerform = true;
    //this is property isComplete
    private bool isComplete = true;

    private Dictionary<Renderer, Material> _originalMaterials;

    [SerializeField] [RequireInterface(typeof(ITargetable))] Object _targetable;
    [SerializeField] float abilityDuration = 5;
    [SerializeField] float abilityCooldown = 3;
    [SerializeField] List<Renderer> renderers;
    [SerializeField] Material transparentMaterial;

    public ITargetable targetable => (ITargetable)_targetable;

    //Start happens at the start of the game
    private void Start()
    {
        canPerform = true;
        isComplete = true;

        _originalMaterials = new Dictionary<Renderer, Material>();

        foreach(var r in renderers)
        {
            _originalMaterials.Add(r, r.material);
        }
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

    IEnumerator StartAbility()
    {
        canPerform = false;
        isComplete = true;

        Debug.Log("Perform invisible ability!!");

        targetable.isTargetable = false;

        foreach(var r in renderers)
        {
            r.material = transparentMaterial;
        }

        //This is a cooldown for the ability
        yield return new WaitForSeconds(abilityDuration);

        targetable.isTargetable = true;


        foreach (var r in renderers)
        {
            r.material = _originalMaterials[r];
        }

        yield return new WaitForSeconds(abilityCooldown);

        canPerform = true;
        Debug.Log("Invisible ability is available");
    }
}
