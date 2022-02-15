using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProjectSigma.Scripts.FiniteStateMachine
{
    public interface IFSMPlugger
    {
        void Execute(Dictionary<string, object> data);
    }
}