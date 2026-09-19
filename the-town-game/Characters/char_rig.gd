extends Node2D

@export var body: Node2D
@export var torso: Node2D
@export var target_master: Node2D
@export var legL: Line2D
@export var foot_legL: Node2D
@export var legR: Line2D
@export var foot_legR: Node2D
@export var legL_target: Node2D
@export var legR_target: Node2D
@export var walk_speed: float
@export var acceleration:float
@export var ground_height: float = 20
@onready var leg_length: float = 20
@export var step_size: float
@export var leg_start_spacing: float = 5

var velocity:= Vector2.ZERO
var foot_turn = 1
var foot_L_mode = 0
var foot_R_mode = 0
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	target_master.global_position = get_viewport().get_mouse_position()
	var vec = (target_master.global_position-(body.global_position+Vector2(0,ground_height)))
	velocity = (velocity.move_toward(vec*5,acceleration*walk_speed*delta)*Vector2(1,1.5)).limit_length(walk_speed)*Vector2(1,1/1.5)
	velocity = velocity.lerp(vec/delta/5,3*delta)
	body.global_position += velocity*delta
	direction = lerp_angle(direction,velocity.angle(),5*delta)
	legL.position.x = leg_start_spacing*-1 * lerp(1.,sin(direction),clamp(velocity.length()/walk_speed,0,1))
	legR.position.x = leg_start_spacing * lerp(1.,sin(direction),clamp(velocity.length()/walk_speed,0,1))
	
	var droop = min(max(
		(foot_legL.global_position.distance_squared_to(legL.global_position + Vector2(0,ground_height)) + leg_length**2)**0.5-leg_length
		,
		(foot_legR.global_position.distance_squared_to(legR.global_position + Vector2(0,ground_height)) + leg_length**2)**0.5-leg_length
		),
		ground_height-10)
	#droop = 0
	#print(height)
	
	torso.global_position.y = body.global_position.y + droop/1 - 8
	torso.rotation = velocity.x/2000
	legL.global_rotation = 0
	legR.global_rotation = 0
	
	if foot_turn != -1: 
		foot_L_mode = velocity.length() > walk_speed/2
	if foot_turn != -2: 
		foot_R_mode = velocity.length() > walk_speed/2
	
	if foot_L_mode: legL_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,ground_height) + legL.position*Vector2.RIGHT
	else: legL_target.global_position = legL.global_position + Vector2(0,ground_height)
	if foot_R_mode:	legR_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,ground_height) + legR.position*Vector2.RIGHT
	else: legR_target.global_position = legR.global_position + Vector2(0,ground_height)

	var step_time = 20/max(walk_speed,velocity.length())
	
	if foot_legL.global_position.distance_to(legL_target.global_position)>5 or foot_legR.global_position.distance_to(legR_target.global_position)>2 :
		if foot_turn == 1:
			foot_turn = -1
			var foot_legL_start = foot_legL.global_position
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_method(func(t):foot_legL.global_position = foot_legL_start.lerp(legL_target.global_position,t) ,0.,1.,step_time).finished.connect(func():foot_turn = 2)
			
		elif foot_turn == 2:
			foot_turn = -2
			var foot_legR_start = foot_legR.global_position
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_method(func(t):foot_legR.global_position = foot_legR_start.lerp(legR_target.global_position,t) ,0.,1.,step_time).finished.connect(func():foot_turn = 1)
	
	
	legL.set_point_position(2,(foot_legL.global_position - legL.global_position).limit_length(leg_length))
	legL.set_point_position(1,solve_IK(legL.points[2],direction,leg_length))
	legR.set_point_position(2,(foot_legR.global_position - legR.global_position).limit_length(leg_length))
	legR.set_point_position(1,solve_IK(legR.points[2],direction,leg_length))
	
	
	
	
func solve_IK(end:Vector2,dir:float,length:float):
	if end.length() > length: return end/2
	var l1 = length/2
	var l2=l1
	var a_angle = acos(end.length()/(l1+l2)) + end.angle()
	var knee_pos = Vector2(cos(a_angle),sin(a_angle))*l1
	
	dir = -cos(dir)
	knee_pos = knee_pos*dir + end/2 * (1-dir)
	return knee_pos
