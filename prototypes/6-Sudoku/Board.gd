extends Node2D

const BoardTile = preload("res://BoardTile.tscn")

signal on_tile_click
signal on_tile_capture
signal made_sudoku_pattern

export(int) var tiles_wide = 6
export(int) var tiles_high = 6

var tiles = [] # BoardTile.instance

# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(tiles_high):
		for x in range(tiles_wide):
			var tile = BoardTile.instance()
			tile.x = x
			tile.y = y
			
			var green = 1
			var red = 1
			if tile.x >= 3:
				red = 0.5
			if tile.y >= 3:
				green = 0.5
				
			tile.position = Vector2((tile.x * Globals.CARD_WIDTH), (tile.y * Globals.CARD_HEIGHT))
			
			tile.get_node("ColorRect2").self_modulate = Color(red, green, 1)
			#tile.modulate = Color(red, green, 1)
				
			tile.connect("on_click", self, "_on_tile_click", [tile])
			tile.connect("occupied", self, "_on_tile_occupied", [tile])
			tiles.append(tile)
			add_child(tile)
			
func get_adjacencies(tile):
	# Array of BoardTile.instance
	var adjacencies = []
	
	if tile.x > 0:
		adjacencies.append(_tile_at(tile.x - 1, tile.y))
	if tile.x < tiles_wide - 1:
		adjacencies.append(_tile_at(tile.x + 1, tile.y))
	if tile.y > 0:
		adjacencies.append(_tile_at(tile.x, tile.y - 1))
	if tile.y < tiles_high - 1:
		adjacencies.append(_tile_at(tile.x, tile.y + 1))
	
	return adjacencies

func _tile_index(x:int, y:int):
	return (y * tiles_wide) + x

func _owner_at(x:int, y:int):
	var tile = _tile_at(x, y)
	if tile.occupant == null:
		return null
	else:
		return tile.occupant.owned_by

func _tile_at(x, y):
	return tiles[_tile_index(x, y)]

func _on_tile_click(tile):
	self.emit_signal("on_tile_click", tile)
	check_and_emit_sudoku_points(tile, "Player")

func _on_tile_occupied(tile):
	var me = tile.occupant
	var adjacencies = get_adjacencies(tile)
	
	for adjacent in adjacencies:
		var target = adjacent.occupant
		if target != null and target.owned_by != me.owned_by:
			var original_owner = target.owned_by
			var damage = Globals.calculate_damage(me, [tile.x, tile.y], target, [adjacent.x, adjacent.y])
			if damage > 0:
				target.owned_by = me.owned_by
				target.recolour_to_owner()
				self.emit_signal("on_tile_capture", me.owned_by)
			
			if Features.CARD_POWERS:
				if me.power == "Fire":
					me.defense -= 1
					me.data.defense -= 1
					me.refresh()
				
				if me.power == "Virus":
					target.affinity = me.affinity
					target.data.affinity = me.affinity
					target.refresh()
				
				if target.power == "ExtraLife":
					target.power = null
					target.data.power = null
					target.owned_by = original_owner
					target.recolour_to_owner()
					target.refresh()
				
				if target.power == "Diseased":
					me.affinity = target.affinity
					me.data.affinity = target.affinity
					me.refresh()

func check_and_emit_sudoku_points(tile, turn):
	var patterns = check_sudoku_patterns(tile, turn)
	for pattern in patterns:
		self.emit_signal('made_sudoku_pattern', pattern["owner"], pattern["pattern"])
		
########## Returns a bunch of objects for each match, eg. { owner: player, pattern: row }
func check_sudoku_patterns(tile, turn):
	var to_return = []
	
	if Features.SUDOKU_BONUSES:
		# there's always a horizontal row including tile
		var min_x = 3 * (tile.x / 3)
		if _owner_at(min_x, tile.y) == turn and \
			_owner_at(min_x + 1, tile.y) == turn and \
			_owner_at(min_x + 2, tile.y) == turn:
				to_return.append({"owner": turn, "pattern": 'row'})
				print(turn + " captured ROW at min_x=" + str(min_x))
				
		# there's always a vertical row including tile
		var min_y = 3 * (tile.y / 3)
		if _owner_at(tile.x, min_y) == turn and \
			_owner_at(tile.x, min_y + 1) == turn and \
			_owner_at(tile.x, min_y + 2) == turn:
				to_return.append({"owner": turn, "pattern": 'column'})
				print(turn + " captured COLUMN at min_y=" + str(min_y))
	
	return to_return
	
func can_make_pattern(tile, turn):
	var to_return = []
	
	if Features.SUDOKU_BONUSES:
		# there's always a horizontal row including tile
		var min_x = 3 * (tile.x / 3)
		var o1 = _owner_at(min_x, tile.y)
		var o2 = _owner_at(min_x + 1, tile.y)
		var o3 = _owner_at(min_x + 2, tile.y)
		
		if (o1 == null or o1 == turn) and (o2 == turn or o2 == null) and (o3 == turn or o3 == null):
			var count = 0
			if (o1 == null): count += 1
			if (o2 == null): count += 1
			if (o3 == null): count += 1
			
			# We either own or can own three in a row; and only one of those is a blank tile
			if count == 1:
				to_return.append({"owner": turn, "pattern": 'row'})
				
		# there's always a vertical row including tile
		var min_y = 3 * (tile.y / 3)
		o1 = _owner_at(tile.x, min_y)
		o2 = _owner_at(tile.x, min_y + 1)
		o3 = _owner_at(tile.x, min_y + 2)
		
		if (o1 == null or o1 == turn) and (o2 == turn or o2 == null) and (o3 == turn or o3 == null):
			var count = 0
			if (o1 == null): count += 1
			if (o2 == null): count += 1
			if (o3 == null): count += 1
			
			# We either own or can own three in a row; and only one of those is a blank tile
			if count == 1:
				to_return.append({"owner": turn, "pattern": 'column'})
	
	return to_return