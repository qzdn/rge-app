extends Control

@onready var canvas_layer = $FadeIn
@onready var color_rect = $FadeIn/ColorRect
@onready var animation_player = $FadeIn/AnimationPlayer
@onready var settings_menu = $Options
static var is_first_run: bool = true


func _ready():
    if is_first_run:
        animation_player.play("fade_in")
        is_first_run = false
    else:
        canvas_layer.visible = false
        color_rect.visible = false


func _on_AnimationPlayer_animation_finished(anim_name: StringName) -> void:
    if anim_name == "fade_in":
        color_rect.visible = false
        canvas_layer.visible = false


func _on_Button_down():
    sfxUI.down_sound()


func _on_Button_up():
    sfxUI.up_sound()


func _on_Button_Start_button_up():
    sfxUI.up_sound()
    # Start app
    # ...


func _on_Button_Settings_button_up():
    sfxUI.up_sound()
    if not Settings.is_window_visible:
        settings_menu.show()
        Settings.is_window_visible = true
    else:
        settings_menu.hide()
        Settings.is_window_visible = false


func _on_Button_Exit_button_up():
    sfxUI.up_sound()
    if NOTIFICATION_WM_CLOSE_REQUEST:
        get_tree().quit()
