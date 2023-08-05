extends Node3D

func _input(event):
	if event is InputEventMouseMotion:
		sway(Vector2(event.relative.x ,event.relative.y ))
	weapon_switch()
	# IT CHECKS THE SCROLL INPUT.
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				current_weapon = 1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				current_weapon = 2


func _process(delta):
	position.x = lerp(position.x,0.0,delta * 5)
	position.y = lerp(position.y,0.0,delta * 5)
	# WE HAVE CALLED THE WEAPON SWITCH FUNCTION TO USE IT AND TO SWITCH WEAPONS
	weapon_switch()
	# THIS PART RIGHT HERE PREVENTD US FROM GOING OVER THE CHILD AMOUNT CASING A DUAL ERROR
	if current_weapon == get_child_count():
		current_weapon = 0

func sway(sway_amount):
	position.x += sway_amount.x*0.000005
	position.y -= sway_amount.y*0.000005

var current_weapon = 0

func _ready():
	# IT CHECKS THE CHILD COUNT 
	for child in get_child_count():
		# THIS PART DOWN HERE HIDES AND DISABLES THE SCRIPT OF THE DIFFRENT WEAPON IN LOADOUT.
		get_child(child).hide()
		get_child(child).process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		# THIS PART DOWN HERE SHOWS AND ENABLES THE SCRIPT OF THE THE CURRENT WEAPON WHICH IS EQUIPED.
	get_child(current_weapon).show()
	get_child(current_weapon).process_mode = Node.PROCESS_MODE_INHERIT
 
# THIS FUNCTION ALLOWS US SWITCH WEAPON
func weapon_switch():
	for child in get_child_count():
		# THIS PART DOWN HERE HIDES AND DISABLES THE SCRIPT OF THE DIFFRENT WEAPON IN LOADOUT.
		get_child(child).hide()
		get_child(child).process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		# THIS PART DOWN HERE SHOWS AND ENABLES THE SCRIPT OF THE THE CURRENT WEAPON WHICH IS EQUIPED.
	get_child(current_weapon-1).show()
	get_child(current_weapon-1).process_mode = Node.PROCESS_MODE_INHERIT
