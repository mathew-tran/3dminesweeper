extends TileEffect

class_name TileEffectDrawTile

@export var DrawAmount = 2


func GetDescription():
	var string = "Draw upto " + str(DrawAmount)  + " tiles"
	return string
	
func DoAction():
	await Finder.GetGame().AddTilesIfOpen(.14, DrawAmount, false)
	
