extends Node2D

const Npc = preload("res://Npc.tscn")

const NUM_NPCS = 5
var _npcs = []

func _ready():
	if Globals.map_data != null:
		Globals.player.position = Globals.map_data["player"]
		
	for i in range(NUM_NPCS):
		var npc = Npc.instance()
		npc.init(i + 1)
		
		if Globals.map_data != null:
			var npcs = Globals.map_data["npcs"]
			npc.position = npcs[i]["position"]
			npc.can_battle = npcs[i]["can_battle"]
		else:
			# set deck
			npc.position = Vector2(40 + (randi() % 520), 40 + (randi() % 460))
	
		npc.connect("starting_battle", self, "_save_map")
		self.add_child(npc)
		_npcs.append(npc)

func _save_map():
	Globals.map_data = {}
	var npcs = []
	for scene in _npcs:
		var npc = { "position": scene.position, "can_battle": scene.can_battle }
		npcs.append(npc)
	
	Globals.map_data = {
		"npcs": npcs,
		"player": Globals.player.position
	}