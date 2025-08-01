extends WeaponBase

func _post_shoot_effects(bullet_instance):
	var random_angle = randf_range(-spread_angle, spread_angle)
	bullet_instance.rotation_degrees += random_angle
