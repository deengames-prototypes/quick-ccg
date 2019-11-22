extends Node2D

export(String) var affinity = "Triangle"
export(int) var strength = 1
export(int) var defense = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(strength) + "/" + str(defense)
	$Sprite.texture = load("res://" + affinity.to_lower() + ".png")