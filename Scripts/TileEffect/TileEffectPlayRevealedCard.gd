extends TileEffect

class_name TileEffectPlayRevealedCard

@export var RevealedCardAmount = 2
func GetDescription():
	return "Play upto " + str(RevealedCardAmount) + " revealed cards"
	
func DoAction():
	var revealedTiles = Finder.GetGame().GetRevealedTiles()
	revealedTiles.shuffle()
	var amount = RevealedCardAmount
	while amount > 0:
		if revealedTiles.size() > 0:
			var revealedTile = revealedTiles.pop_front()
			print("Playing a revealed tile: " + revealedTile.TileTitle)
			await revealedTile.DoEffect()
			await revealedTile.PushToGraveyard()
			await get_tree().create_timer(.2).timeout
		amount -= 1
