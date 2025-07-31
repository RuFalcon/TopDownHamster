extends Area2D

var speed = 800.0
var damage = 10

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	if body.is_in_group("enemies") or body is TileMapLayer:
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
