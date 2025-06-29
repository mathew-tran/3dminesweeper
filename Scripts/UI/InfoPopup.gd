extends Panel

class_name InfoPopup

func ShowInfo(data):
	$VBoxContainer/Description.visible = false
	$VBoxContainer/Title.visible = false
	visible = true
	if data == null:
		visible = false
		return
	if data.has("desc"):
		$VBoxContainer/Description.text = data["desc"]
		$VBoxContainer/Description.visible = true
	if data.has("title"):
		$VBoxContainer/Title.text = data["title"]
		$VBoxContainer/Title.visible = true
	await get_tree().process_frame
