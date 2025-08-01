extends Area2D

var speed: float = 700.0
var damage: int = 5
var direction: Vector2 = Vector2.ZERO


func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):

	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
		

	if body is TileMapLayer:
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
