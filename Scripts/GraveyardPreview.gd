extends Node3D

func _ready() -> void:
	Finder.GetGame().DeckUpdate.connect(OnDeckUpdate)
	
	
func OnDeckUpdate():
	if get_tree() == null:
		return
	$Label3D.text = str(Finder.GetGame().Graveyard.size())
