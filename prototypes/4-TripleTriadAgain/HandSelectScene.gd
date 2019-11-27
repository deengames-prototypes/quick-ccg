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
	var data = card.data
	
	# In hand, remove
	if data in Globals.player_hand:
		Globals.player_hand.remove(Globals.player_hand.find(data))
		_show_unselected(card)
	# Not in hand, add (if sufficient space)
	elif len(Globals.player_hand) < Globals.PLAYER_HAND_SIZE:
		Globals.player_hand.append(data)
		_show_selected(card)
		
	$Label.text = "Hand: " + str(len(Globals.player_hand)) + "/" + str(Globals.PLAYER_HAND_SIZE)

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://MapScene.tscn")

func _on_UpgradeButton_pressed():
	get_tree().change_scene("res://UpgradeCardsScene.tscn")
