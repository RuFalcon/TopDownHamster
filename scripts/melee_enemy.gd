extends EnemyBase

@export var attack_damage: int = 10
@export var attack_rate: float = 1.0
var can_attack: bool = true
var player_in_attack_range = null

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea

func _initialize_enemy():
	attack_cooldown_timer.wait_time = 1.0 / attack_rate
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	
func _perform_attack_logic(delta):
	if player_in_attack_range and can_attack:
		attack()
		
func attack():
	can_attack = false
	attack_cooldown_timer.start()
	if player_in_attack_range:
		player_in_attack_range.take_damage(attack_damage)
		
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_attack_range = body
		
func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_range = null
		
func _on_attack_cooldown_timer_timeout():
	can_attack = true
