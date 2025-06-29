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
	RARE # yello
}

enum TILE_VISIBILITY {
	REVEALED,
	NOT_REVEALED
}

var bCanBeUsed = true

@export var TileTitle = "tile Title"


	
signal TileFinishedResolving(tile)
signal TileStartResolving

var CurrentState = TILE_STATE.UNFLIPPED
var TileType = TILE_TYPE.GAME_TILE
var TileVisibility = TILE_VISIBILITY.NOT_REVEALED

var SceneRef : PackedScene
var OriginalPosition = Vector2.ZERO

@export var Rarity : TILE_RARITY

func GetDescription():
	var description = ""
	for effect in $Effects.get_children():
		description += effect.GetDescription() +"\n"
	return description
	
func GetTitle():
	return TileTitle
	
func _ready() -> void:
	if TileType == TILE_TYPE.SHOP_TILE:
		$blockbench_export.rotation_degrees = Vector3.ZERO
	OriginalPosition = global_position		
	
	var rarityMaterial = load("res://Materials/MATERIAL_COMMON.tres")
	match Rarity:
		TILE_RARITY.UNCOMMON:
			rarityMaterial = load("res://Materials/MATERIAL_UNCOMMON.tres")
		TILE_RARITY.RARE:
			rarityMaterial = load("res://Materials/MATERIAL_RARE.tres")
	
	$blockbench_export/Node/cuboid/CSGMesh3D.material = rarityMaterial
		
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
		var tween = get_tree().create_tween()
		if TileType == TILE_TYPE.GAME_TILE:
			TileStartResolving.emit()
			print(name + " clicked")
			CurrentState = TILE_STATE.FLIPPED
			await RevealTile()
			for child in $Effects.get_children():
				$blockbench_export/Node/cuboid/GPUParticles3D.emitting = true
				await child.DoAction()
			
			await MoveTileToSlot()
			
			tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", Finder.GetGraveyardPreviewSpot().global_position, .1)
			await tween.finished
			
			
			Finder.GetGame().PlayTile()
		elif TileType == TILE_TYPE.SHOP_TILE:
			tween.tween_property(self, "global_position", Finder.GetGraveyardPreviewSpot().global_position, .1)
			await tween.finished
			Finder.GetGame().AddTileScene(SceneRef)
		TileFinishedResolving.emit(SceneRef)
		queue_free()

func RevealTile():
	SetOriginalPosition()
	var tween = get_tree().create_tween()
	var offsetVector = Vector3(0,.01,0)
	
	tween.tween_property($blockbench_export, "rotation_degrees", Vector3(0, 0, 0), .2)
	tween.tween_property($blockbench_export, "global_position", global_position + offsetVector, .1)
	TileVisibility = TILE_VISIBILITY.REVEALED
	ShowTileInfo()
	await tween.finished
	
func MoveTileToSlot():
	var tween = get_tree().create_tween()
	tween.tween_property($blockbench_export, "global_position", OriginalPosition, .1)
	await tween.finished
	await get_tree().create_timer(.1).timeout
	Finder.GetInfoPopup().ShowInfo(null)
	
	
func IsFlipped():
	return CurrentState == TILE_STATE.FLIPPED
	
func IsRevealed():
	return TileVisibility == TILE_VISIBILITY.REVEALED
	
func DoAction():
	pass
	
func _on_mouse_entered() -> void:
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = load("res://Shaders/GameTileHighlight.tres")
	if TileType == TILE_TYPE.SHOP_TILE or TileVisibility == TILE_VISIBILITY.REVEALED:
		ShowTileInfo()
	else:
		ShowHiddenTileInfo()

func ShowHiddenTileInfo():
	var data = {}
	data["desc"] = ""
	data["title"] = "???"
	Finder.GetInfoPopup().ShowInfo(data)

func ShowTileInfo():
		var data = {}
		data["desc"] = GetDescription()
		data["title"] = GetTitle()
		Finder.GetInfoPopup().ShowInfo(data)

func _on_mouse_exited() -> void:
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = null
	
	Finder.GetInfoPopup().ShowInfo(null)
