extends StaticBody3D

enum HOVER_STATE {
	HOVERED,
	UNHOVERED
}
var bDisabled = false

@onready var MeshBody = $MeshInstance3D
@onready var MoneyUIRef = $Sprite3D/SubViewport/MoneyUI
@onready var TotemRef : TotemBase

var CurrentState = HOVER_STATE.UNHOVERED

func Setup():
	OnMoneyUpdate()
	$Sprite3D/SubViewport/Control/Image.texture = TotemRef.TotemImage
	
func _ready() -> void:
	Setup()
	Finder.GetGame().MoneyUpdate.connect(OnMoneyUpdate)
	
func OnMoneyUpdate():
	Update(TotemRef.Price)
	
func _on_mouse_exited() -> void:
	MeshBody.material_override = null
	CurrentState = HOVER_STATE.UNHOVERED
	Finder.GetInfoPopup().ShowInfo(null)

func Update(price):
	bDisabled = Finder.GetGame().CanAfford(price) == false
	MoneyUIRef.Update(price, bDisabled == false)

func IsHovered():
	return CurrentState == HOVER_STATE.HOVERED
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and IsHovered():
		if bDisabled == false:
			TotemRef.reparent(Finder.GetGame())
			await get_tree().process_frame
			TotemRef.Equip()
			queue_free()
		
func _on_mouse_entered() -> void:
	if TotemRef:
		Finder.GetInfoPopup().ShowInfo(TotemRef.GetHoverData())
