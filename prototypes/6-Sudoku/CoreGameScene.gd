extends Node2D

const RANDOM_MOVE_PROBABILITY = 0.25

var _player_card

var _player_points = 0
var _ai_points = 0
var _turn = "Player"

func _ready():
	_turn = "Player"
	$PlayerDeck.set_cards(Globals.player_hand)
	$PlayerDeck.own_cards("Player")
	
	$AiDeck.set_cards(Globals.current_npc_deck)
	$AiDeck.own_cards("AI")
	$AiDeck.recolour_to_owner()
	
	$PlayerDeck.connect("card_selected", self, "_on_player_card_select")
	$Board.connect("on_tile_click", self, "_on_player_tile_click")
	
	if Features.POINTS_ON_CAPTURE:
		$ScoreLabel.visible = true
		$Board.connect("on_tile_capture", self, "_on_tile_captured")
		
		if Features.SUDOKU_BONUSES:
			$Board.connect("made_sudoku_pattern", self, "_on_sudoku_pattern")
	else:
		$ScoreLabel.visible = false
	
func _on_player_card_select(card):
	_player_card = card
	
func _on_player_tile_click(tile):
	if _player_card != null and tile.occupant == null:
		$PlayerDeck.remove_card(_player_card)
		tile.set_occupant(_player_card)
		_player_card = null
		yield(get_tree().create_timer(1), 'timeout')
		$NewsLabel.text = ""
		_ai_do_something()

# Strategy: pick a random card, pick the best move, play it.
# This is a reasonable facsimile of human behaviour (no good cards,
# drawing out opponent, saving best for last, etc.)
func _ai_do_something():
	_turn = "AI"
	
	### rare crash: we have no cards
	if len($AiDeck.tiles) > 0:
		var random_pick = $AiDeck.tiles[randi() % len($AiDeck.tiles)]
		#var best = _ai_pick_best_by_damage(random_pick)
		var best = _ai_pick_best_by_points(random_pick)
		
		$AiDeck.remove_card(random_pick)
		best.set_occupant(random_pick)
		$Board.check_and_emit_sudoku_points(best, _turn)
	
	_check_for_game_over()
	
	_turn = "Player"

func _check_for_game_over():
	var winner_text = ""
	
	for tile in $Board.tiles:
		if tile.occupant == null: # unoccupied
			return # empty tile, game s'not over yet
	
	if _player_points > _ai_points:
		winner_text = "You win!"
		
		if Features.LEVEL_UP:
			Globals.battles_until_next_level_up -= 1
			if Globals.battles_until_next_level_up == 0:
				Globals.battles_until_next_level_up = Globals.BATTLES_TO_LEVEL_UP
				winner_text += " Level up!"
				Globals.stats_points += Globals.POINTS_PER_LEVEL_UP
			
		$EndGame/Spoils.visible = true
		var spoil = Globals.current_npc_deck[randi() % len(Globals.current_npc_deck)]
		$EndGame/Spoils.set_data(spoil)
		Globals.player_deck.append(spoil)
	elif _player_points == _ai_points:
		winner_text = "Draw!"
		Globals.npc_fighting = null # can rematch
		$EndGame/Spoils.visible = false
	elif _ai_points > _player_points:
		winner_text = "You lose!"
		Globals.npc_fighting = null # can rematch
		$EndGame/Spoils.visible = false
		
	$EndGame.visible = true
	$EndGame/Label.text += winner_text
	
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://MapScene.tscn")
	
func _on_tile_captured(captured_by):
	if captured_by == "AI":
		_ai_points += 1
	else:
		_player_points += 1
	
	_update_score_display()

func _on_sudoku_pattern(who, pattern_type):
	$NewsLabel.text = who + " bonus: " + pattern_type + " pattern! "
	if who == "AI":
		_ai_points += Globals.SUDOKU_PATTERN_POINT_BONUS
	else:
		_player_points += Globals.SUDOKU_PATTERN_POINT_BONUS
	
	_update_score_display()

func _update_score_display():
	$ScoreLabel.text = "Player: " + str(_player_points) + "\nAI: " + str(_ai_points)

#############
# Pick the best move based on points earned.
# Equally weighs by point, meaning it prefers patterns (+3).
# Unless, ya know, you can capture 4 cards in one shot.
#############
func _ai_pick_best_by_points(card):
	var best = null
		
	# x% chance of reverting to damage calculation (seems random).
	# This could also be, ya3ne, *actually* random.
	if randf() <= RANDOM_MOVE_PROBABILITY:
		best = _ai_pick_best_by_damage(card)
	else:
		# Random card, place best move
		var best_score = -1 # score of zero is possible, still should pick it if it's the best move
		
		for tile in $Board.tiles:
			if tile.occupant == null:
				# empty tile, look at adjacencies to calculate number of wins
				var adjacencies = $Board.get_adjacencies(tile)
				var damage_score = 0
	
				for adjacent in adjacencies:
					var target = adjacent.occupant
					if target != null and target.owned_by == card.owned_by:
						damage_score += Globals.calculate_damage(card, [tile.x, tile.y], adjacent.occupant, [adjacent.x, adjacent.y])
				
				var pattern_score = 0
				if best != null:
					pattern_score = len($Board.check_sudoku_patterns(best, _turn)) * Globals.SUDOKU_PATTERN_POINT_BONUS
					
				print("P=" + str(pattern_score) + " D=" + str(damage_score))
				var score = max(damage_score, pattern_score)
				if score > best_score:
					best_score = score
					best = tile
	
	return best

#############
# Pick the best move based on "how many cards do we overpower?"
#############
func _ai_pick_best_by_damage(card):
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
					if target != null and target.owned_by == card.owned_by:
						total_score += Globals.calculate_damage(card, [tile.x, tile.y], adjacent.occupant, [adjacent.x, adjacent.y])
				
				if total_score > best_score:
					best_score = total_score
					best = tile
	
	return best