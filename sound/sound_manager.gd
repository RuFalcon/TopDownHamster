extends Node

# --- СЛОВАРЬ ЗВУКОВ ---
# Мы будем хранить здесь все наши звуковые эффекты,
# давая каждому удобное имя (ключ).
var sfx_library = {

	"throw_grenade": preload("res://sound/grenade.mp3"),
	"shoot_laser_bazooka": preload("res://sound/laser-gun.mp3"),
	"ammo": preload("res://sound/ammo.mp3"),
	"pickup_item": preload("res://sound/chime-sound.mp3"),
	"box_break": preload("res://sound/crate-destory.mp3"),
	
}

@onready var sfx_players_container = $SFXPlayers
@onready var music_player = $MusicPlayer

# --- ПУБЛИЧНЫЕ ФУНКЦИИ (API НАШЕГО МЕНЕДЖЕРА) ---

# Функция для проигрывания 2D звука (в определенной точке мира)
func play_sfx_2d(sound_name: String, position: Vector2):
	if not sfx_library.has(sound_name):
		print("Звуковой менеджер: не найден звук '%s'" % sound_name)
		return
	
	# Создаем новый плеер для этого звука
	var player = AudioStreamPlayer2D.new()
	# Устанавливаем его позицию
	player.global_position = position
	# Назначаем ему аудио-поток из нашей библиотеки
	player.stream = sfx_library[sound_name]
	
	# Добавляем плеер в контейнер
	sfx_players_container.add_child(player)
	# Запускаем проигрывание
	player.play()
	
	# Подключаем сигнал, который уничтожит плеер после окончания проигрывания
	player.finished.connect(player.queue_free)


# Функция для проигрывания обычного звука (UI, без позиции)
func play_sfx(sound_name: String):
	if not sfx_library.has(sound_name):
		print("Звуковой менеджер: не найден звук '%s'" % sound_name)
		return
		
	# Создаем плеер, добавляем, назначаем звук, проигрываем и подключаем удаление
	var player = AudioStreamPlayer.new()
	sfx_players_container.add_child(player)
	player.stream = sfx_library[sound_name]
	player.play()
	player.finished.connect(player.queue_free)

# Функция для управления музыкой
func play_music(music_stream: AudioStream):
	music_player.stream = music_stream
	music_player.play()

func stop_music():
	music_player.stop()
