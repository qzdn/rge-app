extends Node

@onready var debug:                 bool    = false
@onready var is_window_visible:     bool    = false

@onready var window_resolution:     String  = "1280x720"
@onready var screen_resolution:     Vector2 = get_viewport().size
@onready var vsync:                 bool    = true
@onready var borderless_fullscreen: bool    = true
@onready var volume_master:         float   = -5.0
@onready var volume_sfx:            float   = -10.0
@onready var volume_bgm:            float   = -10.0

@onready var key_char_stats:        Key     = KEY_C
@onready var key_char_tree:         Key     = KEY_T
@onready var key_char_inventory:    Key     = KEY_I

@onready var config = ConfigFile.new()
const SETTINGS_FILE = "res://settings.ini"


func _ready():
    load_settings()
    apply_video_settings()
    apply_audio_settings()
    apply_input_settings()


func load_settings() -> void:
    var err = config.load(SETTINGS_FILE)
    if err == 0: # 0 is "OK" code
        window_resolution       = config.get_value("video",   "window_resolution")
        vsync                   = config.get_value("video",   "vsync")
        borderless_fullscreen   = config.get_value("video",   "borderless_fullscreen")
        volume_master           = config.get_value("volume",  "master")
        volume_sfx              = config.get_value("volume",  "sfx")
        volume_bgm              = config.get_value("volume",  "bgm")
        key_char_stats          = config.get_value("input",   "char_stats")
        key_char_tree           = config.get_value("input",   "char_tree")
        key_char_inventory      = config.get_value("input",   "char_inventory")
    else: 
        save_settings()
        load_settings()


func save_settings() -> void:
    config.set_value("video",   "window_resolution",     window_resolution)
    config.set_value("video",   "vsync",                 vsync)
    config.set_value("video",   "borderless_fullscreen", borderless_fullscreen)
    config.set_value("volume",  "master",                volume_master)
    config.set_value("volume",  "sfx",                   volume_sfx)
    config.set_value("volume",  "bgm",                   volume_bgm)
    config.set_value("input",   "char_stats",            key_char_stats)
    config.set_value("input",   "char_tree",             key_char_tree)
    config.set_value("input",   "char_inventory",        key_char_inventory)
    config.save(SETTINGS_FILE)


func resolution_to_vector2(res: String) -> Vector2:
    var res_parts = res.split("x")
    if res_parts.size() == 2:
        var width = int(res_parts[0])
        var height = int(res_parts[1])
        return Vector2(width, height)
    else:
        return Vector2()


func apply_video_settings() -> void:
    match vsync:
        true:  DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
        false: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
            
    match borderless_fullscreen:
        true:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
            DisplayServer.window_set_size(screen_resolution)
        false:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
            DisplayServer.window_set_size(resolution_to_vector2(window_resolution))
    
    
func apply_audio_settings() -> void:
    AudioServer.set_bus_volume_db(0, volume_master)
    if volume_master <= -50: 
        AudioServer.set_bus_mute(0, true)
    else: 
        AudioServer.set_bus_mute(0, false)

    AudioServer.set_bus_volume_db(1, volume_sfx)
    if volume_sfx <= -50:
        AudioServer.set_bus_mute(1, true)
    else: 
        AudioServer.set_bus_mute(1, false)

    AudioServer.set_bus_volume_db(2, volume_bgm)
    if volume_bgm <= -50:
        AudioServer.set_bus_mute(2, true)
    else: 
        AudioServer.set_bus_mute(2, false)


func apply_input_settings() -> void:
    # TODO: apply_input_settings
    pass 
