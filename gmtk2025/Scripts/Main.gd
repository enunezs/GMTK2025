extends Node2D

# Time settings
@export var game_time := 60.0  # Total game time in seconds
@export var timer_tick := 1.0  # Timer tick in seconds

func _ready():
    # timer 
    var timer = $GameTimer
    timer.wait_time = game_time
    # timer.tick = timer_tick
    timer.start()
    var uitimer = $UI_Timer
    uitimer.enable()


func _on_timer_timeout() -> void:

    # Dissable input
    # $InputHandler.set_process_input(false)

    # Stop wheels
    # $Roulette1.snap_to_result()
    # $Roulette2.snap_to_result()


    await get_tree().create_timer(0.6).timeout  # Wait for tween

    var r1 = $Roulette_Left.get_result_type()
    var r2 = $Roulette_Right.get_result_type()
    # var result = RPSLogic.evaluate(r1, r2)
    # $UI.display_result(result)


func _on_spin_requested(player_id: int):
    print("Applying spin for player: ", player_id)
    match player_id:
        1: $Roulette_Left.apply_push()
        2: $Roulette_Right.apply_push()
