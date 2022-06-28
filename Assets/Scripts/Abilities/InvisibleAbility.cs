using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class InvisibleAbility : MonoBehaviour, IAbility
{
    //this is property canPerform
    private bool canPerform = true;
    //this is property isComplete
    private bool isComplete = true;

    private Dictionary<Renderer, List<Material>> _originalMaterials;

    [SerializeField] [RequireInterface(typeof(ITargetable))] Object _targetable;
    [SerializeField][RequireInterface(typeof(IDamageable))] Object _damageable;
    [SerializeField] float abilityDuration = 5;
    [SerializeField] float abilityCooldown = 3;
    [SerializeField] List<Renderer> renderers;
    [SerializeField] Material transparentMaterial;

    [SerializeField] UnityEvent OnInvisibleStart;
    [SerializeField] UnityEvent OnInvisibleEnd;
    [SerializeField] UnityEvent OnCooldownEnd;

    public ITargetable targetable => (ITargetable)_targetable;

    public IDamageable damageable => (IDamageable)_damageable;

    //Start happens at the start of the game
    private void Start()
    {
        canPerform = true;
        isComplete = true;

        _originalMaterials = new Dictionary<Renderer, List<Material>>();

        foreach(var r in renderers)
        {
            _originalMaterials.Add(r, r.materials.ToList());
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
        OnInvisibleStart?.Invoke();

        canPerform = false;
        isComplete = true;

        Debug.Log("Perform invisible ability!!");

        targetable.isTargetable = false;
        damageable.isActive = false;

        foreach (var r in renderers)
        {
            Material[] materials = r.materials;
            for(int i = 0; i < r.materials.Length; i++)
            {
                materials[i] = transparentMaterial;
            }
            r.materials = materials;
        }

        OnInvisibleEnd?.Invoke();

        //This is a cooldown for the ability
        yield return new WaitForSeconds(abilityDuration);

        targetable.isTargetable = true;
        damageable.isActive = true;

        foreach (var r in renderers)
        {
            Material[] materials = r.materials;
            for (int i = 0; i < r.materials.Length; i++)
            {
                materials[i] = _originalMaterials[r][i];
            }
            r.materials = materials;
        }

        yield return new WaitForSeconds(abilityCooldown);

        OnCooldownEnd?.Invoke();
        canPerform = true;
        Debug.Log("Invisible ability is available");
    }
}
