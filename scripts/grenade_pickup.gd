extends Area2D

@export var amount: int = 2

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("add_grenades"):
		body.add_grenades(amount)
		queue_free()
