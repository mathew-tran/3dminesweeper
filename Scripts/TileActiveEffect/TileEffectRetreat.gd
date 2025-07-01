extends TileEffect

class_name TileEffectRetreat

@export var DiscardAmount = 2

enum TILE_TYPE {
	REVEALED,
	HIDDEN,
	ANY
}

@export var TileType : TILE_TYPE
func GetDescription():
	var string = "Discard upto " + str(DiscardAmount)  + " random"
	match TileType:
		TILE_TYPE.REVEALED:
			string += " revealed"
		TILE_TYPE.HIDDEN:
			string += " hidden"
			
	string += " tiles"
	return string
	
func DoAction():
	var amount = DiscardAmount
	while amount > 0:
		var fieldTiles = []
		match TileType:
			TILE_TYPE.REVEALED:
				fieldTiles = Finder.GetGame().GetRevealedTiles()
			TILE_TYPE.HIDDEN:
				fieldTiles = Finder.GetGame().GetNonRevealedTiles()
			TILE_TYPE.ANY:
				fieldTiles = Finder.GetGame().GetFieldTiles()
		if fieldTiles.size() == 0:
			return
		fieldTiles.shuffle()
		var fieldTile = fieldTiles.pop_front()
		print("discarding a tile: " + fieldTile.TileTitle)
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, fieldTile.global_position, 10)
		await effect.DestinationComplete
		await fieldTile.PushToGraveyard()
		Finder.GetGame().OnDiscardTile.emit()
		await get_tree().create_timer(.2).timeout
		amount -= 1
