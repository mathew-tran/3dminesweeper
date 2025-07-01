extends TileEffect

class_name TileEffectDealDamageOnDiscardTile

@export var Amount = 1

func GetDescription():
	return "When a tile is discarded deal " + str(Amount) + " damage to the enemy"
	
func _ready() -> void:
	Finder.GetGame().OnDiscardTile.connect(OnDiscardTile)

func OnDiscardTile():
	await Finder.GetGame().CompleteActions()
	Finder.GetGame().AddAction()
	GetOwningTile().PlaySFX()
	var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, Finder.GetEnemy().global_position, 10)
	await effect.DestinationComplete
	Finder.GetGame().RemoveAction()
	Finder.GetEnemy().TakeDamage(Amount)
	
