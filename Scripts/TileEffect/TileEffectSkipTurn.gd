extends TileEffect

class_name TileEffectSkipTurn

func GetDescription():
	return "Enemy will not attack after flipping this tile"
	
func DoAction():
	Finder.GetGame().SkipTurn()
