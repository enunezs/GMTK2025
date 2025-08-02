extends Node2D

# Physics properties for the roulette wheel
@export var torque_impulse := 30.0
# @export var max_angular_velocity := 20.0
@export var friction := 0.1
@export var mass := 1.0

# Snap properties
@export var bounce_snap_time := 0.5
@export var bounce_ease := 0.4

# Play properties
@export var clockwise := true  # Use this to determine direction

# Mode properties
var final_result_angle := 0.0
var section_angles := [0, 120, 240] # Degrees for R/P/S


var snapping_to_result := false
var snap_tolerance := 1.0  # degrees of allowable error
@export var snap_force := 1000.0  # increase this to rotate faster


# Node references
# @onready var tween := create_tween()
@onready var wheel := $Wheel
# @onready var input_handler := $InputHandler


func _ready():
    wheel.angular_damp = friction
    wheel.mass = mass
    # wheel.mode = RigidBody2D.MODE_RIGID

    # TODO: Potentially, if too fast increase temporarily the damping
    # wheel.max_angular_velocity = max_angular_velocity

func apply_push():
    var new_torque_impulse = torque_impulse if clockwise else -torque_impulse

    wheel.apply_torque_impulse(new_torque_impulse)

func snap_to_result():
    final_result_angle = _closest_section_angle(wheel.rotation_degrees)
    print("Snapping to angle: ", final_result_angle)
    
    # wheel.mode = RigidBody2D.MODE_RIGID
    snapping_to_result = true

# func _physics_process(delta):
#     if snapping_to_result:
#         var current_angle = fmod(wheel.rotation_degrees, 360)
#         var target_angle = fmod(final_result_angle, 360)

#         # change to fmod to handle wrap-around
#         var diff = fmod(target_angle - current_angle + 540, 360) - 180  # shortest signed difference
#         print("Current angle: ", current_angle, " Target angle: ", target_angle, " Diff: ", diff)

#         if abs(diff) < snap_tolerance and abs(wheel.angular_velocity) < 1.0:
#             wheel.angular_velocity = 0.0
#             snapping_to_result = false
#             print("Snapped to target angle: ", wheel.rotation_degrees)
#         else:
#             var torque = sign(diff) * snap_force
#             wheel.apply_torque(torque)
#             print("Applying torque: ", torque, " to reach target angle: ", target_angle)


func snap_to_result2():
    # Capture current state
    print("Snapping to result...")
    var current_angle = wheel.rotation_degrees
    var angular_velocity = wheel.angular_velocity

    # Disable physics
    print("Disabling wheel physics...")
    wheel.freeze = true
    # wheel.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC


    # # Compute closest final result
    # final_result_angle = _closest_section_angle(current_angle)
    # print("Snapping to angle: ", final_result_angle)

    # # Compute angular distance (shortest path)
    # var angle_diff = wrapf(final_result_angle - current_angle, -180.0, 180.0)
    # var target_angle = current_angle + angle_diff

    # # Estimate a duration based on current angular speed
    # var duration = clamp(abs(angle_diff / angular_velocity), 0.5, 2.0)
    # duration = 1  # For testing, set a fixed duration
    # print("Tween duration: ", duration)

    # # Create a smooth tween
    # print("Tween started from ", current_angle, " to ", target_angle)
    # var tween = get_tree().create_tween()
    # tween.tween_property(wheel, "rotation_degrees", target_angle, duration)\
    #     .set_trans(Tween.TRANS_CUBIC)\
    #     .set_ease(Tween.EASE_OUT)

func snap_to_result_wspring():
    # Capture current state
    var current_angle = wheel.rotation_degrees
    var angular_velocity = wheel.angular_velocity

    # Disable physics
    wheel.freeze = true

    # Compute closest final result
    final_result_angle = _closest_section_angle(current_angle)
    var angle_diff = wrapf(final_result_angle - current_angle, -180.0, 180.0)
    var target_angle = current_angle + angle_diff

    # Estimate duration based on angular velocity
    var duration = clamp(abs(angle_diff / angular_velocity), 0.5, 2.0)

    # Bounce offset (proportional to speed and angle diff)
    var bounce_magnitude = clamp(abs(angular_velocity * 10.0), 5.0, 30.0)
    bounce_magnitude = min(abs(angle_diff) * 0.25, bounce_magnitude)  # don't overshoot too far

    # Bounce direction is opposite to the final movement
    # Dont use ternary operator here, it is not supported in Godot 4
    var overshoot_angle = 0.0
    if angle_diff > 0:
        overshoot_angle = target_angle + bounce_magnitude
    else:
        overshoot_angle = target_angle - bounce_magnitude

    print("Current: ", current_angle, ", Target: ", target_angle, ", Overshoot: ", overshoot_angle)

    # Create bounce tween
    var tween = get_tree().create_tween()
    tween.tween_property(wheel, "rotation_degrees", overshoot_angle, duration * 0.7)\
        .set_trans(Tween.TRANS_CUBIC)\
        .set_ease(Tween.EASE_OUT)
    tween.tween_property(wheel, "rotation_degrees", target_angle, duration * 0.3)\
        .set_trans(Tween.TRANS_BOUNCE)\
        .set_ease(Tween.EASE_OUT)

    print("Tween started with bounce back from ", overshoot_angle, " to ", target_angle)


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

