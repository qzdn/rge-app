extends Node

const GRID_SIZE:  Vector2i = Vector2i(8, 8)
const CELL_SIZE:  Vector2i = Vector2i(300, 300)
const ITEM_SCALE: Vector2 = Vector2(0.9, 0.9)
const ARMOUR_JEWELLERY_TEXTURE_PATH: String = "res://resources/images/ui/bg/Armour_Jewellery_shadow.png"
const ARMOUR_JEWELLERY_COORDS_PATH: String = "res://resources/images/items_poe/Armour_Jewellery.json"
const WEAPONS_TEXTURE_PATH: String = "res://resources/images/ui/bg/Weapons_shadow.png"
const WEAPONS_COORDS_PATH: String = "res://resources/images/items_poe/Weapons.json"

@onready var grid_container = $Items/GridContainer
@onready var bg_timer = $BGDirChangeTimer
@onready var anim_player = $AnimationPlayer

@onready var armour_jewellery_texture: Texture = preload(ARMOUR_JEWELLERY_TEXTURE_PATH)
@onready var weapons_jewellery_texture: Texture = preload(WEAPONS_TEXTURE_PATH)
@onready var previous_screen_size: Vector2i = get_viewport().size
@onready var scroll_speed: int = 24
@onready var directions: Array = [
    Vector2i(scroll_speed, 0),              # to the right
    Vector2i(-scroll_speed, 0),             # left
    Vector2i(0, scroll_speed),              # down
    Vector2i(0, -scroll_speed),             # top
    Vector2i(scroll_speed, scroll_speed),   # down right
    Vector2i(scroll_speed, -scroll_speed),  # up right
    Vector2i(-scroll_speed, scroll_speed),  # down left
    Vector2i(-scroll_speed, -scroll_speed)  # up left
]
@onready var scroll_direction: Vector2i = directions[randi() % directions.size()]
@onready var items: Array = []


func _ready():
    randomize()
    _load_images(armour_jewellery_texture, 
                 ARMOUR_JEWELLERY_TEXTURE_PATH, 
                 ARMOUR_JEWELLERY_COORDS_PATH,
                 items)
    _load_images(weapons_jewellery_texture, 
                 WEAPONS_TEXTURE_PATH, 
                 WEAPONS_COORDS_PATH,
                 items)
    _create_grid(items)
    _start_scrolling()


func _on_bg_dir_change_timer_timeout() -> void:
    anim_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "fade_out":
        scroll_direction = change_scroll_direction()
        if Settings.debug:
            print("New scroll speed: ", scroll_direction)
        _create_grid(items)
        $BG.offset = Vector2i(0,0)
        $Fog.offset = Vector2i(0,0)
        anim_player.play("fade_in")
    elif anim_name == "fade_in":
        bg_timer.start()  # Ensure the timer restarts after the fade-in


func change_scroll_direction() -> Vector2i:
    return directions[randi() % directions.size()]


func get_atlas_data(json_file: String) -> Dictionary:
    var atlas_data: Dictionary = {}
    var json = JSON.new()
    var data: String = FileAccess.open(json_file, FileAccess.READ).get_as_text()
    var err: Error = json.parse(data)
    if err == OK:
        var frames: Dictionary = json.data["frames"]
        for item in frames.keys():
            var x: float = frames[item]["frame"]["x"]
            var y: float = frames[item]["frame"]["y"]
            var w: float = frames[item]["frame"]["w"]
            var h: float = frames[item]["frame"]["h"]
            atlas_data[item] = [x, y, w, h]
        if Settings.debug:
            print(atlas_data)
        return atlas_data
    else: 
        return {"error": json.get_error_message()}


func extract_filename(input_string: String) -> String:
    var start_index = input_string.find("/") + 1
    var end_index = input_string.find(".")
    if start_index == -1 or end_index == -1: 
        return ""
    
    return input_string.substr(start_index, end_index - start_index)


func _load_images(texture, texture_path, coords_path, array):
    if texture == null:
        print("Failed to load atlas texture: ", texture_path)
        return
    
    var atlas_data: Dictionary = get_atlas_data(coords_path)
    if atlas_data.has("error"):
        print("Failed to parse atlas data: ", atlas_data["error"])
        return

    for file_name in atlas_data.keys(): 
        var rect = atlas_data[file_name]
        var atlas_texture_rect = Rect2(rect[0], rect[1], rect[2], rect[3])
        var atlas = AtlasTexture.new()
        atlas.atlas = texture
        atlas.region = atlas_texture_rect
        array.append(atlas)
        
        if Settings.debug:
            print("Loaded image from atlas: ", file_name, " with region: ", atlas_texture_rect)

    if array.size() == 0:
        print("No images found in the atlas data")


func _start_scrolling():
    set_process(true)


func _create_grid(items: Array):
    # Remove old sprites
    for child in grid_container.get_children():
        child.queue_free()

    var grid_width: int = GRID_SIZE.x
    var grid_height: int = GRID_SIZE.y

    # TODO: more random to spawning
    for y in range(grid_height):
        for x in range(grid_width):
            var sprite = Sprite2D.new()
            sprite.texture = items[randi() % items.size()]
            #sprite.scale = ITEM_SCALE * randf_range(0.7, 1.1)
            sprite.position = Vector2(
                x * CELL_SIZE.x * randf_range(0.9, 1.1), 
                y * CELL_SIZE.y * randf_range(0.9, 1.1))
            sprite.rotate(deg_to_rad(randi_range(-45, 45)))
            grid_container.add_child(sprite)

            # Debug: Check if sprite is visible and has texture
            if Settings.debug:
                if sprite.texture:
                    print("Added sprite at position: ", sprite.position, " with texture: ", sprite.texture)
                else:
                    print("Error: Sprite has no texture at position: ", sprite.position)
            
    if Settings.debug:
        print("Grid size is ", grid_container.get_child_count())


# TODO: optimize?
func _process(delta):
    $BG.offset += scroll_direction * delta
    $Fog.offset -= scroll_direction * delta

    var screen_size: Vector2i = get_viewport().size * 2
    if screen_size != previous_screen_size:
        _create_grid(items)  # recreate grid on res change
        previous_screen_size = screen_size

    var max_x = CELL_SIZE.x * GRID_SIZE.x
    var max_y = CELL_SIZE.y * GRID_SIZE.y

    for child in grid_container.get_children():
        if child is Sprite2D:
            child.position += scroll_direction * delta # sprite movement
            
            # sprite movement when out of viewport
            if child.position.x < -CELL_SIZE.x / 2:
                child.position.x += max_x
            elif child.position.x > max_x - CELL_SIZE.x / 2:
                child.position.x -= max_x

            if child.position.y < -CELL_SIZE.y / 2:
                child.position.y += max_y
            elif child.position.y > max_y - CELL_SIZE.y / 2:
                child.position.y -= max_y

            # Debug: Check sprite position
            if Settings.debug:
                print("Sprite position: ", child.position)
