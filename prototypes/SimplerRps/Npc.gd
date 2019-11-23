extends Node2D

const Player = preload("res://Player.tscn")

var deck = []
var _can_battle = true

func init(n):
	$ColorRect/Label.text = str(n)

func _on_Area2D_body_entered(body):
	if _can_battle and body == Globals.player:
		_can_battle = false
		print("BATTLE!")