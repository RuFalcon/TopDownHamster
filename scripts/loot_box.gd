extends StaticBody2D

@export var max_health: int = 1
var current_health: int

@export var loot_scene: PackedScene


func _ready():
	current_health = max_health


func take_damage(amount: int):
	if current_health <= 0:
		return
		
	current_health -= amount
	
	if current_health <= 0:
		destroy_box()


func destroy_box():
	print("Ящик разрушен!")
	SoundManager.play_sfx("box_break")
	if loot_scene:
		var loot_instance = loot_scene.instantiate()
		
		call_deferred("_spawn_loot", loot_instance, self.global_position)
	
	call_deferred("queue_free")
	
func _spawn_loot(loot_instance, spawn_position: Vector2):
	get_tree().root.add_child(loot_instance)
	loot_instance.global_position = spawn_position
