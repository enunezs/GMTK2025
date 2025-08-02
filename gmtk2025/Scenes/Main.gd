extends Node2D

func _ready():
    pass
    # var input_handler = $InputHandler
    # input_handler.connect("spin_requested", self, "_on_spin_requested")





func _on_time_up():
    $Roulette1.snap_to_result()
    $Roulette2.snap_to_result()

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
