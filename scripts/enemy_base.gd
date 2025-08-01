class_name EnemyBase
extends CharacterBody2D

@export var max_health: int = 50
@export var move_speed: float = 200.0
var current_health: int

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: Area2D = $DetectionArea
@onready var line_of_sight: RayCast2D = $LineOfSight

var player_ref = null
var potential_targets = []

func _ready():
	add_to_group("enemies")
	current_health = max_health
	
	_initialize_enemy()

func _initialize_enemy():
	pass

func _perform_attack_logic(delta):
	pass

func _perform_movement_logic(delta):
	if player_ref:
		nav_agent.target_position = player_ref.global_position
		var next_path_position = nav_agent.get_next_path_position()
		velocity = (next_path_position - global_position).normalized() * move_speed
	else:
		velocity = Vector2.ZERO

func _physics_process(delta):
	check_line_of_sight()
	
	_perform_movement_logic(delta)
	_perform_attack_logic(delta)
	
	move_and_slide()

func check_line_of_sight():
	if potential_targets.is_empty():
		player_ref = null
		return
	var target = potential_targets[0]
	line_of_sight.target_position = target.global_position - self.global_position
	line_of_sight.force_raycast_update()
	if line_of_sight.is_colliding() and line_of_sight.get_collider() == target:
		player_ref = target
	else:
		player_ref = null

func _on_detection_area_body_entered(body):
	if body.is_in_group("player") and not body in potential_targets:
		potential_targets.append(body)

func _on_detection_area_body_exited(body):
	if body.is_in_group("player") and body in potential_targets:
		potential_targets.erase(body)

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()
