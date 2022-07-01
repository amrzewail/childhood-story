using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IRenderer : IComponent
{
    public void SetVisibility(bool visible);
}
