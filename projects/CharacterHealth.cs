using Godot;
using System;

public partial class Character : CharacterBody2D
{
    [Export] public float damage;

    public float maxHealth;
    public float defenseRate;
    public float defenseValue;
    
    [Export] public float currentHealth;
    [Export] public bool isHurt = false;
    [Export] public bool isDie = false;

    // ===============================
    // hurt

    public void StartHurtState(float newDamage = 1)
    {
        if (!isHurt)
        {
            damage = newDamage;
            ActMachine(ActState.hurt);
        }
    }

    public void StartHurtAct()
    {
        float trueDamage = (damage - defenseValue) * (1 - defenseRate);
        trueDamage = Mathf.Max(1, trueDamage);
        currentHealth = Mathf.Max(0, currentHealth - trueDamage);
        if (currentHealth <= 0)
        {
            StartDieState();
        }
        else
        {
            isHurt = true;
            _hurtTimer.Start();
            ChangeAni("Hurt");
        }
    }

    public void HurtActStop()
    {
        _hurtTimer.Stop();
        isHurt = false;
    }

    public void EndHurtAct()
    {
        ActMachine(ActState.idle, true);
    }

    // ===============================
    // die

    public void StartDieState()
    {
        if (!isDie)
        {
            currentHealth = 0;
            ActMachine(ActState.die);
        }
    }

    public async void StartDieAct()
    {
        isDie = true;
        ChangeAni("Dying");
        await ToSignal(GetTree().CreateTimer(0.7f), "timeout");
        EndDieAct();
    }
    public void DieActStop()
    {
        isDie = false;
    }

    public void EndDieAct()
    {
        DieActStop();
        QueueFree();
    }
}
