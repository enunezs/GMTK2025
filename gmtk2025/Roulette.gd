extends Node2D

# Physics properties for the roulette wheel
@export var torque_impulse := 30.0
@export var max_angular_velocity := 20.0
@export var friction := 0.1
@export var bounce_snap_time := 0.5
@export var bounce_ease := 0.4

# Play properties
# @export var direction := "clockwise"  # "clockwise" or "counterclockwise"
@export var clockwise := true  # Use this to determine direction


@onready var wheel := $Wheel
# @onready var tween := $Tween

var final_result_angle := 0.0
var section_angles := [0, 120, 240] # Degrees for R/P/S

func _ready():
    wheel.angular_damp = friction
    # wheel.max_angular_velocity = max_angular_velocity

func apply_push():
    var torque_impulse = torque_impulse if clockwise else -torque_impulse

    wheel.apply_torque_impulse(torque_impulse)

# func snap_to_result():
#     var current_angle = wheel.rotation_degrees % 360
#     final_result_angle = _closest_section_angle(current_angle)

#     wheel.mode = RigidBody2D.MODE_KINEMATIC

#     # Tween to nearest angle
#     tween.interpolate_property(
#         wheel, "rotation_degrees",
#         current_angle,
#         final_result_angle,
#         bounce_snap_time,
#         Tween.TRANS_ELASTIC,
#         Tween.EASE_OUT
#     )
#     tween.start()

func _closest_section_angle(current_angle: float) -> float:
    var closest = section_angles[0]
    var min_diff = abs(current_angle - closest)
    for angle in section_angles:
        var diff = abs(current_angle - angle)
        if diff < min_diff:
            min_diff = diff
            closest = angle
    return closest

func get_result_type() -> String:
    match final_result_angle:
        0: return "rock"
        120: return "paper"
        240: return "scissors"
        _: return "unknown"

