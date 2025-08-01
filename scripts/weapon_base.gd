extends Node2D

class_name WeaponBase

@export var weapon_name: String = "Оружие"
@export var bullet_scene: PackedScene

@export var damage: int = 10
@export var fire_rate: float = 4.0
@export var bullet_speed: float = 800.0
@export var spread_angle: float = 0.0

var is_equipped = false
var is_held_by_player = false
var can_shoot = true

@onready var sprite = $Sprite2D
@onready var muzzle = $Muzzle
@onready var pickup_collider = $Area2D/CollisionShape2D
@onready var pickup_delay_timer = $PickupDelayTimer
	
func _process(delta):
	if is_equipped and is_held_by_player:
		aim()
		
func aim():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var player_node = get_parent().get_parent()
	var player_sprite = player_node.get_node("Sprite2D")
	if player_sprite.flip_h:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
		
func shoot():
	if not bullet_scene:
		print("Сцена пули не назначена!")
		return
			
	var bullet = bullet_scene.instantiate()
	bullet.damage = self.damage
	bullet.speed = self.bullet_speed
	get_tree().root.add_child(bullet)
	bullet.global_transform = muzzle.global_transform
	
	_post_shoot_effects(bullet)
	
func equip():
	is_equipped = true
	pickup_collider.set_deferred("disabled", true)
	
func drop():
	is_equipped = false
	pickup_delay_timer.start()
	
func _post_shoot_effects(bullet_instance):
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("equip_weapon"):
		body.equip_weapon(self)


func _on_pickup_delay_timer_timeout() -> void:
	pickup_collider.disabled = false
