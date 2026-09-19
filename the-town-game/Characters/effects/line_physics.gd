extends Line2D

var node_array: Array[PhysicsBody2D]= []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_points()
	for i in get_children():
		if i is PhysicsBody2D:
			node_array.append(i)
	for i in node_array:
		add_point(i.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	node_array[1].position.limit_length(0)
	for i in range(len(node_array)):
		set_point_position(i,node_array[i].position)
	
