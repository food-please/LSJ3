extends Node

@export var tracks: Array[AudioStream]

var _fade_tween: Tween = null
var _last_three_track_indices: Array[int] = []

@onready var _music: = $Music as AudioStreamPlayer
@onready var _play_timer: = $PlayTimer as Timer
@onready var _silence_timer: = $SilenceTimer as Timer


func _ready() -> void:
	_play_timer.timeout.connect(_fade.bind(10.0))
	_silence_timer.timeout.connect(_play_new_song)


func start() -> void:
	_play_new_song()


func _fade(fade_time: float) -> void:
	if _fade_tween:
		_fade_tween.kill()
	_fade_tween = create_tween()
	
	_fade_tween.tween_property(_music, "volume_db", -80.0, fade_time)
	_fade_tween.tween_callback(_silence_timer.start)


func _play_new_song() -> void:
	_music.stop()
	
	var index: = randi() % tracks.size()
	if tracks.size() > 3:
		while index in _last_three_track_indices:
			index = randi() % tracks.size()
	
	if _last_three_track_indices.size() > 2:
		_last_three_track_indices.pop_back()
	_last_three_track_indices.push_front(index)
	
	_music.stream = tracks[index]
	_music.volume_db = 0.0
	_music.play()
	
	_play_timer.start(_music.stream.get_length()*2.0)
