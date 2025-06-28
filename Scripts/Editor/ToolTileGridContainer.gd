@tool

extends Node3D

var StartPosition = Vector3.ZERO
@export var tileSize = Vector3(.23,0,.07)
@export var perRow = 5

func _ready() -> void:
	StartPosition = global_position
	Update()
	
func GetPositions():
	var positions = []
	for child in get_children():
		positions.append(child.global_position)
	return positions
	
func GetNextOpenPosition():
	for child in get_children():
		if child.IsAvailable():
			return child
	return null

		
func Update():	
	var amount = get_child_count()
	var index = 0
	var vIndex = 0
	var rows = ceil(amount / float(perRow))
	
	var offset = Vector3(
		(tileSize.x * perRow) / 2.0 - tileSize.x / 2.0,
		0,
		(tileSize.z * rows) / 2.0 - tileSize.z / 2.0
	)
	for x in get_children():
		x.global_position = StartPosition - offset
		var xOffset = tileSize.x * index
		var yOffset = tileSize.z * vIndex
		x.global_position += Vector3(xOffset, 0, yOffset)
		
		index += 1
		if index >= perRow:
			vIndex += 1
			index = 0
		
	
	
