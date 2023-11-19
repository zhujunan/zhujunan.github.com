using Godot;
using System;

public partial class Character : CharacterBody2D
{
    [Export] private int moveSpeed;
    [Export] public Vector2 moveVector = Vector2.Zero;
    [Export] public Vector2 askMoveVector = Vector2.Zero;
    [Export] public bool isMove = false;
    [Export] public bool isIdle = false;


    // ===============================
    // idle
    // When ending Act, call ActMachine("idle", true)

    public void StartIdleState()
    {
        if (!isIdle)
        {
            ActMachine(ActState.idle);
        }
    }
    public void StartIdleAct()
    {
        isIdle = true;
        moveVector = Vector2.Zero;
        ChangeAni("Idle");
    }
    public void IdleActStop()
    {
        isIdle = false;
    }
    public void EndIdleAct()
    {
        
    }

    // ===============================
    // move

    public void StartMoveState(Vector2 newMoveVector)
    {
        if (isMove)
        {
            moveVector = newMoveVector.Normalized() * moveSpeed;
            ChangeAni("Walking", moveVector);
        }
        else
        {
            askMoveVector = newMoveVector;
            ActMachine(ActState.move);
        }
    }

    public void StartMoveAct()
    {
        isMove = true;
        moveVector = askMoveVector.Normalized() * moveSpeed;
        ChangeAni("Walking", moveVector);
    }
    public void MoveActStop()
    {
        isMove = false;
        moveVector = Vector2.Zero;
    }

    public void EndMoveAct()
    {
        ActMachine(ActState.idle, true);
    }

}
