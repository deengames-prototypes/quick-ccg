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
	self.add_child(card)
	self.emit_signal("occupied")