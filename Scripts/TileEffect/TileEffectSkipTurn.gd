extends TileEffect

class_name TileEffectSkipTurn

func DoAction():
	Finder.GetGame().SkipTurn()
