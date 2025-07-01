extends Node3D

func _ready() -> void:
	Finder.GetGame().GraveyardUpdate.connect(OnGraveyardUpdate)
	
	
func OnGraveyardUpdate():
	if get_tree() == null:
		return
	$Label3D.text = str(Finder.GetGame().Graveyard.size())
	$AnimationPlayer.play("anim")
