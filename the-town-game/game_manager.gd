extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(len(TimeManager.days))
	TimeManager.print_time()
	TimeManager.advance_time([2, 5, 32])
	TimeManager.advance_time([5, 12, 45])
