extends CharacterBody2D

@export var max_health: int = 50
var current_health: int

@export var attack_damage: int = 10
@export var attack_rate: float = 1.0
var can_attack: bool = true
var player_in_attack_range = null

@onready var nav_agent = $NavigationAgent2D
@onready var attack_cooldown_timer = $AttackCooldownTimer
@onready var attack_area = $AttackArea

var player = null

func _ready() -> void:
	add_to_group("enemies")
	current_health = max_health
	attack_cooldown_timer.wait_time = 1.0 / attack_rate
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)

func _physics_process(delta):
	if player:
		nav_agent.target_position = player.global_position
		var next_path_position = nav_agent.get_next_path_position()
		var new_velocity = (next_path_position - global_position).normalized() * 200.0
		velocity = new_velocity
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		
	if player_in_attack_range and can_attack:
		attack()

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player = null

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()
		
func die():
	queue_free()
	
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
