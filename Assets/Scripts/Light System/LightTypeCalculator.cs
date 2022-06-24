using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightTypeCalculator : MonoBehaviour
{
    public static bool IsPositionLighted(Vector3 position)
    {
        List<LightEffector> lights = LightEffector.effectors;
        if (lights == null) return false;

        bool isLight = false;
        foreach (var light in lights)
        {
            if (IsLightHit(position, light))
            {
                isLight = true;
                break;
            }
        }

        return isLight;
    }

    public static bool IsLightHit(Vector3 position, LightEffector lightEffector)
    {
        LayerMask layer = LayerMask.GetMask(new string[] { "Obstacle", "Ground" });
        Light light = lightEffector.light;
        RaycastHit hit;
        Vector3 direction = Vector3.up;
        float distance = 0;
        if (light.type == LightType.Spot)
        {
            direction = -(light.transform.position - position);
            distance = direction.magnitude - 0.25f;
            if (Physics.Raycast(light.transform.position, direction, out hit, distance, layerMask: layer.value, QueryTriggerInteraction.Ignore))
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
            distance = 10000;
            if (Physics.Raycast(position, direction, out hit, distance, layerMask: layer.value, QueryTriggerInteraction.Ignore))
            {
                return false;
            }

        }
        else if (light.type == LightType.Point)
        {
            direction = -(light.transform.position - position);
            distance = direction.magnitude - 0.25f;

            if (direction.magnitude > light.range * lightEffector.rangeRatio) return false;
            if (Physics.Raycast(light.transform.position, direction, out hit, distance, layerMask: layer.value, QueryTriggerInteraction.Ignore))
            {
                return false;
            }
        }

        return true;
    }
}
