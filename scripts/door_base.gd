extends StaticBody2D
class_name DoorBase

@export var is_open_by_default: bool = false

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D

var is_open: bool = false

func _ready():
	if is_open_by_default:
		open(false)
	else:
		close(false)
		
func open(animate: bool = true):
	if is_open:
		return
		
	is_open = true
	collider.set_deferred("disabled", true)
	sprite.visible = false
	
func close(animate: bool = true):
	if not is_open:
		return
	
	is_open = false
	collider.set_deferred("disabled", false)
	sprite.visible = true
