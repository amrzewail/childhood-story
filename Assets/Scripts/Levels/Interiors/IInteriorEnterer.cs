using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.Areas.Interiors
{
    public interface IInteriorEnterer
    {
        void Enter();
        void Exit();
    }
}