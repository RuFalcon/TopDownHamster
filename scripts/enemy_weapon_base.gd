extends WeaponBase

func shoot_at_direction(target_direction: Vector2):
	var muzzle = get_node_or_null("Muzzle")
	if not muzzle:
		print("ОШИБКА: Узел 'Muzzle' не найден в оружии '%s'!" % self.name)
		return
		
	if not bullet_scene:
		print("Сцена пули не назначена для оружия врага!")
		return
	
	var bullet = bullet_scene.instantiate()
	
	bullet.damage = self.damage
	bullet.speed = self.bullet_speed
	
	if bullet.has_method("set_direction"):
		bullet.set_direction(target_direction)
	
	get_tree().root.add_child(bullet)
	bullet.global_position = muzzle.global_position
