using Godot;

public partial class Character : CharacterBody2D
{
    private Timer _attackTimer;
    private Timer _hurtTimer;

    public override void _Ready()
    {
        SetAttrbute();
        CharacterAniReady();
        StartIdleAct();

        _attackTimer = GetNode<Timer>("attack_timer");
        _attackTimer.Timeout += EndAttackAct;

        _hurtTimer = GetNode<Timer>("hurt_timer");
        _hurtTimer.Timeout += EndHurtAct;
    }

    public override void _PhysicsProcess(double delta)
    {
        Velocity = moveVector * (float)delta;
        MoveAndSlide();
        // CharacterAICheck();
        CheckAllInputs();
    }

    private void SetAttrbute()
    {
        maxHealth = 200;
        currentHealth = 200;
        defenseRate = 0.1f;
        defenseValue = 5.0f;

        moveSpeed = 10000;

        strength = 2;
        intelligence = 3;
        attack_range = 1f;
    }

}
