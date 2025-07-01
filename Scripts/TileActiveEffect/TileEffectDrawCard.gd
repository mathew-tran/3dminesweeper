extends TileEffect

class_name TileEffectDrawTile

@export var DrawAmount = 2


func GetDescription():
	var string = "Draw upto " + str(DrawAmount)  + " tiles"
	return string
	
func DoAction():
	var amount = DrawAmount
	while amount > 0:
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, Finder.GetTilePreviewSpot().global_position, 5, CustomPathToEffect.EFFECT_COLOR.WHITE)
		await effect.DestinationComplete
		await Finder.GetGame().AddTilesIfOpen(.14, 1)
		amount -= 1
	
