extends Control

var drag: bool = false
var offset: Vector2
var x_speed: float = 0.
var last_pos: Vector2

func _on_button_button_down() -> void:
	offset = Vector2(get_global_mouse_position().x - position.x, get_global_mouse_position().y - position.y)
	drag = true
	last_pos = position

func _process(_delta: float) -> void:
	if drag:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", get_global_mouse_position()-offset, 0.01)
	x_speed = position.x - last_pos.x
	x_speed = clampf(x_speed, -20., 20.)
	var rot_tween = get_tree().create_tween()
	rot_tween.tween_property(self, "rotation", x_speed*0.1, 0.4)
	last_pos = position

func _on_button_button_up() -> void:
	drag = false
