extends Panel

class_name InfoPopup

@onready var Title = $VBoxContainer/HBoxContainer/Title
@onready var ImageRef = $TextureRect
var OriginalPosition = Vector2.ZERO

var bPlayerInitiated = false
func _ready() -> void:
	OriginalPosition = global_position
	
func _process(delta: float) -> void:
	if bPlayerInitiated:
		global_position = get_global_mouse_position()
	else:
		global_position = OriginalPosition
		
func ShowInfo(data):
	$VBoxContainer/Description.visible = false
	Title.visible = false
	ImageRef.visible = false
	visible = true
	bPlayerInitiated = false
	
	if data == null:
		visible = false
		return
	if data.has("img"):
		ImageRef.texture = data["img"]
		ImageRef.visible = true
	if data.has("desc"):
		$VBoxContainer/Description.text = data["desc"]
		$VBoxContainer/Description.visible = true
	if data.has("title"):
		Title.text = data["title"]
		Title.visible = true
	if data.has("player"):
		bPlayerInitiated = true
	await get_tree().process_frame
