# explosion.gd (ФИНАЛЬНАЯ ИСПРАВЛЕННАЯ ВЕРСИЯ)
extends Area2D

var damage = 50

# Массив для хранения врагов, которым мы уже нанесли урон,
# чтобы не бить их дважды.
var hit_enemies = []

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("explode")
	SoundManager.play_sfx("throw_grenade")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	body_entered.connect(_on_body_entered)
	
	await get_tree().create_timer(0.01).timeout
	var initial_bodies = get_overlapping_bodies()
	for body in initial_bodies:
		_on_body_entered(body)


func _on_body_entered(body):
	if body.is_in_group("enemies") and not body in hit_enemies:
		hit_enemies.append(body)
		
		if body.has_method("take_damage"):
			body.take_damage(damage)


func _on_animation_finished():
	queue_free()
