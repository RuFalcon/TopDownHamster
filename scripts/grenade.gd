extends Node2D

var explosion_scene: PackedScene
var target_position: Vector2

@export var flight_duration: float = 0.8 # Время полета в секундах
@export var flight_height: float = 5.5 # "Высота" прыжка (увеличение размера)
@export var final_flight_height: float = 5   

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	fly_to_target()

func fly_to_target():

	var tween = create_tween()

	tween.tween_property(self, "global_position", target_position, flight_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	var scale_tween = create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2.ONE * flight_height, flight_duration / 2.0)\
			   .set_trans(Tween.TRANS_SINE)\
			   .set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(sprite, "scale", Vector2.ONE * final_flight_height, flight_duration / 2.0)\
			   .set_trans(Tween.TRANS_SINE)\
			   .set_ease(Tween.EASE_IN)
	
	tween.finished.connect(explode)

func explode():
	if not explosion_scene:
		print("Сцена взрыва не назначена гранате!")
		queue_free()
		return

	var explosion = explosion_scene.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = self.global_position
	
	queue_free()
