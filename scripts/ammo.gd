extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.get_ammo(25)
		queue_free()
