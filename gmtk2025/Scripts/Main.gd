extends Node2D

# Time settings
@export var game_time := 60.0  # Total game time in seconds
@export var timer_tick := 1.0  # Timer tick in seconds

@onready var roulette_left := $Roulette_Left
@onready var roulette_right := $Roulette_Right
@onready var input_handler := $InputHandler

func _ready():
    # timer 
    var timer = $GameTimer
    timer.wait_time = game_time
    # timer.tick = timer_tick
    timer.start()
    var uitimer = $UI_Timer
    uitimer.enable()

    # Connect signals
    # roulette_left.connect("spin_requested", self, "_on_spin_requested", [1])
    roulette_left.connect("result_changed", _check_results)
    roulette_right.connect("result_changed",_check_results)



# Constantly print status of left wheel
func _check_results():
    # print("Event: Result Changed")
    # print("Left Wheel Type: ", roulette_left.get_result_type(), " | Right Wheel Type: ", roulette_right.get_result_type())

    var r1_type = roulette_left.get_result_type()
    var r2_type = roulette_right.get_result_type()
    print("Left Result: ", r1_type, " | Right Result: ", r2_type)

    # Compare
    var status = evaluate(r1_type, r2_type)
    
    print("Status: ", status)
    # TODO: Update UI with the status
    # $UI.update_status_preview(r1_type, r2_type, status)


# RPS Logic
func evaluate(p1_angle, p2_angle):
    var combination = [p1_angle, p2_angle]
    var status: String
    match combination:
        ["rock", "scissors"], ["scissors", "paper"], ["paper", "rock"]:
            status = "Player 1 Wins"
        ["scissors", "rock"], ["paper", "scissors"], ["rock", "paper"]:
            status = "Player 2 Wins"
        _:
            status = "Draw"
    return status



func _on_timer_timeout() -> void:

    # Dissable input
    input_handler.set_process_input(false)

    # Stop wheels
    roulette_left.snap_to_result()
    roulette_right.snap_to_result()


    await get_tree().create_timer(0.6).timeout  

    # var r1 = $Roulette_Left.get_result_type()
    # var r2 = $Roulette_Right.get_result_type()
    # var result = RPSLogic.evaluate(r1, r2)
    # $UI.display_result(result)

    # Game over, check for winner
    var r1_type = roulette_left.get_result_type()
    var r2_type = roulette_right.get_result_type()
    print("Left Result: ", r1_type, " | Right Result: ", r2_type)
    var status = evaluate(r1_type, r2_type)

    print("Status: ", status)

func _on_spin_requested(player_id: int):
    match player_id:
        1: roulette_left.apply_push()
        2: roulette_right.apply_push()
