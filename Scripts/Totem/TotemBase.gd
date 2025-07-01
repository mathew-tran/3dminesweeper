extends Node

class_name TotemBase

@export var TotemImage : Texture2D
@export var TotemTitle = ""
@export var Price = 5

func GetDescription():
	return "this is the totems description"
	
func GetHoverData():
	var data = {}
	data["desc"] = GetDescription()
	data["title"] = TotemTitle
	data["img"] = TotemImage
	data["player"] = true
	return data
	
func Equip():
	pass
	
func Destroy():
	pass
