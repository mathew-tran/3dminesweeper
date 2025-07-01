extends TileEffect

class_name TileEffectRevealTiles

@export var Amount = 1
func GetDescription():
	return "Reveal upto " + str(Amount) + " random tiles"
	
func DoAction():
	
	var tilesToReveal = Amount
	while tilesToReveal > 0:
		var tiles = Finder.GetGame().GetNonRevealedTiles()
		if tiles.size() == 0:
			return
		tiles.shuffle()
		var tile = tiles.pop_front()
		var effect = Helper.CreateEffectParticle(GetOwningTile().global_position, tile.global_position, 10, CustomPathToEffect.EFFECT_COLOR.YELLOW)
		await effect.DestinationComplete
		await tile.RevealTile()
		await tile.MoveTileToSlot()
		tilesToReveal -= 1
