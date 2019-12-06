extends Node2D

const BoardTile = preload("res://BoardTile.tscn")
const PADDING = 16

signal on_tile_click
signal on_tile_capture

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
			
			var x_padding = 0
			var y_padding = 0
			if tile.x >= 3:
				x_padding = PADDING
			if tile.y >= 3:
				y_padding = PADDING
				
			tile.position = Vector2(
				(tile.x * Globals.CARD_WIDTH) + x_padding,
				(tile.y * Globals.CARD_HEIGHT) + y_padding)
				
			tile.connect("on_click", self, "_on_tile_click", [tile])
			tile.connect("occupied", self, "_on_tile_occupied", [tile])
			tiles.append(tile)
			add_child(tile)
			
func get_adjacencies(tile):
	# Array of BoardTile.instance
	var adjacencies = []
	
	if tile.x > 0:
		adjacencies.append(tiles[_tile_index(tile.x - 1, tile.y)])
	if tile.x < tiles_wide - 1:
		adjacencies.append(tiles[_tile_index(tile.x + 1, tile.y)])
	if tile.y > 0:
		adjacencies.append(tiles[_tile_index(tile.x, tile.y - 1)])
	if tile.y < tiles_high - 1:
		adjacencies.append(tiles[_tile_index(tile.x, tile.y + 1)])
	
	return adjacencies

func _tile_index(x:int, y:int):
	return (y * tiles_wide) + x

func _on_tile_click(tile):
	self.emit_signal("on_tile_click", tile)

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