extends Node2D

@export var radius: float = 150.0
@export var sections: Array[SectionData]

var default_font : Font = ThemeDB.fallback_font;

@export var default_color: Color = Color.WHITE
@export var border_width: float = 2.0

@export var flip = false # If true, rotate the images


func _draw():
    var segments = 64  # smoothness

    for section in sections:
        var start_rad = deg_to_rad(section.angle_start)
        var end_rad = deg_to_rad(section.angle_end)
        var sweep = end_rad - start_rad
        var color = section.color if section.color else Color.GRAY

        # Create PackedVector2Array for points
        var points := PackedVector2Array()
        points.append(Vector2.ZERO)  # center

        for i in range(segments + 1):
            var t = float(i) / segments
            var angle = start_rad + t * sweep
            points.append(Vector2(cos(angle), sin(angle)) * radius)

        # Create PackedColorArray with same color for each point
        var colors := PackedColorArray()
        for i in range(points.size()):
            colors.append(color)

        draw_polygon(points, colors)

        # Draw section label
        var mid_angle = start_rad + sweep / 2.0
        var label_pos = Vector2(cos(mid_angle), sin(mid_angle)) * (radius * 0.6)
        draw_string(
            default_font,
            label_pos,
            section.type,
            HORIZONTAL_ALIGNMENT_CENTER,
            16
        )

        # Draw borders
        var start_point = Vector2(cos(start_rad), sin(start_rad)) * radius
        var end_point = Vector2(cos(end_rad), sin(end_rad)) * radius
        draw_line(Vector2.ZERO, start_point, Color.BLACK, border_width)
        draw_line(Vector2.ZERO, end_point, Color.BLACK, border_width)

        if section.icon:
            # Distance from center to icon
            var icon_center = Vector2(cos(mid_angle), sin(mid_angle)) * (radius * 0.7)

            # Choose size
            var icon_size = Vector2(48, 48)*1.4
            var top_left = -icon_size / 2.0  # Centered drawing

            # Create a transform that:
            # 1. Translates to the icon center
            # 2. Rotates around that center
            # 3. Draws icon centered
            var transform = Transform2D()
            
            if flip:
                mid_angle += PI  # Flip the icon
            transform = transform.rotated(mid_angle)     # Rotate around Z
            transform.origin = icon_center               # Move to final position

            # Apply transform
            draw_set_transform_matrix(transform)

            # Draw icon centered at origin (because we transformed the canvas)

            draw_texture_rect(section.icon, Rect2(top_left, icon_size), false)

            # Reset transform back to default
            draw_set_transform_matrix(Transform2D())

func get_result_type(target_angle: float = 0.0) -> String:
    # Read Drawer then use rotation to determine the result
    target_angle = fmod(360-target_angle, 360.0)
    if target_angle < 0:
        target_angle += 360.0   
    for section in sections:
        if (section.angle_start <= target_angle) and (target_angle < section.angle_end):
            return section.type
    return "unknown"

# func draw_arc_segment(center, radius, start_angle, sweep_angle, color, points = 32):
#     var points_array = [center]
#     for i in range(points + 1):
#         var angle = start_angle + sweep_angle * (i / float(points))
#         var x = center.x + radius * cos(angle)
#         var y = center.y + radius * sin(angle)
#         points_array.append(Vector2(x, y))
#     draw_colored_polygon(points_array, color)
