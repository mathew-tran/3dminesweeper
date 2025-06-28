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
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	OnDeath.emit()
	queue_free()

func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)

func OnPlayerPlayedTile():
	if $HealthComponent.IsAlive():
		Finder.GetGame().TakeDamage(5)
	
