extends TileEffect

class_name TileEffectDoDamage
@export var Damage = 3

func GetDescription():
	return "Deals " + str(Damage) + " damage to the enemy"

func DoAction():
	var enemy = Finder.GetEnemy()
	if enemy:
		enemy.TakeDamage(Damage)
		await get_tree().create_timer(.3).timeout
	
