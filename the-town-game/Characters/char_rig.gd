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
@onready var leg_length: float = 21 + 1
@export var step_size: float

var velocity:= Vector2.ZERO
var foot_turn = 1
var foot_L_mode = 0
var foot_R_mode = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_master.global_position = get_viewport().get_mouse_position()
	velocity = velocity.move_toward((target_master.global_position-(body.global_position+Vector2(0,ground_height)))*5,acceleration*walk_speed*delta).limit_length(walk_speed)
	body.global_position += velocity*delta
	
	if foot_turn != -1: 
		foot_L_mode = velocity.length() > 50
	if foot_turn != -2: 
		foot_R_mode = velocity.length() > 50
	
	if foot_L_mode: legL_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,ground_height) + (legL.global_position - body.global_position)
	else: legL_target.global_position = legL.global_position + Vector2(0,ground_height)
	if foot_R_mode:	legR_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,ground_height) + (legR.global_position - body.global_position)
	else: legR_target.global_position = legR.global_position + Vector2(0,ground_height)
	#legL_target.global_position = body.global_position.move_toward(body.global_position+velocity,min(velocity.length(),step_size)) + Vector2(0,ground_height)
	#legR_target.global_position = legL_target.global_position + (legR.global_position - body.global_position)
	#legL_target.global_position = legL_target.global_position + (legL.global_position - body.global_position)
	
	
	if foot_legL.global_position.distance_to(legL_target.global_position)>5 or foot_legR.global_position.distance_to(legR_target.global_position)>2 :
		if foot_turn == 1:
			foot_turn = -1
			var foot_legL_start = foot_legL.global_position
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_method(func(t):foot_legL.global_position = foot_legL_start.lerp(legL_target.global_position,t) - Vector2( 0,10*(0.25-pow(t-0.5,2)) ),0.,1.,25/walk_speed).finished.connect(func():foot_turn = 2)
			
		elif foot_turn == 2:
			foot_turn = -2
			var foot_legR_start = foot_legR.global_position
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_method(func(t):foot_legR.global_position = foot_legR_start.lerp(legR_target.global_position,t) - Vector2( 0,10*(0.25-pow(t-0.5,2)) ),0.,1.,25/(walk_speed)).finished.connect(func():foot_turn = 1)
	
	
	legL.set_point_position(2,(foot_legL.global_position - legL.global_position).limit_length(leg_length))
	legL.set_point_position(1,solve_IK(legL.points[2],clamp(velocity.x/walk_speed,-1,1),leg_length))
	legR.set_point_position(2,(foot_legR.global_position - legR.global_position).limit_length(leg_length))
	legR.set_point_position(1,solve_IK(legR.points[2],clamp(velocity.x/walk_speed,-1,1),leg_length))
	
	torso.global_position.y = body.global_position.y + ((foot_legL.global_position-legL.global_position).length()-leg_length + (foot_legR.global_position-legR.global_position).length()-leg_length)/5 - 6
	
func solve_IK(end:Vector2,rot:float,length:float):
	#if end.length() > length: return end/2
	var l1 = length/2
	var l2=l1
	var a_angle = acos(end.length()/(l1+l2)) + end.angle()
	var knee_pos = Vector2(cos(a_angle),sin(a_angle))*l1
	rot = -rot
	knee_pos = knee_pos*rot + end/2 * (1-rot)
	return knee_pos
