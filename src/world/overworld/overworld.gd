extends TileMap

@onready var highlights = $Highlights


func _ready():
	highlight_region(Vector2(1, 1), Vector2(3, 2))
	await get_tree().create_timer(0.5).timeout
	highlight_region(Vector2(0, 0), Vector2(1, 1))


# This is in tile coordinates.
func highlight_region(upperleft: Vector2i, lowerright: Vector2i):
	var rect_pos = upperleft * tile_set.tile_size
	var rect_size = lowerright * tile_set.tile_size - rect_pos
	highlights.highlight_region(Rect2(rect_pos, rect_size))
