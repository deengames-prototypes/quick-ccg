extends Node2D

export(String) var affinity = "Triangle" # square/circle/triangle
export(String) var owned_by = "" # player or AI
export(int) var defense = 1
var four_values = [] # up, left, right, down

signal on_click
var data
var power

func _ready():
	# make sure turning stuff off in the editor, doesn't break the game
	$Area2D.visible = true

func set_data(card):
	self.data = card
	self.defense = card["defense"]
	self.four_values = card["four_values"]
	self.affinity = card["affinity"]
	self.owned_by = ""
	self.refresh()

func refresh():
	# Update affinity
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")
	
	# Update numbers
	if Features.FOUR_DIRECTIONAL_CARDS:
		# format: U\nL    R\nD
		# Up, newline, left, four spaces, right, newline, down.
		$Label.text = str(four_values[0]) + "\n" + \
			str(four_values[1]) + "    " + str(four_values[2]) + "\n" + \
			str(four_values[3])
	else:
		$Label.text = str(defense)
	
	# Update powers (extra-life disappears on use)
	if Features.CARD_POWERS and "power" in self.data and self.data["power"] != null:
		self.power = self.data["power"]
		$Power.texture = load("res://assets/" + self.power + ".png")
		$Power.visible = true
	else:
		$Power.visible = false
	

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