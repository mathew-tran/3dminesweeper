extends StaticBody3D

class_name GameTile

enum TILE_STATE {
	UNCLICKABLE,
	UNFLIPPED,
	FLIPPED
}

enum TILE_TYPE {
	GAME_TILE,
	SHOP_TILE
}

enum TILE_RARITY {
	COMMON, # white
	UNCOMMON, # blue 
	RARE, # yellow,
	LEGENDARY #orange
}
enum FIELD_TILE_TYPE {
	REVEALED,
	HIDDEN,
	ANY
}

enum TILE_VISIBILITY {
	REVEALED,
	NOT_REVEALED
}

var bCanBeUsed = true

@export var TileTitle = "tile Title"


	
signal TileFinishedResolving(tile)

var CurrentState = TILE_STATE.UNFLIPPED
var TileType = TILE_TYPE.GAME_TILE
var TileVisibility = TILE_VISIBILITY.NOT_REVEALED

var SceneRef : PackedScene
var OriginalPosition = Vector2.ZERO

@export var bStartRevealed = false

var Rarity : TILE_RARITY

func GetDescription():
	var description = ""
	if bStartRevealed:
		description += "Starts Revealed\n"
	for effect in $Passives.get_children():
		description += effect.GetDescription() +"\n"
	for effect in $Effects.get_children():
		description += effect.GetDescription() +"\n"
	return description
	
func GetTitle():
	return TileTitle
	
func DetermineRarity():
	var path = scene_file_path
	if path.contains("Rare"):
		Rarity = TILE_RARITY.RARE
	if path.contains("Common"):
		Rarity = TILE_RARITY.COMMON
	if path.contains("Legendary"):
		Rarity = TILE_RARITY.LEGENDARY
	if path.contains("Uncommon"):
		Rarity = TILE_RARITY.UNCOMMON
		
func _ready() -> void:
	print(scene_file_path)
	DetermineRarity()
	if TileType == TILE_TYPE.SHOP_TILE:
		$blockbench_export.rotation_degrees = Vector3.ZERO
		
	
	var rarityMaterial = load("res://Materials/MATERIAL_COMMON.tres")
	match Rarity:
		TILE_RARITY.UNCOMMON:
			rarityMaterial = load("res://Materials/MATERIAL_UNCOMMON.tres")
		TILE_RARITY.RARE:
			rarityMaterial = load("res://Materials/MATERIAL_RARE.tres")
		TILE_RARITY.LEGENDARY:
			rarityMaterial = load("res://Materials/MATERIAL_LEGENDARY.tres")
	$blockbench_export/Node/cuboid/CSGMesh3D.material = rarityMaterial
	
	
		
func FlipIfStartReveal():
	if TileType == TILE_TYPE.GAME_TILE:
		if bStartRevealed:
			await RevealTile()
	
func SetOriginalPosition():
	OriginalPosition = global_position
	
func SetUsable(bUsable):
	bCanBeUsed = bUsable
	
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if bCanBeUsed == false:
		return
		
	if CurrentState == TILE_STATE.FLIPPED or CurrentState == TILE_STATE.UNCLICKABLE:
		return
	if event.is_action_pressed("left_click"):
		
		SetOriginalPosition()
		
		if TileType == TILE_TYPE.GAME_TILE and Finder.GetGame().CanPlayTiles():
			#print(name + " clicked")
			Finder.GetGame().PlayTile()		
			Finder.GetGame().SetGameState(Game.GAME_STATE.RESOLVING)	
			var tileStatebeforeReveal = TileVisibility
			
			await RevealTile()
			
			await DoEffect()
			
			
			if tileStatebeforeReveal == TILE_VISIBILITY.REVEALED:
				Finder.GetGame().OnTilePlayed.emit(GameTile.FIELD_TILE_TYPE.REVEALED)
			else:
				Finder.GetGame().OnTilePlayed.emit(GameTile.FIELD_TILE_TYPE.HIDDEN)
			await Finder.GetGame().CompleteActions()
			await get_tree().create_timer(.35).timeout
			
			if Finder.GetEnemy().IsAlive():
				if Finder.GetGame().CanPlayExtraTurn():
						Finder.GetGame().SetGameState(Game.GAME_STATE.CAN_PLAY_TILES)
				else:
					Finder.GetGame().SetGameState(Game.GAME_STATE.ENEMY_TURN)
			else:
				Finder.GetGame().SetGameState(Game.GAME_STATE.SHOP	)
			
			await PushToGraveyard()
			
		elif TileType == TILE_TYPE.SHOP_TILE:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", Finder.GetGraveyardPreviewSpot().global_position, .1)
			await tween.finished
			Finder.GetGame().AddTileScene(SceneRef)
			await PushToGraveyard()
		

func PlaySFX():
	$blockbench_export/Node/cuboid/GPUParticles3D.emitting = true
	
func DoEffect():
	ShowTileInfo()
	CurrentState = TILE_STATE.FLIPPED
	var speed = .1
	
	var tween = get_tree().create_tween()
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position - Vector3(0,0,.01), .1)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(90,0,0), speed)
	tween.tween_property(self, "global_position", OriginalPosition + Vector3(0,.05,0), .1)
	await tween.finished
	for child in $Effects.get_children():
		PlaySFX()
		await child.DoAction()
	Finder.GetInfoPopup().ShowInfo(null)
				
func PushToGraveyard():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Finder.GetGraveyardPreviewSpot().global_position, .1)
	await tween.finished
	TileFinishedResolving.emit(SceneRef)
	queue_free()

func RevealTile():
	SetOriginalPosition()
	var tween = get_tree().create_tween()
	var offsetVector = Vector3(0,.01,0)
	
	tween.tween_property(self, "rotation_degrees", Vector3(180, 180, 0), .2)
	tween.tween_property(self, "global_position", global_position + offsetVector, .1)
	TileVisibility = TILE_VISIBILITY.REVEALED
	await tween.finished
	
func MoveTileToSlot():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", OriginalPosition + Vector3(0,.001,0), .1)
	await tween.finished
	await get_tree().create_timer(.1).timeout
	
	
func IsFlipped():
	return CurrentState == TILE_STATE.FLIPPED
	
func IsRevealed():
	return TileVisibility == TILE_VISIBILITY.REVEALED
	
func DoAction():
	pass
	
func _on_mouse_entered() -> void:
	if Finder.GetGame().CurrentState == Game.GAME_STATE.RESOLVING:
		return
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = load("res://Shaders/GameTileHighlight.tres")
	if TileType == TILE_TYPE.SHOP_TILE or TileVisibility == TILE_VISIBILITY.REVEALED:
		ShowTileInfo()


func ShowHiddenTileInfo():
	var data = {}
	data["desc"] = ""
	data["title"] = "???"
	Finder.GetInfoPopup().ShowInfo(data)

func ShowTileInfo():
		var data = {}
		data["desc"] = GetDescription()
		data["title"] = GetTitle()
		data["img"] = $blockbench_export/Sprite3D.texture
		Finder.GetInfoPopup().ShowInfo(data)

func _on_mouse_exited() -> void:
	if Finder.GetGame().CurrentState == Game.GAME_STATE.RESOLVING:
		return
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = null
	
	Finder.GetInfoPopup().ShowInfo(null)
