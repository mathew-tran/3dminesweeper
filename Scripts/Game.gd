extends Node3D

class_name Game



signal PlayerPlayedTile

func _ready() -> void:
	$TileGridContainer.visible = false
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)
	
	for position in $TileGridContainer.GetPositions():
		var instance = load("res://Prefabs/GameTile.tscn").instantiate()
		instance.global_position = position
		$Tiles.add_child(instance)
		
func OnTakeDamage(amount):
	pass

func OnDeath():
	get_tree().reload_current_scene()
	
func PlayTile():
	PlayerPlayedTile.emit()
	
func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)
