extends Area2D

@export var hint_text: String = "Need a Key"
@export var y_offset: float = -50.0

@onready var tooltip: Control = $Tooltip
@onready var label: Label = $Tooltip/Label



func _ready():
	# Присваиваем текст из переменной нашему Label
	label.text = hint_text
	# Убеждаемся, что подсказка скрыта при старте
	tooltip.hide()
	
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		tooltip.show()
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		tooltip.hide()
