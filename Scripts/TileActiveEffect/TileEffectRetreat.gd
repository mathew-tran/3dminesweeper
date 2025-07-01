extends TileEffect

class_name TileEffectRetreat

@export var DiscardAmount = 2



@export var TileType : GameTile.FIELD_TILE_TYPE
func GetDescription():
	var string = "Discard upto " + str(DiscardAmount)  + " random"
	match TileType:
		GameTile.FIELD_TILE_TYPE.REVEALED:
			string += " revealed"
		GameTile.FIELD_TILE_TYPE.HIDDEN:
			string += " hidden"
			
	string += " tiles"
	return string
	
func DoAction():
	var amount = DiscardAmount
	while amount > 0:
		var fieldTiles = []
		match TileType:
			GameTile.FIELD_TILE_TYPE.REVEALED:
				fieldTiles = Finder.GetGame().GetRevealedTiles()
			GameTile.FIELD_TILE_TYPE.HIDDEN:
				fieldTiles = Finder.GetGame().GetNonRevealedTiles()
			GameTile.FIELD_TILE_TYPE.ANY:
				fieldTiles = Finder.GetGame().GetFieldTiles()
		if fieldTiles.size() == 0:
			return
		fieldTiles.shuffle()
		var fieldTile = fieldTiles.pop_front()
		print("discarding a tile: " + fieldTile.TileTitle)
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, fieldTile.global_position, 5, CustomPathToEffect.EFFECT_COLOR.BLACK)
		await effect.DestinationComplete
		await fieldTile.PushToGraveyard()
		Finder.GetGame().OnDiscardTile.emit()
		await Finder.GetGame().CompleteActions()
		amount -= 1
