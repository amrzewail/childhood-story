using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.Areas
{
    public interface ISaveable
    {
        void Save();
        void Apply();
        void Remove();

        string GetIdentifier();
    }
}