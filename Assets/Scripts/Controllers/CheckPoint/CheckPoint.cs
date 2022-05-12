using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{

    public bool isDefault = false;

    public bool Activated => ActivatedPlayers.Count > 0;
    public static List<CheckPoint> CheckPointsList = new List<CheckPoint>();
    [HideInInspector] public List<int> ActivatedPlayers = new List<int>();
    public int allowPlayerOnly = -1;
    private Transform[] transforms;

#if UNITY_EDITOR
    private void OnValidate()
    {
        if (!Application.isPlaying)
        {
            if (isDefault)
            {
                CheckPoint[] checks = GameObject.FindObjectsOfType<CheckPoint>();

                checks.ToList().ForEach(c =>
                {
                    if (c != this && c.gameObject.scene == this.gameObject.scene)
                    {
                        c.isDefault = false;
                        UnityEditor.EditorUtility.SetDirty(c);
                    }
                });
            }
        }
    }
#endif

    private void Awake()
    {
        if (isDefault)
        {
            ActivatedPlayers.Clear();
            ActivatedPlayers.AddRange(new int[] { 0, 1 });
        }
        CheckPointsList.Add(this);
        transforms = new Transform[2];
        for (int i = 0; i < transform.childCount; i++)
        {
            transforms[i] = transform.GetChild(i);
        }
    }


    private void OnDestroy()
    {
        CheckPointsList.Remove(this);
    }

    public static Vector3 GetActiveCheckPointPosition(int playerIndex)
    {
        // If player die without activate any checkpoint, we will return a default position
        Vector3 result = new Vector3(0, 0, 0);

        if (CheckPointsList != null)
        {
            foreach (CheckPoint cp in CheckPointsList)
            {
                // We search the activated checkpoint to get its position
                if (cp.Activated && cp.ActivatedPlayers.Contains(playerIndex))
                {
                    result = cp.transforms[playerIndex].position;
                    break;
                }
            }
        }
        return result;

        //return result;
    }

    public static void ResetCheckpoints()
    {
        if (CheckPointsList != null)
        {
            foreach (CheckPoint cp in CheckPointsList)
            {
                cp.ResetCheckpoint();
            }
        }
    }

    public void ResetCheckpoint()
    {
        ActivatedPlayers.Clear();
        if (isDefault)
        {
            ActivatedPlayers.AddRange(new int[] { 0, 1 });
        }
    }

    private void ActivateCheckPoint(int playerIndex)
    {
        if (allowPlayerOnly == -1 || allowPlayerOnly == playerIndex)
        {
            // We deactive all checkpoints in the scene
            foreach (CheckPoint cp in CheckPointsList)
            {
                if (cp.ActivatedPlayers.Contains(playerIndex))
                {
                    cp.ActivatedPlayers.Remove(playerIndex);
                }
            }

            // We activated the current checkpoint
            ActivatedPlayers.Add(playerIndex);
        }
    }


    void OnTriggerEnter(Collider other)
    {
        var checkpointActor = other.GetComponent<CheckpointActor>();
        // If the player passes through the checkpoint, we activate it
        if (checkpointActor)
        {
            ActivateCheckPoint(checkpointActor.playerIndex);
        }
    }
}