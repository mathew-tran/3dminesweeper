extends Node3D

func _ready() -> void:
	SpawnMonster()
	
func SpawnMonster():
	var instance = load("res://Prefabs/Enemy.tscn").instantiate()
	add_child(instance)
	instance.global_position = $MonsterPosition.global_position
	instance.OnDeath.connect(OnDeath)
	
func OnDeath():
	SpawnMonster()
	
	
