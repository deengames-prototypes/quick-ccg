extends Node2D

const RANDOM_MOVE_PROBABILITY = 0.25

var _player_card

func _ready():
	$PlayerDeck.set_cards(Globals.player_hand)
	$PlayerDeck.own_cards("Player")
	
	$AiDeck.set_cards(Globals.current_npc_deck)
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
	### rare crash: we have no cards
	if len($AiDeck.tiles) > 0:
		var random_pick = $AiDeck.tiles[randi() % len($AiDeck.tiles)]
		var best = null
		
		# x% chance of placing on a random tile
		if randf() <= RANDOM_MOVE_PROBABILITY:
			best = $Board.tiles[randi() % len($Board.tiles)]
			while best.occupant != null:
				best = $Board.tiles[randi() % len($Board.tiles)]
		else:
			# Random card, place best move
			var best_score = -1 # score of zero is possible, still should pick it if it's the best move
			
			for tile in $Board.tiles:
				if tile.occupant == null:
					# empty tile, look at adjacencies to calculate number of wins
					var adjacencies = $Board.get_adjacencies(tile)
					var total_score = 0
		
					for adjacent in adjacencies:
						var target = adjacent.occupant
						if target != null and target.owned_by == random_pick.owned_by:
							total_score += Globals.calculate_damage(random_pick, adjacent.occupant)
					
					if total_score > best_score:
						best_score = total_score
						best = tile
		
		$AiDeck.remove_card(random_pick)
		best.set_occupant(random_pick)
	
	_check_for_game_over()

func _check_for_game_over():
	var player_score = 0
	var ai_score = 0
	
	for tile in $Board.tiles:
		var occupier = tile.occupant
		if occupier == null: # unoccupied
			return
			
		if occupier.owned_by == "AI":
			ai_score += 1
		elif occupier.owned_by == "Player":
			player_score += 1
		else:
			# ???
			return
	
	var winner_text = ""
	if player_score > ai_score:
		winner_text = "You win!"
		Globals.battles_until_next_level_up -= 1
		if Globals.battles_until_next_level_up == 0:
			Globals.battles_until_next_level_up = Globals.BATTLES_TO_LEVEL_UP
			winner_text += " Level up!"
	elif player_score == ai_score:
		winner_text = "Draw!"
		Globals.npc_fighting = null # can rematch
	elif ai_score > player_score:
		winner_text = "You lose!"
		Globals.npc_fighting = null # can rematch
		
	$EndGame.visible = true
	$EndGame/Label.text += winner_text
	
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://MapScene.tscn")
	