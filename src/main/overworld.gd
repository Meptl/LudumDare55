extends Node2D

@onready var player = $OverworldPlayer
@onready var overworld = $Overworld

# func _physics_process(delta):
# 		var around = surrounding(player.position)
# 		overworld.highlight_region(around[0], around[1])


func _input(event):
	if event.is_action_pressed("mine"):
		var around = surrounding(player.position)
		overworld.highlight_region(around[0], around[1])


# Returns the upper left and size of a region containing the position.
# Returns in tile coordinates.
func surrounding(position: Vector2) -> Array[Vector2i]:
	var upperleft = overworld.local_to_map(position)
	var lowerright = upperleft + Vector2i(2, 2)
	var normalized_pos = position / Vector2(overworld.tile_set.tile_size)
	var translate = Vector2i(
		-1 if normalized_pos.x - int(normalized_pos.x) < 0.5 else 0,
		-1 if normalized_pos.y - int(normalized_pos.y) < 0.5 else 0
	)
	return [upperleft + translate, lowerright + translate]
