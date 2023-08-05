extends Node3D

@export var damage: int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
@onready var raycast = $"../../RayCast3D"
@onready var decal = preload("res://FPS CONTROLLER/decal/decal.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		force()
		$crowbar/AnimationPlayer.play("HIT")
		if raycast.get_collider() != null and raycast.get_collider().is_in_group("enemy"):
			raycast.get_collider().hp -= damage
		if raycast.is_colliding():
			var col_nor = raycast.get_collision_normal()
			var col_point = raycast.get_collision_point()
			var b = decal.instantiate()
			raycast.get_collider().add_child(b)
			b.global_transform.origin = col_point
			if col_nor == Vector3.DOWN:
				b.rotation_degrees.x = 90
			elif col_nor != Vector3.UP:
				b.look_at(col_point - col_nor, Vector3(0,1,0))
			else:
				b.rotation_degrees.x = 90
func force():
	if raycast.get_collider() != null and raycast.get_collider() is RigidBody3D:
		var ray = raycast.get_collision_point()
		var body = raycast.get_collider()
		if body:
			var direction = (ray - global_transform.origin).normalized()
			body.apply_impulse(Vector3(direction.x, direction.y, direction.z) * 3.5)
