extends Node2D

const BoardTile = preload("res://BoardTile.tscn")

signal on_tile_click

export(int) var tiles_wide = 4
export(int) var tiles_high = 4

var _tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(tiles_high):
		for x in range(tiles_wide):
			var tile = BoardTile.instance()
			tile.x = x
			tile.y = y
			tile.position = Vector2(tile.x * 64, tile.y * 64)
			tile.connect("on_click", self, "_on_tile_click", [tile])
			_tiles.append(tile)
			add_child(tile)

func _on_tile_click(tile):
	self.emit_signal("on_tile_click", tile)