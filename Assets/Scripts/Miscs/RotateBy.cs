using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class RotateBy : MonoBehaviour
{
    [SerializeField] Transform[] _targets;
    [SerializeField] Vector3 _angle;
    [SerializeField] float _duration;



    public void Rotate()
    {
        foreach(var t in _targets)
        {
            Rotatable rotatable = null;
            if((rotatable = t.GetComponent<Rotatable>()))
            {
                if (rotatable.isRotatable == false) continue;
            }
            Vector3 targetAngle = t.transform.eulerAngles + _angle;

            t.DORotate(targetAngle, _duration, RotateMode.FastBeyond360);
        }
    }

}
