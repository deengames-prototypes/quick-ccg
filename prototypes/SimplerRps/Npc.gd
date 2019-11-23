extends Node2D

const Player = preload("res://Player.tscn")

signal starting_battle

var deck = []
var can_battle = true

func init(n):
	$ColorRect/Label.text = str(n)

func _on_Area2D_body_entered(body):
	if can_battle and body == Globals.player:
		can_battle = false
		self.emit_signal("starting_battle")
		get_tree().change_scene("res://CoreGameScene.tscn")