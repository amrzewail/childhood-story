using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrackTime : StateMachineBehaviour
{

    private IAnimator _controller;
    private bool _invokedFinish = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        _controller = animator.GetComponent<IAnimator>();
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        float time = stateInfo.loop ? stateInfo.normalizedTime % 1.0f : Mathf.Clamp01(stateInfo.normalizedTime);
        if(_controller != null && time <= 1) {
            if (time < 1 || stateInfo.loop)
            {
                _controller.SetNormalizedTime(layerIndex, time);
            }else if(time == 1 && !_invokedFinish)
            {
                _controller.SetNormalizedTime(layerIndex, time);
                _invokedFinish = true;
            }
        }
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        _invokedFinish = false;
    }

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
