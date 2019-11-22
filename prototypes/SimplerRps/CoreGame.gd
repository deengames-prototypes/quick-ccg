extends Node2D

var _player_card

func _ready():
	$PlayerDeck.connect("card_selected", self, "_on_player_card_select")
	$Board.connect("on_tile_click", self, "_on_player_tile_click")

func _on_player_card_select(card):
	_player_card = card
	
func _on_player_tile_click(tile):
	if _player_card != null:
		# TODO: check if tile is empty
		$PlayerDeck.remove_card(_player_card)
		_player_card = null