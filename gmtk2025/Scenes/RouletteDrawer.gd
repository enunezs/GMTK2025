@tool
extends Node2D

# Dummy data to show in the editor
var sections := [
    {"angle_start": 0, "angle_end": 60, "type": "Rock"},
    {"angle_start": 60, "angle_end": 180, "type": "Paper"},
    {"angle_start": 180, "angle_end": 360, "type": "Scissors"}
]

var radius := 100.0
var section_colors := {
    "Rock": Color.RED,
    "Paper": Color.GREEN,
    "Scissors": Color.BLUE
}

@export var default_font: Font

# func _process(_delta):
#     if Engine.is_editor_hint():
#         update()  # redraw continuously while editing

# func _ready():
#     update()  # Redraw when entering the scene


func _draw():
    if default_font == null:
        return  # Prevent errors if font not set

    var segments = 64

    for section in sections:
        var start_rad = deg_to_rad(section.angle_start)
        var end_rad = deg_to_rad(section.angle_end)
        var sweep = end_rad - start_rad
        var color = section_colors.get(section.type, Color.GRAY)

        # Create points for the filled pie section
        var points := PackedVector2Array()
        points.append(Vector2.ZERO)
        for i in range(segments + 1):
            var t = float(i) / segments
            var angle = start_rad + t * sweep
            points.append(Vector2(cos(angle), sin(angle)) * radius)

        # Set all colors the same
        var colors := PackedColorArray()
        for i in range(points.size()):
            colors.append(color)

        draw_polygon(points, colors)

        # Draw label
        var mid_angle = start_rad + sweep / 2.0
        var label_pos = Vector2(cos(mid_angle), sin(mid_angle)) * (radius * 0.6)
        draw_string(
            default_font,
            label_pos,
            section.type,
            HORIZONTAL_ALIGNMENT_CENTER,
            16
        )

        # Draw start and end borders
        var start_point = Vector2(cos(start_rad), sin(start_rad)) * radius
        var end_point = Vector2(cos(end_rad), sin(end_rad)) * radius
        draw_line(Vector2.ZERO, start_point, Color.BLACK, 2.0)
        draw_line(Vector2.ZERO, end_point, Color.BLACK, 2.0)
