extends Node3D

class_name Enemy

signal OnDeath

func _ready() -> void:
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnEnemyDeath)	
	Finder.GetGame().PlayerPlayedTile.connect(OnPlayerPlayedTile)
	
func OnTakeDamage(amount):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	
func OnEnemyDeath():
	OnDeath.emit()
	queue_free()

func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)

func OnPlayerPlayedTile():
	Finder.GetGame().TakeDamage(5)
	
