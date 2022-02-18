using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightTypeCalculator : MonoBehaviour
{
    public static bool IsLightHit(Vector3 position, LightEffector lightEffector, LayerMask layer)
    {
        Light light = lightEffector.light;
        RaycastHit hit;
        Vector3 direction;
        if (light.type == LightType.Spot)
        {
            direction = light.transform.position - position;
            if (Physics.Raycast(position, direction, out hit, direction.magnitude, layerMask: layer.value, QueryTriggerInteraction.Ignore))
            {
                return false;
            }
            else
            {
                float angle = Vector3.Angle(light.transform.forward, -direction);

                if (angle > light.spotAngle / 2 || direction.magnitude > light.range * lightEffector.rangeRatio)
                {
                    return false;
                }
            }
        }else if(light.type == LightType.Directional)
        {
            direction = -light.transform.forward;
            if (Physics.Raycast(position, direction, out hit, 10000, layerMask: layer.value, QueryTriggerInteraction.Ignore))
            {
                return false;
            }
        }
        return true;
    }
}
