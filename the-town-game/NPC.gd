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
	exposed = false
	for i in exposure:
		if TimeManager.time[0] == int(i[0]):
			if TimeManager.time[1] > int(i.substr(2,2)):
				exposed = true
			elif TimeManager.time[1] == int(i.substr(2,2)):
				if TimeManager.time[2] >= int(i.substr(5,2)):
					exposed = true
		if TimeManager.time[0] == int(i[8]):
			if TimeManager.time[1] > int(i.substr(10,2)):
				exposed = false
			elif TimeManager.time[1] == int(i.substr(10,2)):
				if TimeManager.time[2] > int(i.substr(13,2)):
					exposed = false
