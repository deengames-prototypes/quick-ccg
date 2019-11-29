extends Node2D

const Player = preload("res://Player.tscn")

signal starting_battle

var deck = []
var can_battle = true
var _number

func init(n):
	$ColorRect/Label.text = str(n)
	self._number = n

func _on_Area2D_body_entered(body):
	if can_battle and body == Globals.player:
		self.emit_signal("starting_battle")
		Globals.current_npc_deck = deck
		Globals.npc_fighting = self._number
		get_tree().change_scene("res://CoreGameScene.tscn")