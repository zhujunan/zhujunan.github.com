using Godot;
using System;

public partial class Character : CharacterBody2D
{
    AnimatedSprite2D _animationSprite2D;

    [Export] bool face_right = true;
    [Export] String ani_now = "Idle";

    private void CharacterAniReady()
    {
        _animationSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");


        // SpriteFrames spriteFrames;
        // var spriteFramesResource = ResourceLoader.Load("res://path_to_sprite_frames_resource.tres") as SpriteFrames;
        // _animationSprite2D.SpriteFrames = spriteFramesResource;
    }

    private void _changeFace(Vector2 new_face_vector)
    {
        if (new_face_vector.X > 0 && !face_right)
        {
            Scale = new Vector2(-Scale.X,Scale.Y);
            face_right = true;
        }

        else if (new_face_vector.X < 0 && face_right)
        {
            Scale = new Vector2(-Scale.X, Scale.Y);
            face_right = false;

        }
    }

    private void ChangeAni(String new_ani, Vector2 new_face_vector = default)
    {
        _changeFace(new_face_vector);
        if (ani_now != new_ani)
        {
            ani_now = new_ani;
            _animationSprite2D.Play(new_ani);
        }
    }
}
