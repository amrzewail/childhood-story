using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FiniteStateMachine
{
    public interface IFSMPlugger
    {
        void Execute(Dictionary<string, object> data);
    }
}