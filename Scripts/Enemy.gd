extends Node3D

class_name Enemy

@export var MoneyToGive = 3

signal OnDeath(enemy)

func _ready() -> void:
	$HealthComponent.OnTakeDamage.connect(OnTakeDamage)
	$HealthComponent.OnDeath.connect(OnEnemyDeath)	
	Finder.GetGame().StateUpdate.connect(OnStateUpdate)
	
func OnTakeDamage(_amount):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	
func OnEnemyDeath():
	
	var amount = MoneyToGive + randi() % 3
	Finder.GetGame().AddMoney(amount)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	await Finder.GetGame().CurrentState == Game.GAME_STATE.CAN_PLAY_TILES
	OnDeath.emit(self)
	

func TakeDamage(amount):
	$HealthComponent.TakeDamage(amount)

func IsAlive():
	return $HealthComponent.IsAlive()
	
func OnStateUpdate(state : Game.GAME_STATE):
	if state == Game.GAME_STATE.ENEMY_TURN:
		if $HealthComponent.IsAlive():
			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
			Helper.CreateEffectParticle(global_position, Finder.GetGame().GetPlayerPosition(), 4)
			await $AnimationPlayer.animation_finished
			Finder.GetGame().TakeDamage(5)
			if Finder.GetGame():
				Finder.GetGame().SetGameState(Game.GAME_STATE.CAN_PLAY_TILES)
	if state == Game.GAME_STATE.SHOP:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3.ZERO, .2)
