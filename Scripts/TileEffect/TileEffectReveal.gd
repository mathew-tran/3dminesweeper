extends TileEffect

class_name TileEffectRevealTiles

@export var Amount = 1
func GetDescription():
	return "Reveal upto " + str(Amount) + " random tiles"
	
func DoAction():
	var tiles = Finder.GetGame().GetNonRevealedTiles()
	tiles.shuffle()
	var tilesToReveal = Amount
	while tilesToReveal > 0:
		if tiles.size() > 0:
			var tile = tiles.pop_front()
			var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, tile.global_position, 10)
			await effect.DestinationComplete
			await tile.RevealTile()
			await tile.MoveTileToSlot()
		tilesToReveal -= 1
