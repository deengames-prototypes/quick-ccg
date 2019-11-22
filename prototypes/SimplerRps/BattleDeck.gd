extends Node2D

const BoardTile = preload("res://BoardTile.tscn")

export var size = 8

func _ready():
	for i in range(size):
		# TODO: replace with card
		var card = BoardTile.instance()
		card.position = Vector2(0, i * 64)
		add_child(card)