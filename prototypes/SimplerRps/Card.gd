extends Node2D

export(String) var affinity = "Triangle"
export(int) var strength = 1
export(int) var defense = 1
export(bool) var can_move = true

signal on_click

func set_data(card):
	self.strength = card["strength"]
	self.defense = card["defense"]
	self.affinity = card["affinity"]
	$Label.text = str(strength) + "/" + str(defense)
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var clicked:InputEventMouseButton = event
		if clicked.is_pressed():
			self.emit_signal("on_click")
