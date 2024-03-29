extends Node2D

export(String) var affinity = "Triangle" # square/circle/triangle
export(String) var owned_by = "" # player or AI
export(int) var strength = 1
export(int) var defense = 1

signal on_click
var data

func set_data(card):
	self.data = card
	self.strength = card["strength"]
	self.defense = card["defense"]
	self.affinity = card["affinity"]
	self.owned_by = ""
	
	$Label.text = str(strength) + "/" + str(defense)
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")

func recolour_to_owner():
	if self.owned_by == "AI":
		$ColorRect.color.a = 0.5
	else:
		$ColorRect.color.a = 0
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var clicked:InputEventMouseButton = event
		if clicked.is_pressed():
			self.emit_signal("on_click")
