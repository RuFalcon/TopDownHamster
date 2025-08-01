extends EnemyBase

@export var enemy_bullet_scene: PackedScene
@export var fire_rate: float = 2.0
@export var bullet_damage: int = 5
@export var bullet_speed: float = 700.0

var can_shoot: bool = true

@onready var attack_timer: Timer = $AttackTimer
@onready var muzzle: Marker2D = $Muzzle


func _initialize_enemy():
	attack_timer.wait_time = 1.0 / fire_rate

func _perform_movement_logic(delta):
	if player_ref:
		velocity = Vector2.ZERO
		look_at(player_ref.global_position)
	else:
		velocity = Vector2.ZERO

func _perform_attack_logic(delta):
	if player_ref and can_shoot:
		attack()

func attack():
	can_shoot = false
	attack_timer.start()
	
	if not enemy_bullet_scene:
		print("ОШИБКА: Сцена пули не назначена для стреляющего врага!")
		return
		
	var bullet = enemy_bullet_scene.instantiate()
	
	var fire_direction = (player_ref.global_position - self.global_position).normalized()
	
	bullet.damage = self.bullet_damage
	bullet.speed = self.bullet_speed
	bullet.direction = fire_direction
	
	get_tree().root.add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform

func _on_attack_timer_timeout():
	can_shoot = true
