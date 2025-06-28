extends Node3D

class_name Enemy

func _ready() -> void:
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnDeath)	
	
func OnTakeDamage(amount):
	$AnimationPlayer.play("hit")
	
func OnDeath():
	queue_free()

func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)
