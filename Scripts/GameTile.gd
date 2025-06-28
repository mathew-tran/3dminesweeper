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

@export var TileTitle = "tile Title"

func GetDescription():
	var description = ""
	for effect in $Effects.get_children():
		description += effect.GetDescription() +"\n"
	return description
	
func GetTitle():
	return TileTitle
	
signal TileFinishedResolving(tile)

var CurrentState = TILE_STATE.UNFLIPPED
var TileType = TILE_TYPE.GAME_TILE

var SceneRef : PackedScene

func _ready() -> void:
	if TileType == TILE_TYPE.SHOP_TILE:
		$blockbench_export.rotation_degrees = Vector3.ZERO

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if CurrentState == TILE_STATE.FLIPPED or CurrentState == TILE_STATE.UNCLICKABLE:
		return
	if event.is_action_pressed("left_click"):
		var tween = get_tree().create_tween()
		if TileType == TILE_TYPE.GAME_TILE:
			print(name + " clicked")
			CurrentState = TILE_STATE.FLIPPED
			var offsetVector = Vector3(0,.01,0)
			var originalPosition = global_position			
			tween.tween_property($blockbench_export, "rotation_degrees", Vector3(0, 0, 0), .2)
			tween.tween_property($blockbench_export, "global_position", global_position + offsetVector, .1)
			for child in $Effects.get_children():
				await child.DoAction()
			
			await tween.finished
			tween = get_tree().create_tween()
			tween.tween_property($blockbench_export, "global_position", originalPosition, .1)
			await tween.finished
			await get_tree().create_timer(.1).timeout
			
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

func DoAction():
	pass
	
func _on_mouse_entered() -> void:
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = load("res://Shaders/GameTileHighlight.tres")
	if TileType == TILE_TYPE.SHOP_TILE:
		var data = {}
		data["desc"] = GetDescription()
		data["title"] = GetTitle()
		Finder.GetInfoPopup().ShowInfo(data)

func _on_mouse_exited() -> void:
	if CurrentState != TILE_STATE.UNCLICKABLE:
		$blockbench_export/Node/cuboid.material_override = null
	if TileType == TILE_TYPE.SHOP_TILE:
		Finder.GetInfoPopup().ShowInfo(null)
