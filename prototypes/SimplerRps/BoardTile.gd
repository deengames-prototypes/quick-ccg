extends Node2D

export(int) var x = 0;
export(int) var y = 0;

signal on_click

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var click:InputEventMouseButton = event
		if click.is_pressed():
			self.emit_signal("on_click")