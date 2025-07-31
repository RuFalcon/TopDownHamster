extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 4.0

var is_equipped = false
var can_shoot = true

@onready var sprite = $Sprite2D
@onready var muzzle = $Muzzle
@onready var pickup_collider = $Area2D/CollisionShape2D
	
func _process(delta):
	if is_equipped:
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
	get_tree().root.add_child(bullet)
	bullet.global_transform = muzzle.global_transform
	
func equip():
	is_equipped = true
	pickup_collider.set_deferred("disabled", true)
	
func drop():
	is_equipped = false
	pickup_collider.set_deferred("disabled", false)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("equip_weapon"):
		body.equip_weapon(self)
