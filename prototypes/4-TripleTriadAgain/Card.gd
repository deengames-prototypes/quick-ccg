extends Node2D

export(String) var affinity = "Triangle" # square/circle/triangle
export(String) var owned_by = "" # player or AI
export(int) var defense = 1
var four_values = [] # up, left, right, down

signal on_click
var data

func set_data(card):
	self.data = card
	self.defense = card["defense"]
	self.four_values = card["four_values"]
	self.affinity = card["affinity"]
	self.owned_by = ""
	
	self.refresh()
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")

func refresh():
	if Features.FOUR_DIRECTIONAL_CARDS:
		# format: U\nL    R\nD
		# Up, newline, left, four spaces, right, newline, down.
		$Label.text = str(four_values[0]) + "\n" + \
			str(four_values[1]) + "    " + str(four_values[2]) + "\n" + \
			str(four_values[3])
	else:
		$Label.text = str(defense)

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