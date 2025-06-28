extends Node3D

class_name Game

@export var DeckRef : DeckData

signal PlayerPlayedTile

var Deck = []
var Skips = 0

var LivingTiles = []

var TileAmount = 10

func AddTiles(cardData : CardData):
	for x in range(0, cardData.Amount):
		Deck.append(cardData.Path)
		
func AddTilesIfOpen():
	if $Tiles.get_child_count() != 0:
		return
	while $Tiles.get_child_count() < TileAmount:
		if Deck.size() > 0:
			await get_tree().process_frame
			var tile = Deck.pop_front()
			var instance = tile.instantiate()
			instance.SceneRef = tile
			$Tiles.add_child(instance)
			var nextTileSlot = $TileGridContainer.GetNextOpenPosition()
			if nextTileSlot: 
				nextTileSlot.Occupy(instance)
			instance.TileFinishedResolving.connect(OnTileFinishedResolving)
			await get_tree().process_frame
		else:
			print("game should be over, or we should add tiles back into the deck")
			break

func OnTileFinishedResolving(tileScene):
	Deck.push_back(tileScene)
	await get_tree().process_frame
	AddTilesIfOpen()
	
func _ready() -> void:
	#$TileGridContainer.Update(TileAmount)
	
	DeckRef.CreateDeck()
	Deck.shuffle()
	$TileGridContainer.visible = false
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)
	
	await AddTilesIfOpen()

		
func OnTakeDamage(amount):
	pass

func OnDeath():
	get_tree().reload_current_scene()
	
func PlayTile():
	if Skips > 0:
		Skips -= 1
		return
	PlayerPlayedTile.emit()
	
func SkipTurn():
	Skips += 1
	
func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)
