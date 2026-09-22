extends Node

@export var npcs: Array[NPC]
@export var tooltip_scene: PackedScene

@export var lines: int = 0
@export var columns: int = 0


var page: int = 1

func _ready() -> void:
	for i in range(lines):
		var new_line = HBoxContainer.new()
		new_line.custom_minimum_size.y = 500/lines
		get_child(0).add_child(new_line)
		for j in range(columns):
			if len(npcs) > (i+j) * page:
				var tt_inst = tooltip_scene.instantiate()
				new_line.add_child(tt_inst)
				new_line.get_child(j).npc = npcs[(i+j)*page]
