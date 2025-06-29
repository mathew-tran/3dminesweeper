extends Node3D

@export var CardPoolsCommon : CardPoolData
@export var CardPoolsUncommon : CardPoolData
@export var CardPoolsRare : CardPoolData

signal ShopComplete

var firstSlotData = {
	"common" : 75,
	"uncommon" : 20,
	"rare" : 5,
}
var secondSlotData = {
	"common" : 50,
	"uncommon" : 40,
	"rare" : 10,
}
var thirdSlotData = {
	"common" : 10,
	"uncommon" : 70,
	"rare" : 20,
}
func Setup():
	$Camera3D.make_current()
	Cleanup()
	var cardPools = []
	var commonCards = []
	var unCommonCards = []
	var rareCards = []
	
	for x in CardPoolsCommon.Tiles:
		commonCards.append(x)
		
	for x in CardPoolsUncommon.Tiles:
		unCommonCards.append(x)
		
	for x in CardPoolsRare.Tiles:
		rareCards.append(x)
	
	commonCards.shuffle()
	unCommonCards.shuffle()
	rareCards.shuffle()
	
	cardPools.append(commonCards)
	cardPools.append(unCommonCards)
	cardPools.append(rareCards)
	
	cardPools = SpawnCard(cardPools, thirdSlotData)	
	cardPools = SpawnCard(cardPools, secondSlotData)
	cardPools = SpawnCard(cardPools, firstSlotData)
	
	
	
	#for x in range(0, 3):
		#var tile = cardToPull.pop_front()
		#var instance = tile.instantiate()
		#instance.TileType = GameTile.TILE_TYPE.SHOP_TILE
		#$Tiles.add_child(instance)
		#instance.SceneRef = tile
		#var slot = $GridContainer.GetNextOpenPosition()
		#if slot:
			#slot.Occupy(instance)
			#instance.TileFinishedResolving.connect(OnTileFinishedResolving)

func SpawnCard(cardPools, slotChances):
	var rarity = GameTile.TILE_RARITY.COMMON
	var result = randi() % 100
	if result <= slotChances["common"]:
		pass
	elif result <= slotChances["common"] + slotChances["uncommon"]:
		rarity = GameTile.TILE_RARITY.UNCOMMON
	else:
		rarity = GameTile.TILE_RARITY.RARE
		
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
			
	var instance = card.instantiate()
	instance.TileType = GameTile.TILE_TYPE.SHOP_TILE
	$Tiles.add_child(instance)
	instance.SceneRef = card
	var slot = $GridContainer.GetNextOpenPosition()
	if slot:
		slot.Occupy(instance)
		instance.TileFinishedResolving.connect(OnTileFinishedResolving)
	return cardPools
	
func OnTileFinishedResolving(tileScene):
	ShopComplete.emit()
	Cleanup()
	
	
func Cleanup():
	for x in $Tiles.get_children():
		x.queue_free()
	await get_tree().process_frame 
