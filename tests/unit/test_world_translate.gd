extends GutTest


func pos_to_tile(position: Vector2, overworld) -> Vector2:
	return position * Vector2(overworld.overworld.tile_set.tile_size)


func test_translate():
	var overworld = load("res://src/main/overworld.tscn").instantiate()
	add_child(overworld)

	var tests = [
		[Vector2(0, 0), [Vector2i(-1, -1), Vector2i(1, 1)]],
		[Vector2(0.3, 0.3), [Vector2i(-1, -1), Vector2i(1, 1)]],
		[Vector2(0.6, 0), [Vector2i(0, -1), Vector2i(2, 1)]],
		[Vector2(0, 0.6), [Vector2i(-1, 0), Vector2i(1, 2)]],
		[Vector2(0.6, 0.6), [Vector2i(0, 0), Vector2i(2, 2)]],
	]

	for test in tests:
		var region = overworld.surrounding(pos_to_tile(test[0], overworld))
		assert_eq(
			region,
			test[1],
			"%s surrounding(%s) == %s" % [test[0], pos_to_tile(test[0], overworld), test[1]]
		)

	overworld.queue_free()
