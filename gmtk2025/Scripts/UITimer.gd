extends Node2D

@onready var TimerLabel := $TimerLabel

@onready var tween := create_tween()
var game_timer   # Reference to the game timer node
var enabled := false  # Toggle to enable/disable the timer UI

func _ready():
    game_timer = get_tree().get_root().get_node("Main/GameTimer")
    print(get_tree().get_root())
    print("Game Timer Node: ", game_timer)
    enabled = false
    # var game_timer = get_tree().get_root().get_node("Main/GameTimer")

    # timer.connect("timeout", self, "_on_Timer_timeout")

func enable():
    enabled = true
    self.visible = true
    _animate_bounce()

func _process(delta: float) -> void:
    
    if not enabled:
        return 
    
    # Update the label with the current time left
    TimerLabel.text = str("%0.2f" % game_timer.time_left," s")



    _animate_bounce()

    """

    # Update the scale of the label based on time left
    var rect_scale = Vector2(1.0, 1.0)
    if game_timer.time_left <= 10:
        rect_scale = Vector2(1.2, 1.2)
    elif game_timer.time_left <= 5:
        rect_scale = Vector2(1.5, 1.5)
    # Optional: Grow as it approaches 0
    if game_timer.time_left <= 3:
        rect_scale = Vector2(1.3, 1.3)
    else:
        rect_scale = Vector2(1.0, 1.0)

    self.rect_scale = rect_scale
    """


func _animate_bounce():
    tween.kill()

    # var rect_scale = Vector2(1.2, 1.2)
    # tween.tween_property(self, "rect_scale", Vector2(1.0, 1.0), 0.2)\
    #     .set_trans(Tween.TRANS_BOUNCE)\
    #     .set_ease(Tween.EASE_OUT)
