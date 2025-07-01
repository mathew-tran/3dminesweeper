extends Node3D

class_name Game

@export var DeckRef : DeckData


signal PlayerPlayedTile
signal DeckUpdate
signal GraveyardUpdate

var Deck = []
var Graveyard = []
var Skips = 0
var Money = 10

var LivingTiles = []

var TileAmount = 10

enum GAME_STATE {
	CAN_PLAY_TILES,
	RESOLVING,
	ENEMY_TURN,
	SHOP
}

var CurrentState = GAME_STATE.CAN_PLAY_TILES

signal StateUpdate(state)
signal MoneyUpdate
signal OnDiscardTile
signal OnTilePlayed(vis)

var CurrentActions = 0

signal OnActionsCompleted

func CompleteActions():
	while CurrentActions > 0:
		await get_tree().create_timer(.1).timeout
		print(CurrentActions)
	OnActionsCompleted.emit()

func AddAction():
	CurrentActions += 1

func RemoveAction():
	CurrentActions -= 1
		
func AddMoney(amount):
	Money += amount
	MoneyUpdate.emit()
	
func RemoveMoney(amount):
	Money -= amount
	MoneyUpdate.emit()
	
func CanAfford(amount):
	return Money >= amount
	
func GetMoney():
	return Money
	
func CanPlayTiles():
	return CurrentState == GAME_STATE.CAN_PLAY_TILES
	
func SetGameState(state : GAME_STATE):
	CurrentState = state
	StateUpdate.emit(state)

func AddTiles(cardData : CardData):
	for x in range(0, cardData.Amount):
		Deck.append(cardData.Path)
		
func AddTilesIfOpen(delay = -1.0, maxDrawAmount = -1):	
	if delay > 0:
		await get_tree().create_timer(delay).timeout
		
	var drawAmount = maxDrawAmount
	if maxDrawAmount == -1 or $Tiles.get_child_count() == 0:
		drawAmount = TileAmount - $Tiles.get_child_count()
			
	while drawAmount > 0:
		if Deck.size() <= 0:
			await PutGraveyardBackToDeck()
		if Deck.size() > 0:
			SetGameState(GAME_STATE.RESOLVING)
			await get_tree().process_frame
			var tile = Deck.pop_front()
			var instance = tile.instantiate()
			instance.SceneRef = tile
			
			$Tiles.add_child(instance)
			instance.global_position = Finder.GetTilePreviewSpot().global_position
			var nextTileSlot = $TileGridContainer.GetNextOpenPosition()
			if nextTileSlot: 
				await nextTileSlot.Occupy(instance)
				instance.TileFinishedResolving.connect(OnTileFinishedResolving)
				await instance.FlipIfStartReveal()
				DeckUpdate.emit()
			else:
				print("No tile slot to fill! This is a big issue!")
			await get_tree().process_frame
			await get_tree().create_timer(.01).timeout
			
		drawAmount -= 1
				


func PutGraveyardBackToDeck():
	while Graveyard.size() > 0:
		var effect = Helper.CreateEffectParticle(Finder.GetGraveyardPreviewSpot().global_position, Finder.GetTilePreviewSpot().global_position, 80, CustomPathToEffect.EFFECT_COLOR.WHITE)
		await effect.DestinationComplete
		Deck.push_back(Graveyard.pop_front())
		DeckUpdate.emit()
		GraveyardUpdate.emit()
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
			if tile.is_queued_for_deletion() == false:
				revealedTiles.append(tile)
	return revealedTiles
	
func GetFieldTiles():
	var fieldTiles = []
	for tile in $Tiles.get_children():
		if tile.IsFlipped() == false:
			if tile.is_queued_for_deletion() == false:
				fieldTiles.append(tile)
	return fieldTiles
	
func PutTilesBackFromField():
	for tile in $Tiles.get_children():
		Deck.append(tile.SceneRef)
		var tween = get_tree().create_tween()
		tween.tween_property(tile, "global_position", Finder.GetTilePreviewSpot().global_position, .1)
		tween.tween_property(tile, "rotation_degrees", Vector3(180,0, -180), .1)
		tween.tween_property(tile, "scale", Vector3(0,0,0), .2)
		await tween.finished
		tile.queue_free()
		DeckUpdate.emit()
		
func AddTileScene(tileScene):
	Deck.push_back(tileScene)
	DeckUpdate.emit()

func ShuffleDeck():
	Deck.shuffle()
	
func OnTileFinishedResolving(tileScene):
	if get_tree() == null:
		return
	Graveyard.push_back(tileScene)
	GraveyardUpdate.emit()
	await get_tree().process_frame
	AddTilesIfOpen(-1, 0)


func _ready() -> void:

	MoneyUpdate.connect(OnMoneyUpdate)
	OnMoneyUpdate()
	DeckRef.CreateDeck()
	Deck.shuffle()

		
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)
	$Spawner.MonsterKilled.connect(OnMonsterKilled)
	DeckUpdate.emit()
	GraveyardUpdate.emit()
	await AddTilesIfOpen(.5, 0)
	SetGameState(GAME_STATE.CAN_PLAY_TILES)
	#OnMonsterKilled(Finder.GetEnemy())

func OnMoneyUpdate():
	$CanvasLayer/MoneyUI.Update(Money)
	
func GoBackToGameView():
	$Camera3D.make_current()
	
func OnMonsterKilled(enemy):
	
	SetGameState(GAME_STATE.SHOP)
	Finder.GetInfoPopup().ShowInfo(null)
	await CompleteActions()
	
	
	await get_tree().create_timer(1).timeout
	await PutTilesBackFromField()
	await PutGraveyardBackToDeck()	
	await get_tree().create_timer(.25).timeout
	$Shop.Setup()
	enemy.queue_free()
	
	ShuffleDeck()
	await $Shop.ShopComplete
	GoBackToGameView()
	$Spawner.SpawnMonster()
	await AddTilesIfOpen(.5, 0)
	SetGameState(GAME_STATE.CAN_PLAY_TILES)
	
		
func OnTakeDamage(_amount):
	pass

func OnDeath():
	get_tree().reload_current_scene()
	
func CanPlayExtraTurn():
	return Skips > 0
	
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

func GetPlayerPosition():
	return $Sprite3D.global_position
	
