extends Node2D

@export var john: NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(len(TimeManager.days))
	TimeManager.print_time()
	john.handle_exposure()
	print(john.exposed)
	TimeManager.advance_time([2, 5, 32])
	john.handle_exposure()
	print(john.exposed)
	TimeManager.advance_time([0, 7, 45])
	john.handle_exposure()
	print(john.exposed)
