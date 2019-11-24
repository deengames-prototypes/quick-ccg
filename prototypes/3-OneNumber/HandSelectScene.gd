#### REMOVED. Doesn't make sense.

extends Node2D

const Card = preload("res://Card.tscn")

var _picked = []

func _ready():
	for i in range(len(Globals.player_deck)):
		var card = Globals.player_deck[i]
		var c = Card.instance()
		c.set_data(card)
		var x = i % 9
		var y = i / 9
		c.position = Vector2(x * 68, y * 68)
		add_child(c)
		
		if card in Globals.player_hand:
			_show_selected(c)
		else:
			_show_unselected(c)
			
		c.connect("on_click", self, "_toggle_hand", [c])

func _show_selected(card):
	card.get_node("ColorRect").color.a = 0.5
	
func _show_unselected(card):
	card.get_node("ColorRect").color.a = 0

func _toggle_hand(card):
	$Label.text = "Hand: " + str(len(_picked)) + "/" + str(Globals.PLAYER_HAND_SIZE)
	#get_tree().change_scene("res://MapScene.tscn")