extends Node

@onready var ResolutionLabel    = $Settings/Video/Resolution/ResolutionLabel
@onready var ResolutionDropdown = $Settings/Video/Resolution/ResolutionDropdown
@onready var VsyncCheckBox      = $Settings/Video/Vsync/VsyncCheckBox
@onready var BorderlessCheckBox = $Settings/Video/BorderlessFullscreen/BorderlessCheckBox
@onready var VolumeMasterSlider = $Settings/Audio/VolumeMain/VolumeMasterSlider
@onready var VolumeSFXSlider    = $Settings/Audio/VolumeSFX/VolumeSFXSlider
@onready var VolumeBGMSlider    = $Settings/Audio/VolumeBGM/VolumeBGMSlider


func _ready() -> void:
    for i in range(ResolutionDropdown.get_item_count()):
        if ResolutionDropdown.get_item_text(i) == Settings.window_resolution:
            ResolutionDropdown.selected = i
    ResolutionDropdown.text           = Settings.window_resolution
    VsyncCheckBox.button_pressed      = Settings.vsync
    BorderlessCheckBox.button_pressed = Settings.borderless_fullscreen
    VolumeMasterSlider.value          = Settings.volume_master
    VolumeSFXSlider.value             = Settings.volume_sfx
    VolumeBGMSlider.value             = Settings.volume_bgm


func _on_ResolutionDropdown_item_selected(selected) -> void:
    Settings.window_resolution = ResolutionDropdown.get_item_text(selected)
    Settings.apply_video_settings()


func _on_ResolutionDropdown_button_down() -> void:
    sfxUI.down_sound()


func _on_ResolutionDropdown_button_up() -> void:
    sfxUI.up_sound()


func _on_VsyncCheckBox_toggled(toggled_on: bool) -> void:
    match toggled_on:
        true:  Settings.vsync = true
        false: Settings.vsync = false
    Settings.apply_video_settings()
    

func _on_VsyncCheckBox_button_down() -> void:
    sfxUI.down_sound()


func _on_VsyncCheckBox_button_up() -> void:
    sfxUI.up_sound()


func _on_BorderlessCheckBox_toggled(toggled_on: bool) -> void:
    match toggled_on:
        true:
            ResolutionLabel.add_theme_color_override("font_color", "#aaaaaa")
            Settings.borderless_fullscreen = true
            ResolutionDropdown.disabled = true
        false:
            ResolutionLabel.add_theme_color_override("font_color", "#ffffff")
            Settings.borderless_fullscreen = false
            ResolutionDropdown.disabled = false
    Settings.apply_video_settings()


func _on_BorderlessCheckBox_button_down() -> void:
    sfxUI.down_sound()


func _on_BorderlessCheckBox_button_up() -> void:
    sfxUI.up_sound()


func _on_VolumeMasterSlider_value_changed(value: float) -> void:
    Settings.volume_master = value
    Settings.apply_audio_settings()


func _on_VolumeSFXSlider_value_changed(value: float) -> void:
    Settings.volume_sfx = value
    Settings.apply_audio_settings()


func _on_VolumeBGMSlider_value_changed(value: float) -> void:
    Settings.volume_bgm = value
    Settings.apply_audio_settings()


func _on_SaveSettingsButton_button_down() -> void:
    sfxUI.down_sound()


func _on_SaveSettingsButton_button_up() -> void:
    sfxUI.up_sound()
    Settings.save_settings()


func _on_SettingsTab_clicked(tab: int) -> void:
    sfxUI.down_sound()
