using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+ NAME)]
    public class DeadState : FSMState
    {
        public const string NAME = "Dead State";

        private IActor _actor;


        public string animationName;

        public GameObject darkDeathVFX;
        public GameObject lightDeathVFX;


        public GameObject darkSpawnVFX;
        public GameObject lightSpawnVFX;


        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            //_actor.GetActorComponent<IAnimator>(0).Play(0, animationName);

            _actor.GetActorComponent<IRenderer>().SetVisibility(false);

            PlayVFX();

            data["death_position"] = _actor.transform.position;


            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _actor.GetActorComponent<IMover>(0).Stop();

            if (_actor.GetActorComponent<IActorHealth>().IsDead())
            {

                //_actor.transform.position = (Vector3)data["death_position"];
            }

        }

        public override bool ExitState(Dictionary<string, object> data)
        {
            PlayVFX(true);

            DelayVisible();

            return true;
        }

        private async void DelayVisible()
        {
            await System.Threading.Tasks.Task.Delay(100);

            if (_actor.transform)
            {
                _actor.GetActorComponent<IRenderer>().SetVisibility(true);

            }
        }

        private void PlayVFX(bool isSpawn=false)
        {
            GameObject vfx = null;
            switch (_actor.GetActorComponent<IActorIdentity>().characterIdentifier)
            {
                case 0:
                    if (!isSpawn) vfx = GameObject.Instantiate(darkDeathVFX);
                    else vfx = GameObject.Instantiate(darkSpawnVFX);
                    break;

                case 1:
                    if(!isSpawn) vfx = GameObject.Instantiate(lightDeathVFX);
                    else vfx = GameObject.Instantiate(lightSpawnVFX);

                    break;
            }

            if (vfx)
            {
                vfx.transform.position = _actor.transform.position + Vector3.up;
                Destroy(vfx.gameObject, 5);
            }
        }
    }
}