extends Node2D

var _player_card

func _ready():
	$PlayerDeck.connect("card_selected", self, "_on_player_card_select")
	$Board.connect("on_tile_click", self, "_on_player_tile_click")

func _on_player_card_select(card):
	_player_card = card
	
func _on_player_tile_click(tile):
	if _player_card != null and tile.occupant == null:
		$PlayerDeck.remove_card(_player_card)
		tile.set_occupant(_player_card)
		_player_card = null
		_ai_do_something()

# The hope: pick a random card, pick the best move, play it
func _ai_do_something():
	var tiles = $AiDeck.tiles[randi() % len($AiDeck.tiles)]
	$AiDeck.remove_card(tiles)