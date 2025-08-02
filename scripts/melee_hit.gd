extends Area2D

var damage = 150
var lifetime = 0.2

@onready var lifetime_timer = $LifetimeTimer

func _ready():
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	lifetime_timer.timeout.connect(queue_free)
	
	await get_tree().physics_frame
	
	apply_damage()

func apply_damage():
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(damage)
	
	monitoring = false
