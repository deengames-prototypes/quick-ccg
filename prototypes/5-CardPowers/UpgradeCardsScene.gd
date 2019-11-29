extends Node2D

const Card = preload("res://Card.tscn")

func _ready():
	for i in range(len(Globals.player_deck)):
		var card = Globals.player_deck[i]
		var c = Card.instance()
		c.set_data(card)
		var x = i % 9
		var y = i / 9
		c.position = Vector2(x * 68, y * 68)
		add_child(c)
		c.connect("on_click", self, "_upgrade_card", [c])
		self._refresh()
		
		if card in Globals.player_hand:
			c.get_node("ColorRect").color.a = 0.25
		
func _upgrade_card(card):
	if Globals.stats_points > 0:
		Globals.stats_points -= 1
		card.defense += 1
		card.data.defense += 1
		card.refresh()
		self._refresh()

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://MapScene.tscn")

func _on_Button_pressed():
	get_tree().change_scene("res://HandSelectScene.tscn")

func _refresh():
	$Label.text = "Upgrade points: " + str(Globals.stats_points)	