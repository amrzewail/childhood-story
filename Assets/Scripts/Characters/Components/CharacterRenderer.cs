using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterRenderer : MonoBehaviour, IRenderer
{
    [SerializeField] List<Renderer> renderers;
    [SerializeField] List<Cloth> clothes;


    void Start()
    {
    }

    public void SetVisibility(bool visible)
    {

        renderers.ForEach(x => x.enabled = visible);

        if(visible)
        {
            clothes.ForEach(x => x.ClearTransformMotion());
        }

    }
}
