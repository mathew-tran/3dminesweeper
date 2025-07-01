extends Node2D

class_name TileEffect

func DoAction():
	pass

func GetOwningTile():
	return get_parent().get_parent()
