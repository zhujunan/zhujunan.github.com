using Godot;
using System;

public partial class Character : CharacterBody2D
{
    [Export] private Vector2 move_vector_manual;

    public Vector2 GetVectorToMouse()
    {
        var characterPosition = Position;
        var mousePosition = GetGlobalMousePosition();
        var vectorToMouse = mousePosition - characterPosition;

        var direction = Vector2.Zero;

        if (Mathf.Abs(vectorToMouse.X) >= Mathf.Abs(vectorToMouse.Y))
        {
            if (vectorToMouse.X > 0)
            {
                direction = Vector2.Right;
            }
            else if (vectorToMouse.X < 0)
            {
                direction = Vector2.Left;
            }
        }
        else
        {
            if (vectorToMouse.Y > 0)
            {
                direction = Vector2.Down;
            }
            else if (vectorToMouse.Y < 0)
            {
                direction = Vector2.Up;
            }
        }

        return direction;
    }

    public void CheckAllInputs()
    {
        CheckMove();
        CheckAttack();
        CheckHurtForTest();
        CheckDieForTest();
    }

    public void CheckMove()
    {
        Vector2 move_vector_new = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
        if (move_vector_new != move_vector_manual)
        {
            move_vector_manual = move_vector_new;
            if (move_vector_new != Vector2.Zero)
            {
                StartMoveState(move_vector_manual);
            }
            else
            {
                StartIdleState();
            }
        }
    }

    public void CheckAttack()
    {
        if (Input.IsMouseButtonPressed(MouseButton.Left))
        {
            StartAttackState(1, GetVectorToMouse());
        }
        if (Input.IsMouseButtonPressed(MouseButton.Right))
        {
            StartAttackState(1, GetVectorToMouse());
        }
    }

    public void CheckHurtForTest()
    {
        if (Input.IsKeyPressed(Key.H))
        {
            StartHurtState();
        }
    }

    public void CheckDieForTest()
    {
        if (Input.IsKeyPressed(Key.I))
        {
            StartHurtState(300.0f);
        }
    }
}
