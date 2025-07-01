extends TileEffect

class_name TileEffectSkipTurn

func GetDescription():
	return "Gain an extra turn"
	
func DoAction():
	Finder.GetGame().SkipTurn()
