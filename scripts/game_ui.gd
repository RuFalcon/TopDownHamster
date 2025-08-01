extends CanvasLayer

@onready var ammo_label = $MarginContainer/VBoxContainer/AmmoLabel
@onready var keys_label = $MarginContainer/VBoxContainer/KeysLabel
@onready var grenades_label = $MarginContainer/VBoxContainer/GrenadesLabel

func update_ammo(new_ammo_count: int):
	ammo_label.text = "Патроны: %d" % new_ammo_count
	
func update_keys(new_key_count: int):
	keys_label.text = "Ключи: %d" % new_key_count

func update_grenades(new_grenade_count: int):
	grenades_label.text = "Гранаты: %d" % new_grenade_count
	
