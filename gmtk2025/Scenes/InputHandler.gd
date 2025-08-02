extends Node2D

signal spin_requested(player_id: int)

func _input(event):
    if event.is_action_pressed("player1_spin"):
        emit_signal("spin_requested", 1)
        print("Spin requested by player 1")

    if event.is_action_pressed("player2_spin"):
        emit_signal("spin_requested", 2)
        print("Spin requested by player 2")
