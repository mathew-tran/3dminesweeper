extends TileEffect

class_name TileEffectDealDamageOnPlayTile


@export var Amount = 1

@export var FieldTileType : GameTile.FIELD_TILE_TYPE
func GetDescription():
	var str = "When a"
	match FieldTileType:
		GameTile.FIELD_TILE_TYPE.REVEALED:
			str += " revealed"
		GameTile.FIELD_TILE_TYPE.HIDDEN:
			str += " hidden"
	str += " tile is played deal " + str(Amount) + " damage to the enemy"
	return str
	
func _ready() -> void:
	Finder.GetGame().OnTilePlayed.connect(OnTilePlayed)

func OnTilePlayed(vis : GameTile.FIELD_TILE_TYPE):
	if FieldTileType == vis or FieldTileType == GameTile.FIELD_TILE_TYPE.ANY:
		await Finder.GetGame().CompleteActions()
		Finder.GetGame().AddAction()
		GetOwningTile().PlaySFX()
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, Finder.GetEnemy().global_position, 10)
		await effect.DestinationComplete
		Finder.GetGame().RemoveAction()
		Finder.GetEnemy().TakeDamage(Amount)
		
