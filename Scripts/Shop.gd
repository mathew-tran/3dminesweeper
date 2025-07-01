extends Node3D

@export var CardPoolsCommon : CardPoolData
@export var CardPoolsUncommon : CardPoolData
@export var CardPoolsRare : CardPoolData
@export var CardPoolsLegendary : CardPoolData

signal ShopComplete

var firstSlotData = {
	"common" : 75,
	"uncommon" : 20,
	"rare" : 4,
	"legendary" : 1
}
var secondSlotData = {
	"common" : 50,
	"uncommon" : 40,
	"rare" : 8,
	"legendary" : 2
}
var thirdSlotData = {
	"common" : 45,
	"uncommon" : 40,
	"rare" : 10,
	"legendary" : 5,
}
var RerollAmount = 3
var DefaultRerollAmount = 3

func PopulateTiles():
	await Cleanup()
	var cardPools = []
	var commonCards = []
	var unCommonCards = []
	var rareCards = []
	var legendaryCards = []
	
	for x in CardPoolsCommon.GetTiles():
		commonCards.append(x)
		
	for x in CardPoolsUncommon.GetTiles():
		unCommonCards.append(x)
		
	for x in CardPoolsRare.GetTiles():
		rareCards.append(x)
	
	for x in CardPoolsLegendary.GetTiles():
		legendaryCards.append(x)
		
	commonCards.shuffle()
	unCommonCards.shuffle()
	rareCards.shuffle()
	legendaryCards.shuffle()
	
	cardPools.append(commonCards)
	cardPools.append(unCommonCards)
	cardPools.append(rareCards)
	cardPools.append(legendaryCards)
	cardPools = SpawnCard(cardPools, thirdSlotData)	
	cardPools = SpawnCard(cardPools, secondSlotData)
	cardPools = SpawnCard(cardPools, firstSlotData)
	await get_tree().create_timer(.25).timeout
	
func Setup():
	$CanvasLayer.visible = true
	RerollAmount = DefaultRerollAmount
	
	UpdateReroll()
	$Camera3D.make_current()
	
	PopulateTiles()	

func SpawnCard(cardPools, slotChances):
	var rarity = GameTile.TILE_RARITY.COMMON
	var result = randi() % 100
	if result <= slotChances["common"]:
		pass
	elif result <= slotChances["common"] + slotChances["uncommon"]:
		rarity = GameTile.TILE_RARITY.UNCOMMON
	elif result <= slotChances["common"] + slotChances["uncommon"] + slotChances["rare"]:
		rarity = GameTile.TILE_RARITY.RARE
	else:
		rarity = GameTile.TILE_RARITY.LEGENDARY
		
	var card = null
	match rarity:
		GameTile.TILE_RARITY.COMMON:
			card = cardPools[0].pop_front()
			print("COMMON")
		GameTile.TILE_RARITY.UNCOMMON:
			card = cardPools[1].pop_front()
			print("UNCOMMON")
		GameTile.TILE_RARITY.RARE:
			card = cardPools[2].pop_front()
			print("RARE")
		GameTile.TILE_RARITY.LEGENDARY:
			card = cardPools[3].pop_front()
			
	var cardClass = load(card)
	var instance = cardClass.instantiate()
	instance.TileType = GameTile.TILE_TYPE.SHOP_TILE
	$Tiles.add_child(instance)
	instance.global_position = $TileSpawnPosition.global_position
	instance.SceneRef = cardClass
	var slot = $GridContainer.GetNextOpenPosition()
	if slot:
		slot.Occupy(instance)
		instance.TileFinishedResolving.connect(OnTileFinishedResolving)
	return cardPools
	
func OnTileFinishedResolving(_tileScene):
	ShopComplete.emit()
	Cleanup()
	$CanvasLayer.visible = false
	
	
func Cleanup():
	for x in $Tiles.get_children():
		x.queue_free()
	await get_tree().create_timer(.25).timeout

func UpdateReroll():
	
	$CanvasLayer/Button.disabled = Finder.GetGame().CanAfford(RerollAmount) == false
	$CanvasLayer/Button/MoneyUI.Update(RerollAmount, $CanvasLayer/Button.disabled == false)
func _on_button_button_up() -> void:
	$CanvasLayer/Button.release_focus()
	$CanvasLayer/Button.disabled = false
	$CanvasLayer/Button.visible = false
	Finder.GetGame().RemoveMoney(RerollAmount)
	await PopulateTiles()
	RerollAmount += 2
	UpdateReroll()
	$CanvasLayer/Button.visible = true
	
	


func _on_button_2_button_up() -> void:
	OnTileFinishedResolving(null)
