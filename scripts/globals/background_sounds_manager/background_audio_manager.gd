extends Node

# Probably to categorize the sounds, have them all in a dictionary in AudioEffectsLoader

signal sound_effect_started(sound: AudioStream)
signal sound_effect_finished(sound: AudioStream)

signal music_started(music: AudioStream)
signal music_finished(music: AudioStream)

@onready var music: Node = get_node("Music")
@onready var sound_effects: Node  = get_node("SoundEffects")
@onready var sound_effects_2d: Node  = get_node("SoundEffects2D")

@onready var music_player: AudioStreamPlayer = get_node("Music/MusicPlayer") 
@onready var sound_effects_player: AudioStreamPlayer = get_node("SoundEffects/SoundEffectsPlayer")
@onready var sound_effects_player_2D: AudioStreamPlayer = get_node("SoundEffects2D/SoundEffectsPlayer2D")


func play_music(sound: AudioStream, play_from_position: float = 0) -> void: 
	music_started.emit(sound)
	music_player.stream = sound 
	music_player.play(play_from_position) 
	await music_player.finished
	music_player.stream = null 
	music_finished.emit(sound)


func play_temporary_music(sound: AudioStream, play_from_position: float = 0) -> void: 
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music.add_child(audio_stream_player)
	audio_stream_player.stream = sound 
	audio_stream_player.play(play_from_position)
	music_started.emit(sound)
	await audio_stream_player.finished
	audio_stream_player.queue_free()
	music_finished.emit(sound)


func play_temporary_sound(sound: AudioStream, play_from_position: float = 0, position: Vector2 = Vector2.ZERO) -> void: 
	if position != Vector2.ZERO: 
		var audio_stream_player_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		sound_effects_2d.add_child(audio_stream_player_2d)
		audio_stream_player_2d.stream = sound 
		audio_stream_player_2d.play(play_from_position)
		sound_effect_started.emit(sound) 
		await audio_stream_player_2d.finished
		audio_stream_player_2d.queue_free()
		sound_effect_finished.emit(sound)
		return
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	sound_effects.add_child(audio_stream_player)
	audio_stream_player.stream = sound 
	sound_effect_started.emit(sound) 
	audio_stream_player.play(play_from_position)
	await audio_stream_player.finished
	audio_stream_player.queue_free()
	sound_effect_finished.emit(sound)


func play_sound_effect(sound: AudioStream, play_from_position: float = 0, position: Vector2 = Vector2.ZERO) -> void: 
	if position != Vector2.ZERO: 
		sound_effects_player_2D.stream = sound
		sound_effects_player_2D.play(play_from_position)
		sound_effect_started.emit(sound)
		await sound_effects_player.finished
		sound_effects_player_2D.stream = null
		sound_effect_finished.emit(sound)
		return
	sound_effects_player.stream = sound 
	sound_effects_player.play(play_from_position) 
	sound_effect_started.emit(sound) 
	await sound_effects_player.finished
	sound_effects_player.stream = null 
	sound_effect_finished.emit(sound)
	
	
