extends Node

var audio_player_array : Array[AudioStreamPlayer]

func play_audio(audio_stream : AudioStream, loop : bool = false) -> void:
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = audio_stream
	audio_player.play()

