extends TileEffect

class_name TileEffectPlayRevealedCard

@export var RevealedCardAmount = 2

func GetDescription():
	return "Play upto " + str(RevealedCardAmount) + " revealed cards"
	
func DoAction():
	var amount = RevealedCardAmount
	while amount > 0:
		
		var revealedTiles = Finder.GetGame().GetRevealedTiles()
		if revealedTiles.size() == 0:
			break
		revealedTiles.shuffle()
		var revealedTile = revealedTiles.pop_front()
		print("Playing a revealed tile: " + revealedTile.TileTitle)
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, revealedTile.global_position, 10, CustomPathToEffect.EFFECT_COLOR.BLUE)
		await effect.DestinationComplete
		await revealedTile.DoEffect()
		await Finder.GetGame().CompleteActions()
		await revealedTile.PushToGraveyard()
		await get_tree().create_timer(.2).timeout
		amount -= 1
	
