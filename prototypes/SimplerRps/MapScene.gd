extends Node2D

const Npc = preload("res://Npc.tscn")

const NUM_NPCS = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(NUM_NPCS):
		var npc = Npc.instance()
		# set deck
		npc.position = Vector2(randi() % 560, randi() % 500)
		self.add_child(npc)