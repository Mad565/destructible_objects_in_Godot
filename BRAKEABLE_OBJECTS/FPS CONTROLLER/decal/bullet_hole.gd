extends Node3D


func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("box"):
		$AudioStreamPlayer3D2.play()
	elif not body is CharacterBody3D:
		$AudioStreamPlayer3D.play()
