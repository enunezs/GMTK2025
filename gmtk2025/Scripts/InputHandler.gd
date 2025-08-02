extends Node2D

signal spin_requested(player_id: int)

@export var cooldown_time := 0.05  # seconds

var _cooldowns := {
    1: false,
    2: false
}

func _input(event):
    if event.is_action_pressed("player1_spin"):
        _attempt_spin(1)

    if event.is_action_pressed("player2_spin"):
        _attempt_spin(2)

func _attempt_spin(player_id: int):
    if _cooldowns[player_id]:
        return  # Still in cooldown

    emit_signal("spin_requested", player_id)
    _cooldowns[player_id] = true
    _start_cooldown_timer(player_id)


func _start_cooldown_timer(player_id: int):
    var t = Timer.new()
    t.wait_time = cooldown_time
    t.one_shot = true
    t.timeout.connect(func():
        _cooldowns[player_id] = false
        t.queue_free()
    )
    add_child(t)
    t.start()
