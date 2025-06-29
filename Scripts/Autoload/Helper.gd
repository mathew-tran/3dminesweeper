extends Node

@onready var EffectParticle = load("res://Prefabs/Effects/EffectParticle.tscn")

func CreateEffectParticle(startPosition, endPosition, speed) -> CustomPathToEffect:
	var instance = EffectParticle.instantiate()
	instance.global_position = startPosition
	instance.Setup(endPosition, speed)
	Finder.GetSpecialEffectsGroup().add_child(instance)
	return instance
