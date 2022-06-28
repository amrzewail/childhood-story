using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{

    [HideInInspector] public bool isDefault = false;


    [SerializeField] bool isSave = false;
    [SerializeField] bool isContinuous = false;

    public int activateOnCount = 1;

    public bool Activated => ActivatedPlayers.Count >= 1;
    public static List<CheckPoint> CheckPointsList = new List<CheckPoint>();
    public List<int> ActivatedPlayers = new List<int>();
    public int allowPlayerOnly = -1;

    private Dictionary<int, IActor> _activatedActors = new Dictionary<int, IActor>();
    private Dictionary<int, Vector3> _lastPositions = new Dictionary<int, Vector3>();

    private Dictionary<int, bool> _isContinuousCheckEnabled = new Dictionary<int, bool>();

    private List<int> _playerQueue = new List<int>();
    private Transform[] transforms;

    public int parentInstanceId { get; private set; }
    public int priority { get; private set; } = 0;


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
        _playerQueue = new List<int>();
        if (SaveManager.GetInstance().Current.checkpoint.Equals(this.name))
        {
            ActivatedPlayers.Clear();
            AddToActivated(0);
            AddToActivated(1);
        }
        CheckPointsList.Add(this);
        parentInstanceId = transform.parent.GetInstanceID();
        priority = transform.GetSiblingIndex();

        transforms = new Transform[2];
        for (int i = 0; i < transform.childCount; i++)
        {
            transforms[i] = transform.GetChild(i);
        }
    }

    private void OnEnable()
    {
        StopAllCoroutines();
        StartCoroutine(RunContinuousUpdate());
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
                    result = cp.GetPlayerSpawnPosition(playerIndex);
                    break;
                }
            }
        }
        return result;

        //return result;
    }

    public static void EnableContinuousChecks(int playerIndex, bool enable)
    {
        if (CheckPointsList != null)
        {
            foreach (CheckPoint cp in CheckPointsList)
            {
                cp.EnableChecks(playerIndex, enable);
            }
        }
    }

    public void EnableChecks(int playerIndex, bool enable)
    {
        _isContinuousCheckEnabled[playerIndex] = enable;
    }

    private IEnumerator RunContinuousUpdate()
    {
        yield return null;
        while (true)
        {
            if (!isContinuous) break;

            for(int i = 0; i < ActivatedPlayers.Count; i++)
            {
                if(_isContinuousCheckEnabled.ContainsKey(ActivatedPlayers[i]) && !_isContinuousCheckEnabled[ActivatedPlayers[i]])
                {
                    continue;
                }

                if (!_activatedActors.ContainsKey(ActivatedPlayers[i]))
                {
                    CheckpointActor checkpointActor = FindObjectsOfType<CheckpointActor>().SingleOrDefault(x => x.playerIndex == ActivatedPlayers[i]);
                    if (!checkpointActor)
                    {
                        continue;
                    }
                    _activatedActors[checkpointActor.playerIndex] = checkpointActor.GetComponentInChildren<IActor>();
                }
                IActor actor = _activatedActors[ActivatedPlayers[i]];
                var identity = actor.GetActorComponent<IActorIdentity>();
                var light = actor.GetActorComponent<ILightDetector>();
                if((identity.characterIdentifier == 0 && !light.isOnLight) || (identity.characterIdentifier == 1 && light.isOnLight))
                {
                    _lastPositions[ActivatedPlayers[i]] = actor.transform.position;
                }
            }

            yield return new WaitForSeconds(1);
        }
    }

    private Vector3 GetPlayerSpawnPosition(int playerIndex)
    {
        if(isContinuous && _lastPositions.ContainsKey(playerIndex))
        {
            return _lastPositions[playerIndex];
        }
        return transforms[playerIndex].position;
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
        _playerQueue.Clear();
        if (isDefault)
        {
            ActivatedPlayers.AddRange(new int[] { 0, 1 });
        }
    }

    private void AddToActivated(int playerIndex)
    {
        ActivatedPlayers.Add(playerIndex);

        
    }

    public void Activate(int playerIndex, bool ignorePriority = false)
    {
        ActivateCheckPoint(playerIndex, ignorePriority);
    }

    private void ActivateCheckPoint(int playerIndex, bool ignorePriority = false)
    {
        if (allowPlayerOnly == -1 || allowPlayerOnly == playerIndex)
        {
            bool canActivate = true;
            if (!_playerQueue.Contains(playerIndex))
            {
                _playerQueue.Add(playerIndex);
            }

            if (_playerQueue.Count == activateOnCount)
            {
                foreach (int pIndex in _playerQueue) 
                {
                    // We deactive all checkpoints in the scene
                    foreach (CheckPoint cp in CheckPointsList)
                    {
                        if (cp.ActivatedPlayers.Contains(pIndex))
                        {
                            if (!ignorePriority && (cp.parentInstanceId == parentInstanceId && cp.priority > priority))
                            {
                                canActivate = false;
                            }
                            else
                            {
                                cp.ActivatedPlayers.Remove(pIndex);
                            }
                        }
                    }

                    if (canActivate)
                    {
                        // We activated the current checkpoint
                        AddToActivated(pIndex);

                        if (isSave)
                        {
                            SaveManager.GetInstance().Current.checkpoint = this.name;


                            SaveManager.GetInstance().Save();
                        }
                    }

                }
                _playerQueue.Clear();
            }
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