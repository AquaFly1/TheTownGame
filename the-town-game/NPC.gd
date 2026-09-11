extends Resource

class_name NPC

@export var dialogue: String
var talked_to: bool = false
var exposed: bool = false
@export var exposes: Array[NPC]
##0: Monday 1: Tuesday 2: Wednesday 3: Thursday 4: Friday 5: Saturday 6: Sunday
@export var exposure_days: Array[int] = [0,1,2,3,4,5,6]

func interact():
	if not talked_to:
		talked_to = true
