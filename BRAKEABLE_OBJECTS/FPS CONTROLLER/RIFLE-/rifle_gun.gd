extends Node3D

@onready var raycast := $"../../GUN_RAY"
var can_shoot := true

var is_forward_moving = false
@export var damage: int
@export var ammo: int
@export var max_ammo: int
@export var spare_ammo: int
@export var ammo_per_shot: int
@export var full_auto: bool
@export var reload_time: float
@export var firerate: float
var vertical_recoil : int = 0
var reloading = false
# HEAD IS USED FOR VERTICAL_RECOIL.
@onready var head = $"../../.."
# NOTE THE OUR WEAPON SHOULD BE CHILD OF CAMERA. CAMERA IS USED FOR SIDE_RECOIL.
@onready var camera = $"../.."
@onready var decal = preload("res://FPS CONTROLLER/decal/decal.tscn")

func _process(delta):

	if ammo <= 0:
		can_shoot = false
	if Input.is_action_just_pressed("R") and not reloading and ammo < max_ammo:
		reload()
	if Input.is_action_pressed("fire") and can_shoot and full_auto:
		shoot(delta)
		if not reloading and ammo <= 0: 
			reload()
	elif Input.is_action_just_pressed("fire") and can_shoot and not full_auto:
		shoot(delta)
		if not reloading and ammo <= 0: 
			reload()

func shoot(delta):
	force()
	recoil_func(delta)
	can_shoot = false
	ammo -= ammo_per_shot
	if raycast.get_collider() != null and raycast.get_collider().is_in_group("enemy"):
		raycast.get_collider().hp -= damage
	if $AnimationPlayer != null:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("shoot")
	await get_tree().create_timer(firerate).timeout
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
	if not reloading:
		can_shoot = true

func reload():
	reloading = true
	can_shoot = false
	if $AnimationPlayer != null:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("Reload")
	await get_tree().create_timer(reload_time).timeout
	if reloading == true:
		var ammo_to_add = min(max_ammo - ammo, spare_ammo)
		ammo += ammo_to_add
		spare_ammo -= ammo_to_add
	if ammo > 0:
		can_shoot = true
	reloading = false

func recoil_func(delta):
	# Check if the variable can_fire is True
	if can_shoot:
		# Calculate the horizontal recoil using the randf_range function
		var horizontal_recoil = randf_range(15 ,-15)
		# the strength of recoil.
		var recoil = randf_range(5, -5)
		# Add the vertical recoil to the vertical_recoil variable and multiply by delta
		vertical_recoil += recoil * delta
		# Update the rotation of the head object using the lerpf function
		head.rotation.x = lerpf(head.rotation.x,deg_to_rad(head.rotation_degrees.x + vertical_recoil ),delta)
		# Update the rotation of the camera object using the lerpf function
		camera.rotation.y = lerpf(camera.rotation.y,deg_to_rad(horizontal_recoil),5 * delta)
		# Clamp the vertical recoil to a maximum value of 80
		vertical_recoil = min(90,90)
		# Check if the variable can_fire is still True
	if can_shoot:
		# Set the vertical recoil to 80
		vertical_recoil = 90
		# Clamp the rotation of the head object between -80 and 80 degrees
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
		# If the rotation of the head object is greater than or equal to 80 degrees
		if head.rotation_degrees.x >= 90:
		# Lerp the rotation of the head object towards 30 degrees
			head.rotation_degrees.x = lerpf(head.rotation_degrees.x ,30, 5 * delta)

func force():
	if raycast.get_collider() != null and raycast.get_collider() is RigidBody3D:
		var ray = raycast.get_collision_point()
		var body = raycast.get_collider()
		if body:
			var direction = (ray - global_transform.origin).normalized()
			body.apply_impulse(Vector3(direction.x, direction.y, direction.z) * 5)
