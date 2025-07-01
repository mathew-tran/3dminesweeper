extends TextureRect

@export var TotemRef : TotemBase

func Setup():
	texture = TotemRef.TotemImage
	
func _on_mouse_entered() -> void:
	if TotemRef:
		Finder.GetInfoPopup().ShowInfo(TotemRef.GetHoverData())
	
func _on_mouse_exited() -> void:
	Finder.GetInfoPopup().ShowInfo(null)
