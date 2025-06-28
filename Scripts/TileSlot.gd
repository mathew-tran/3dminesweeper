extends Node3D

class_name TileSlot

var TileRef : GameTile

func IsAvailable():
	return TileRef == null
	
func Occupy(tile : GameTile):
	TileRef = tile
	tile.global_position = global_position
	tile.TileFinishedResolving.connect(OnTileFinishedResolving)
	
func OnTileFinishedResolving():
	TileRef = null
