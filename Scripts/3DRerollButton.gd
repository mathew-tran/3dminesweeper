extends StaticBody3D

@onready var MeshBody = $MeshInstance3D
@onready var MoneyUIRef = $Sprite3D/SubViewport/MoneyUI

enum HOVER_STATE {
	HOVERED,
	UNHOVERED
}
var bDisabled = false

var CurrentState = HOVER_STATE.UNHOVERED

func _on_mouse_entered() -> void:
	if bDisabled == false:
		MeshBody.material_override = load("res://Shaders/GameTileHighlight.tres")
		CurrentState = HOVER_STATE.HOVERED		

func IsHovered():
	return CurrentState == HOVER_STATE.HOVERED
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and IsHovered():
		Finder.GetShop().Reroll()
	
func _on_mouse_exited() -> void:
	MeshBody.material_override = null
	CurrentState = HOVER_STATE.UNHOVERED

func Update(rerollAmount):
	bDisabled = Finder.GetGame().CanAfford(rerollAmount) == false
	MoneyUIRef.Update(rerollAmount, bDisabled == false)
