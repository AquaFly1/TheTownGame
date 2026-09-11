extends Resource

class_name NPC

@export var dialogue: String
var talked_to: bool = false
var exposed: bool = false
@export var exposes: Array[NPC]
##d:hh:mm-d:hh:mm
@export var exposure: Array[String]

func interact():
	if not talked_to:
		talked_to = true

#Put in npc scene!
func handle_exposure():
	for i in exposure:
		if TimeManager.time[0] == i[0]:
			if TimeManager.time[1] > i.substr(2,3):
				exposed = true
			if TimeManager.time[1] == i.substr(2,3):
				if TimeManager.time[2] >= i.substr(5,6):
					exposed = true
