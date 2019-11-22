extends Node2D

var _player_card

func _ready():
	$PlayerDeck.own_cards("Player")
	$AiDeck.own_cards("AI")
	$AiDeck.recolour_to_owner()
	$PlayerDeck.connect("card_selected", self, "_on_player_card_select")
	$Board.connect("on_tile_click", self, "_on_player_tile_click")

func _on_player_card_select(card):
	_player_card = card
	
func _on_player_tile_click(tile):
	if _player_card != null and tile.occupant == null:
		$PlayerDeck.remove_card(_player_card)
		tile.set_occupant(_player_card)
		_player_card = null
		yield(get_tree().create_timer(1), 'timeout')
		_ai_do_something()

# Strategy: pick a random card, pick the best move, play it.
# This is a reasonable facsimile of human behaviour (no good cards,
# drawing out opponent, saving best for last, etc.)
func _ai_do_something():
	var card_tile = $AiDeck.tiles[randi() % len($AiDeck.tiles)]
	$AiDeck.remove_card(card_tile)
	
	var best = null
	var best_score = -1 # score of zero is possible, still should pick it if it's the best move
	
	for tile in $Board.tiles:
		if tile.occupant == null:
			# empty tile, look at adjacencies to calculate number of wins
			var adjacencies = $Board.get_adjacencies(tile)
			var total_score = 0

			for adjacent in adjacencies:
				var target = adjacent.occupant
				if target != null and target.owned_by != card_tile.owned_by:
					total_score += Globals.calculate_damage(card_tile, adjacent.occupant)
			
			if total_score > best_score:
				best_score = total_score
				best = tile
	
	$AiDeck.remove_card(card_tile)
	best.set_occupant(card_tile)