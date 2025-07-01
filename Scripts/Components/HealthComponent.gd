extends Node

class_name HealthComponent

@export var MaxHealth = 10
var CurrentHealth = 3

signal OnTakeDamage(amount)
signal OnDeath
signal OnSetup

enum STATE {
	ALIVE,
	DEAD
}

var CurrentState = STATE.ALIVE

func _ready() -> void:
	Setup()
	
func Setup():
	CurrentHealth = MaxHealth	
	CurrentState = STATE.ALIVE
	
	await get_tree().process_frame
	OnSetup.emit()
	
func Heal(amount):
	if CurrentState == STATE.DEAD:
		return
		
	CurrentHealth += amount
	
	
	if CurrentHealth > MaxHealth:
		CurrentHealth = MaxHealth
	OnTakeDamage.emit(0)
	
func TakeDamage(amount):
	CurrentHealth -= amount
	OnTakeDamage.emit(amount)
	
	if CurrentHealth <= 0:
		if CurrentState == STATE.DEAD:
			return
		OnDeath.emit()
		CurrentState = STATE.DEAD
	
func IsAlive():
	return CurrentState == STATE.ALIVE
