extends Control


@onready var audio_up = $Button/AudioStreamPlayerMouseUp
@onready var audio_down = $Button/AudioStreamPlayerMouseDown


func up_sound():
    audio_up.play()


func down_sound():
    audio_down.play()
