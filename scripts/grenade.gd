extends CharacterBody2D

@export var explosion_scene: PackedScene

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var launch_velocity: Vector2

func _ready():
	velocity = launch_velocity

func _physics_process(delta):
	velocity.y += gravity * delta
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		explode()

func explode():
	if not explosion_scene:
		print("Сцена взрыва не назначена гранате!")
		queue_free()
		return

	var explosion = explosion_scene.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = self.global_position
	
	queue_free()
