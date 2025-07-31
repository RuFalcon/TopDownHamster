extends CharacterBody2D

signal ammo_changed(ammo_count)
signal keys_changed(key_count)

@export var speed = 300.0
@export var max_health: int = 100
@export var max_ammo: int = 100

var bullet_scene = preload("res://scenes/bullet.tscn")

@onready var sprite = $Sprite2D
@onready var weapon_holder = $WeaponHolder
@onready var interaction_area = $InteractionArea
@onready var fire_rate_timer = $FireRateTimer

var current_health: int = 100
var ammo_count: int = 30
var key_count: int = 0
var current_weapon = null
var can_shoot: bool = true

func _ready():
	current_health = max_health
	var game_ui = get_tree().get_root().find_child("GameUI", true, false)
	if game_ui:
		await game_ui.ready
	ammo_changed.emit(ammo_count)
	keys_changed.emit(key_count)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and current_weapon and ammo_count > 0 and can_shoot:
		current_weapon.shoot()
		ammo_count -= 1
		can_shoot = false
		fire_rate_timer.start()
		ammo_changed.emit(ammo_count)

func _physics_process(delta):
	handle_movement()
	
func handle_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
		
func get_ammo(amount):
	ammo_count += amount
	if ammo_count > max_ammo:
		ammo_count = max_ammo
	ammo_changed.emit(ammo_count)
		
func get_key(amount):
	key_count += amount
	keys_changed.emit(key_count)
					
func equip_weapon(weapon_node):
	if current_weapon:
		current_weapon.drop()
		weapon_holder.call_deferred("remove_child", current_weapon)
		get_tree().root.call_deferred("add_child", current_weapon)
		current_weapon.global_position = self.global_position

	current_weapon = weapon_node
	if current_weapon.get_parent() != null:
		current_weapon.get_parent().call_deferred("remove_child", current_weapon)
	weapon_holder.call_deferred("add_child", current_weapon)
	current_weapon.call_deferred("set", "position", Vector2.ZERO)
	current_weapon.call_deferred("equip")
	
	fire_rate_timer.wait_time = 1.0 / current_weapon.fire_rate
	
func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		queue_free()


func _on_fire_rate_timer_timeout() -> void:
	can_shoot = true
