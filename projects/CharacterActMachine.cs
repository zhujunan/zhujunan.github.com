using Godot;

public partial class Character : CharacterBody2D
{
    // private Mutex mutex = new Mutex();
    private enum ActState
    {
        idle, move, attack, hurt, die
    };

    [Export]
    private ActState characterState = ActState.idle;

    private void ActMachine(ActState newState, bool actEnd = false)
    {
        // mutex.Lock();
        switch (characterState)
        {
            case ActState.idle:
                characterState = newState;
                IdleActStop();
                ChangeAct(newState);
                break;

            case ActState.move:
                characterState = newState;
                MoveActStop();
                ChangeAct(newState);
                break;

            case ActState.attack:
                if (actEnd || newState == ActState.hurt || characterState == ActState.die)
                {
                    characterState = newState;
                    AttackActStop();
                    ChangeAct(newState);
                }
                break;

            case ActState.hurt:
                if (actEnd || newState == ActState.die)
                {
                    characterState = newState;
                    HurtActStop();
                    ChangeAct(newState);
                }
                break;

            case ActState.die:
                break;

            default:
                characterState = newState;
                IdleActStop();
                ChangeAct(newState);
                break;
        }
        // mutex.Unlock();
    }

    private void ChangeAct(ActState newState)
    {
        switch (newState)
        {
            case ActState.idle:
                StartIdleAct();
                break;

            case ActState.move:
                StartMoveAct();
                break;

            case ActState.attack:
                StartAttackAct();
                break;

            case ActState.hurt:
                StartHurtAct();
                break;

            case ActState.die:
                StartDieAct();
                break;

            default:
                GD.Print("ChangeAct error, newState ", newState);
                break;
        }
    }
}
