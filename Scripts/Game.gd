extends Node3D

class_name Game

@export var DeckRef : DeckData

signal PlayerPlayedTile
signal DeckUpdate

var Deck = []
var Graveyard = []
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
			instance.global_position = Finder.GetTilePreviewSpot().global_position
			$Tiles.add_child(instance)
			var nextTileSlot = $TileGridContainer.GetNextOpenPosition()
			if nextTileSlot: 
				await nextTileSlot.Occupy(instance)
				instance.TileFinishedResolving.connect(OnTileFinishedResolving)
				instance.TileStartResolving.connect(OnTileStartResolving)
			else:
				print("No tile slot to fill! This is a big issue!")
			await get_tree().process_frame
			await get_tree().create_timer(.01).timeout
			DeckUpdate.emit()
		else:
			if Deck.size() <= 0:
				PutGraveyardBackToDeck()
				
func OnTileStartResolving():
	for tile in $Tiles.get_children():
		tile.SetUsable(false)


func PutGraveyardBackToDeck():
	while Graveyard.size() > 0:
		Deck.push_back(Graveyard.pop_front())
		await get_tree().create_timer(.01).timeout
		DeckUpdate.emit()
	Deck.shuffle()
	DeckUpdate.emit()
	
func GetNonRevealedTiles():
	var nonRevealedTiles = []
	for tile in $Tiles.get_children():
		if tile.IsRevealed() == false:
			nonRevealedTiles.append(tile)
	return nonRevealedTiles
	
func GetRevealedTiles():
	var revealedTiles = []
	for tile in $Tiles.get_children():
		if tile.IsRevealed() and tile.IsFlipped() == false:
			revealedTiles.append(tile)
	return revealedTiles
	
func PutTilesBack():
	for tile in $Tiles.get_children():
		Deck.append(tile.SceneRef)
		tile.queue_free()
		
func AddTileScene(tileScene):
	Deck.push_back(tileScene)
	DeckUpdate.emit()

func ShuffleDeck():
	Deck.shuffle()
	
func OnTileFinishedResolving(tileScene):
	if get_tree() == null:
		return
	Graveyard.push_back(tileScene)
	await get_tree().process_frame
	AddTilesIfOpen()
	DeckUpdate.emit()
	for tile in $Tiles.get_children():
		tile.SetUsable(true)
	
func _ready() -> void:
	#$TileGridContainer.Update(TileAmount)
	
	DeckRef.CreateDeck()
	Deck.shuffle()

		
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)
	$Spawner.MonsterKilled.connect(OnMonsterKilled)
	await AddTilesIfOpen()

func GoBackToGameView():
	$Camera3D.make_current()
	
func OnMonsterKilled():
	
	PutTilesBack()
	await PutGraveyardBackToDeck()
	$Shop.Setup()
	
	ShuffleDeck()
	await $Shop.ShopComplete
	GoBackToGameView()
	$Spawner.SpawnMonster()
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

func Heal(amount):
	$HealthComponent.Heal(amount)
