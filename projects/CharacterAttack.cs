using Godot;
using System;

public partial class Character : CharacterBody2D
{
    public int strength;
    public int intelligence;
    public float attack_range;

    [Export]
    public bool isAttack = false;
    public Vector2 attackVector;

    // ===============================
    // attack

    public void StartAttackState(int newDamage = 1, Vector2 newAttackVector = default)
    {
        if (!isAttack)
        {
            int damage = newDamage;
            attackVector = newAttackVector;
            ActMachine(ActState.attack);
        }
    }

    public void StartAttackAct()
    {
        isAttack = true;
        _attackTimer.Start();
        ChangeAni("Attacking", attackVector);
    }

    public void AttackActStop()
    {
        _attackTimer.Stop();
        isAttack = false;
    }

    public void EndAttackAct()
    {
        ActMachine(ActState.idle, true);
    }
}
