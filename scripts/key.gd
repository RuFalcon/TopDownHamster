extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		SoundManager.play_sfx("pickup_item")
		body.get_key(1)
		queue_free()
