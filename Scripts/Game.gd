extends Node3D

class_name Game



signal PlayerPlayedTile

func _ready() -> void:
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)
			
func OnTakeDamage(amount):
	pass

func OnDeath():
	get_tree().reload_current_scene()
	
func PlayTile():
	PlayerPlayedTile.emit()
	
func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)
