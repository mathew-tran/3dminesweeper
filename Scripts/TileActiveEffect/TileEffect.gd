extends TileEffect

class_name TileEffectDoDamage
@export var Damage = 3

func GetDescription():
	return "Deals " + str(Damage) + " damage"

func DoAction():
	var enemy = Finder.GetEnemy()
	if enemy:
		Finder.GetGame().AddAction()
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, enemy.global_position, 10)
		await effect.DestinationComplete
		enemy.TakeDamage(Damage)
		Finder.GetGame().RemoveAction()
		await get_tree().create_timer(.1).timeout
		await Finder.GetGame().CompleteActions()
	
