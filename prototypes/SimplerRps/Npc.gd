extends Node2D

const Player = preload("res://Player.tscn")

var deck = []
var _can_battle = true

func _ready():
	$ColorRect/Label.text = str(Globals.next_npc_id)
	Globals.next_npc_id += 1

func _on_Area2D_body_entered(body):
	if _can_battle and body == Globals.player:
		_can_battle = false
		print("BATTLE!")