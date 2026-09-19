extends Node2D

@export var body: Node2D
@export var target_master: Node2D
@export var legL: Line2D
@export var foot_legL: Node2D
@export var legR: Line2D
@export var foot_legR: Node2D
@export var legL_target: Node2D
@export var legR_target: Node2D
@export var walk_speed: float
@export var acceleration:float
@export var leg_length: float
@export var step_size: float

var velocity:= Vector2.ZERO
var foot_L_moving= false
var foot_R_moving= false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_master.global_position = get_viewport().get_mouse_position()
	velocity = velocity.move_toward((target_master.global_position-(body.global_position+Vector2(0,leg_length)))*5,acceleration*walk_speed*delta).limit_length(walk_speed)
	body.global_position += velocity*delta
	legL_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,leg_length)
	legR_target.global_position = legL_target.global_position + (legR.global_position - body.global_position)
	legL_target.global_position = legL_target.global_position + (legL.global_position - body.global_position)
	if legL.points[0].distance_to(legL.points[1]) > leg_length and not foot_L_moving and not foot_R_moving:
		foot_L_moving = true
		create_tween().tween_property(foot_legL,"global_position",legL_target.global_position,0.1).finished.connect(func():foot_L_moving = false)
	if legR.points[0].distance_to(legR.points[1]) > leg_length and not foot_R_moving and not foot_L_moving:
		foot_R_moving = true
		create_tween().tween_property(foot_legR,"global_position",legR_target.global_position,0.1).finished.connect(func():foot_R_moving = false)
	legL.set_point_position(1,foot_legL.global_position - legL.global_position)
	legR.set_point_position(1,foot_legR.global_position - legR.global_position)
	#print(foot_L_moving," and ",foot_R_moving)
	
