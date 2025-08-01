extends Area2D

var damage = 50
@onready var lifetime_timer = $LifetimeTimer

func _ready():
	lifetime_timer.start()
	lifetime_timer.timeout.connect(queue_free)
	
	body_entered.connect(_on_body_entered)
	
	var initial_bodies = get_overlapping_bodies()
	for body in initial_bodies:
		_on_body_entered(body)


func _on_body_entered(body):
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
