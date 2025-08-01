extends DoorBase

@onready var interaction_area = $InteractionArea

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if is_open:
		return
	if body.is_in_group("player") and body.key_count > 0:
		body.key_count -= 1
		body.keys_changed.emit(body.key_count)
		open()
