using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorMove : StateMachineBehaviour
{

    private Vector3 _position;
    private float _speed = 1;

    public AnimationCurve xPosition;
    public AnimationCurve yPosition;
    public AnimationCurve zPosition;

    public bool applyOnExitOnly;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        _position = animator.transform.position;
    }


    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (applyOnExitOnly)
            return;
        _speed = stateInfo.speed * animator.GetFloat("Speed");
        float time = stateInfo.normalizedTime;
        animator.transform.position = _position + animator.transform.right * xPosition.Evaluate(time) * _speed
            + animator.transform.up * yPosition.Evaluate(time) * _speed
            + animator.transform.forward * zPosition.Evaluate(time) * _speed;
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.transform.position = _position + animator.transform.right * xPosition.Evaluate(1) * _speed
            + animator.transform.up * yPosition.Evaluate(1) * _speed
            + animator.transform.forward * zPosition.Evaluate(1) * _speed;
    }

    //OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
        
        // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
