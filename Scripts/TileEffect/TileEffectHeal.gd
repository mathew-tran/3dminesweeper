extends TileEffect

class_name TileEffectHeal

@export var Amount = 3
func GetDescription():
	return "Heal upto " + str(Amount)  + " HP"
	
func DoAction():
	
	var amountToHeal = Amount
	while amountToHeal > 0:
		Finder.GetGame().Heal(1)
		amountToHeal -= 1
		await get_tree().create_timer(.1).timeout
