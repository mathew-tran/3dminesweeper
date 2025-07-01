extends TileEffect

class_name TileEffectDoNothing

func GetDescription():
	return "Do nothing"

func DoAction():
	await get_tree().create_timer(.1).timeout
	
