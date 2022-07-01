using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterRenderer : MonoBehaviour, IRenderer
{
    [SerializeField] List<Renderer> renderers;
    public void SetVisibility(bool visible)
    {

        renderers.ForEach(x => x.enabled = visible);

    }
}
