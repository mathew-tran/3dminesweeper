extends Resource

class_name DeckData

@export var Tiles : Array[CardData]

func CreateDeck():
	for x in Tiles:
		Finder.GetGame().AddTiles(x)
