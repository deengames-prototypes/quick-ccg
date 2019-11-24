#### REMOVED. Doesn't make sense.

extends Node2D

const Card = preload("res://Card.tscn")

var _picked = []

func _ready():
	for i in range(len(Globals.all_cards)):
		var card = Globals.all_cards[i]
		var c = Card.instance()
		c.set_data(card)
		var x = i % 9
		var y = i / 9
		c.position = Vector2(x * 68, y * 68)
		add_child(c)
		c.connect("on_click", self, "_add_to_deck", [c])

func _add_to_deck(card):
	card.get_node("ColorRect").color.a = 0.5
	_picked.append(card.data)
	$Label.text = "Deck: " + str(len(_picked)) + "/12"
	
	if len(_picked) == 12:
		Globals.player_deck = _picked
		get_tree().change_scene("res://MapScene.tscn")