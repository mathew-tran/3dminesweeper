extends Node

@onready var EffectParticle = load("res://Prefabs/Effects/EffectParticle.tscn")

func CreateEffectParticle(startPosition, endPosition, speed, color = CustomPathToEffect.EFFECT_COLOR.WHITE) -> CustomPathToEffect:
	var instance = EffectParticle.instantiate()
	instance.StartPosition = startPosition
	instance.Setup(endPosition, speed, color)
	Finder.GetSpecialEffectsGroup().add_child(instance)
	return instance

func GetAllFilePaths(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		file_name = file_name.trim_suffix('.remap')
		var file_path = path + "/" + file_name
		if dir.current_is_dir():
			file_paths += GetAllFilePaths(file_path)
		else:
			file_paths.append(file_path)
		file_name = dir.get_next()
	return file_paths
