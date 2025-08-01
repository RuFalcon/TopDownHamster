extends Area2D

@export var target_door: DoorBase

@export_enum("toggle", "close_only") var action: String = "toggle"

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player") and is_instance_valid(target_door):
		if action == "toggle":
			if target_door.is_open:
				target_door.close()
			else:
				target_door.open()
		elif action == "close_only":
			target_door.close()
