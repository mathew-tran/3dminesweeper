extends StaticBody3D

class_name GameTile

enum TILE_STATE {
	UNFLIPPED,
	FLIPPED
}

signal TileFinishedResolving(tile)

var CurrentState = TILE_STATE.UNFLIPPED
var SceneRef : PackedScene

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if CurrentState == TILE_STATE.FLIPPED:
		return
	if event.is_action_pressed("left_click"):
		print(name + " clicked")
		CurrentState = TILE_STATE.FLIPPED
		var offsetVector = Vector3(0,.01,0)
		var originalPosition = global_position
		var tween = get_tree().create_tween()
		tween.tween_property($blockbench_export, "rotation_degrees", Vector3(0, 0, 0), .2)
		tween.tween_property($blockbench_export, "global_position", global_position + offsetVector, .1)
		for child in $Effects.get_children():
			await child.DoAction()
		
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property($blockbench_export, "global_position", originalPosition, .2)
		await tween.finished
		Finder.GetGame().PlayTile()
		TileFinishedResolving.emit(SceneRef)
		queue_free()

func DoAction():
	pass
	
func _on_mouse_entered() -> void:
	$blockbench_export/Node/cuboid.material_override = load("res://Shaders/GameTileHighlight.tres")


func _on_mouse_exited() -> void:
	$blockbench_export/Node/cuboid.material_override = null
