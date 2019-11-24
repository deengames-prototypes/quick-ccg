extends Node2D

const Npc = preload("res://Npc.tscn")

var _npcs = []

func _ready():
	for i in range(Globals.NUM_NPCS):
		var npc = Npc.instance()
		npc.init(i + 1)
		
		if Globals.map_data != null:
			var npcs = Globals.map_data["npcs"]
			npc.position = npcs[i]["position"]
			npc.can_battle = npcs[i]["can_battle"]
		else:
			# set deck
			npc.position = Vector2(40 + (randi() % 520), 40 + (randi() % 460))
	
		if i + 1 == Globals.npc_fighting:
			npc.can_battle = false # defeated!
			print(str(i) + " was defeated!")
			Globals.npc_fighting = -1
			
		npc.deck = Globals.npc_decks[i]
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
		"npcs": npcs
	}

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://HandSelectScene.tscn")