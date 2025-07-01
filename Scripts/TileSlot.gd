extends Node3D

class_name TileSlot

var TileRef : GameTile

func IsAvailable():
	return TileRef == null
	
func Occupy(tile : GameTile):
	TileRef = tile
	var tween = get_tree().create_tween()
	tween.tween_property(tile, "global_position",global_position + Vector3(0, .02, 0), .1 )
	
	tile.TileFinishedResolving.connect(OnTileFinishedResolving)
	await tween.finished
	
func OnTileFinishedResolving(_tile):
	TileRef = null
