extends Panel

class_name InfoPopup

@onready var Title = $VBoxContainer/HBoxContainer/Title
@onready var ImageRef = $TextureRect
func ShowInfo(data):
	$VBoxContainer/Description.visible = false
	Title.visible = false
	ImageRef.visible = false
	visible = true
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
	await get_tree().process_frame
