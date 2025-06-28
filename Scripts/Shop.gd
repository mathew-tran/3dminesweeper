extends Node3D

@export var CardPoolsEasy : CardPoolData

signal ShopComplete

func Setup():
	$Camera3D.make_current()
	Cleanup()
	var cardToPull = []
	for x in CardPoolsEasy.Tiles:
		cardToPull.append(x)
		
	for x in range(0, 3):
		var tile = cardToPull.pop_front()
		var instance = tile.instantiate()
		instance.TileType = GameTile.TILE_TYPE.SHOP_TILE
		$Tiles.add_child(instance)
		instance.SceneRef = tile
		var slot = $GridContainer.GetNextOpenPosition()
		if slot:
			slot.Occupy(instance)
			instance.TileFinishedResolving.connect(OnTileFinishedResolving)

func OnTileFinishedResolving(tileScene):
	ShopComplete.emit()
	Cleanup()
	
	
func Cleanup():
	for x in $Tiles.get_children():
		x.queue_free()
	await get_tree().process_frame 
