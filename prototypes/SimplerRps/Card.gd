extends Node2D

export(String) var affinity = "Triangle"
export(int) var strength = 1
export(int) var defense = 1

func set_data(card):
	self.strength = card["strength"]
	self.defense = card["defense"]
	self.affinity = card["affinity"]
	$Label.text = str(strength) + "/" + str(defense)
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")