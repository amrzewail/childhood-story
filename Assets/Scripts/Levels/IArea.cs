using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.Areas
{
    public interface IArea
    {
        string sceneName { get; }
        void Reload();

        void ReloadDefault();
    }
}