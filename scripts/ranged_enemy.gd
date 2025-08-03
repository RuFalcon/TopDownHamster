extends EnemyBase

@export var fire_rate: float = 2.0
@export var weapon_scene: PackedScene

var current_weapon = null

var can_shoot: bool = true

@onready var attack_timer: Timer = $AttackCooldownTimer
@onready var weapon_holder: Node2D = $WeaponHolder


func _initialize_enemy():
	if weapon_scene:
		current_weapon = weapon_scene.instantiate()
		weapon_holder.add_child(current_weapon)
		current_weapon.set_script(load("res://scripts/enemy_weapon_base.gd"))
		current_weapon.bullet_scene = load("res://scenes/enemy_bullet.tscn")
		current_weapon.is_enemy_weapon = true
		attack_timer.wait_time = 1.0 / (current_weapon.fire_rate * 0.5)
	else:
		print("ОШИБКА: У стреляющего врага нет оружия в WeaponHolder!")

func _physics_process(delta):
	check_line_of_sight()
	
	if player_ref:
		var direction_to_player = (player_ref.global_position - weapon_holder.global_position).normalized()
		
		weapon_holder.rotation = direction_to_player.angle()
		
		if direction_to_player.x < 0:
			weapon_holder.scale.y = -1
		else:
			weapon_holder.scale.y = 1
	
	_perform_movement_logic(delta)
	_perform_attack_logic(delta)
	
	move_and_slide()

func _perform_movement_logic(delta):
	velocity = Vector2.ZERO

func _perform_attack_logic(delta):
	if player_ref and can_shoot and current_weapon:
		attack()

func attack():
	can_shoot = false
	attack_timer.start()
	if not current_weapon: return
	
	var muzzle = current_weapon.get_node_or_null("Muzzle")
	if not muzzle: return
	
	var fire_direction = (player_ref.global_position - muzzle.global_position).normalized()
	
	current_weapon.shoot_at_direction(fire_direction)

func _on_attack_timer_timeout():
	can_shoot = true
