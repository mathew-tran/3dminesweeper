extends StaticBody3D

@onready var MeshBody = $MeshInstance3D
@onready var MoneyUIRef = $Sprite3D/SubViewport/MoneyUI

enum HOVER_STATE {
	HOVERED,
	UNHOVERED
}
var bDisabled = false

var CurrentState = HOVER_STATE.UNHOVERED

var RerollAmount = 4

func _ready() -> void:
	Finder.GetGame().MoneyUpdate.connect(OnMoneyUpdate)
	
func OnMoneyUpdate():
	Update(RerollAmount)
	
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

func SetRerollAmount(amount):
	RerollAmount = amount
	
func Update(amount):
	bDisabled = Finder.GetGame().CanAfford(amount) == false
	MoneyUIRef.Update(amount, bDisabled == false)
