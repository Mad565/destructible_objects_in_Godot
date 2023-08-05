extends RigidBody3D

var hp = 200
# Setting a breakable scene.
@export var resource : Resource

func break_object():
	# Instancing the breakable.
	var breakable = resource.instantiate()
	# Getting the parent of the Area node.
	var parent = self.get_parent()
	# Adding the breakable as a child of the parent.
	parent.add_child(breakable)
	#Setting the breakable's translation and rotation to the Area node.
	breakable.position = self.position
	breakable.rotation_degrees = self.rotation_degrees
	
	# Deleting the Area node.
	self.queue_free()
	pass
 
func _process(_delta):
	if hp <=0:
		break_object()
