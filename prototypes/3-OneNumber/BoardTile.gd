extends Node2D

export(int) var x = 0;
export(int) var y = 0;

var occupant = null # Card

signal on_click
signal occupied

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var click:InputEventMouseButton = event
		if click.is_pressed():
			self.emit_signal("on_click")

func set_occupant(card):
	self.occupant = card
	card.position = Vector2(0, 0)

	# Rare? crash bug that card already has a parent
	# Can't add child '@@Node2D@34@40' to '@Node2D@10', already has a parent '@Node2D@7'.
	if card.get_parent() != null:
		card.get_parent().remove_child(card)
	
	self.add_child(card)
	self.emit_signal("occupied")