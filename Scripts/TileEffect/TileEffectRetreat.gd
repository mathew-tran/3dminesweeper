extends TileEffect

class_name TileEffectRetreat

@export var DiscardAmount = 2

func GetDescription():
	return "Discard upto " + str(DiscardAmount)  + " random tiles on field"
	
func DoAction():
	var amount = DiscardAmount
	while amount > 0:
		var fieldTiles = Finder.GetGame().GetFieldTiles()
		if fieldTiles.size() == 0:
			return
		fieldTiles.shuffle()
		var fieldTile = fieldTiles.pop_front()
		print("discarding a tile: " + fieldTile.TileTitle)
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, fieldTile.global_position, 10)
		await effect.DestinationComplete
		await fieldTile.PushToGraveyard()
		await get_tree().create_timer(.2).timeout
		amount -= 1
