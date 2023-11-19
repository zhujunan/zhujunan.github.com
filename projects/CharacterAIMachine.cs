using Godot;

public partial class Character : CharacterBody2D
{
    public enum AIState
    {
        guard, charge, forward, gather, retreat
    };
    enum BehaviorState
    {
        battle, move, idle, battle_smart, move_smart, idle_smart
    };

    [Export] AIState AINow = AIState.guard;
    [Export] BehaviorState BehaviorNow = BehaviorState.idle;

    CharacterBody2D target;

    public void FindTarget()
    {
        CharacterBody2D a = default;
        target = a;
    }


    public void CharacterAICheck()
    {
        switch (BehaviorNow)
        {
            case BehaviorState.battle:
                break;

            case BehaviorState.move:
                break;
            
            case BehaviorState.idle:
                break;

            default:
                BehaviorNow = BehaviorState.idle;
                break;
        }
    }

}
