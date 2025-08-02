extends CharacterBody2D

signal ammo_changed(ammo_count)
signal keys_changed(key_count)
signal grenades_changed(grenade_count)

@export var speed = 300.0
@export var max_health: int = 100
@export var max_ammo: int = 100
@export var grenade_scene: PackedScene
@export var explosion_scene: PackedScene
@export var grenade_launch_force: float = 750.0
@export var melee_hit_scene: PackedScene

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
var grenade_count: int = 100

func _ready():
	current_health = max_health
	var game_ui = get_tree().get_root().find_child("GameUI", true, false)
	if game_ui:
		await game_ui.ready
	ammo_changed.emit(ammo_count)
	keys_changed.emit(key_count)
	grenades_changed.emit(grenade_count)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if current_weapon:
			if ammo_count > 0 and can_shoot:
				current_weapon.shoot()
				ammo_count -= 1
				can_shoot = false
				fire_rate_timer.start()
				ammo_changed.emit(ammo_count)
		else:
			perform_melee_attack()
		
	if Input.is_action_just_pressed("throw_grenade"):
		throw_grenade()
		
func perform_melee_attack():
	if not melee_hit_scene:
		print("Сцена атаки ближнего боя не назначена игроку!")
		return
	
	var hit = melee_hit_scene.instantiate()
	
	add_child(hit)
	
	var direction = Vector2.RIGHT if not sprite.flip_h else Vector2.LEFT
	var offset = 120.0
	hit.position = direction * offset

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
					
func equip_weapon(weapon_node: WeaponBase):
	if current_weapon:
		var old_weapon = current_weapon
		old_weapon.is_held_by_player = false
		weapon_holder.call_deferred("remove_child", old_weapon)
		old_weapon.drop()
		get_tree().root.call_deferred("add_child", old_weapon)
		call_deferred("_place_dropped_weapon", old_weapon, weapon_node.global_position)

	current_weapon = weapon_node
	if current_weapon.get_parent() != null:
		current_weapon.get_parent().call_deferred("remove_child", current_weapon)
	weapon_holder.call_deferred("add_child", current_weapon)
	current_weapon.call_deferred("set", "position", Vector2.ZERO)
	current_weapon.call_deferred("equip")
	current_weapon.is_held_by_player = true
	
	fire_rate_timer.wait_time = 1.0 / current_weapon.fire_rate
	
func _place_dropped_weapon(weapon: WeaponBase, position: Vector2):
	weapon.global_position = position
	
func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		get_tree().reload_current_scene()
		#queue_free()


func _on_fire_rate_timer_timeout() -> void:
	can_shoot = true
	
func throw_grenade():
	if grenade_count > 0 and grenade_scene and explosion_scene:
		grenade_count -= 1
		grenades_changed.emit(grenade_count)
		
		print("Бросаю гранату! Осталось: %d" % grenade_count)
		
		var grenade = grenade_scene.instantiate()
		
		grenade.explosion_scene = self.explosion_scene
		
		grenade.target_position = get_global_mouse_position()
		
		get_tree().root.add_child(grenade)
		
		grenade.global_position = self.global_position
		
func add_grenades(amount: int):
	grenade_count += amount
	grenades_changed.emit(grenade_count)
