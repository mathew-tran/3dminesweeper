extends Node

func GetEnemy() -> Enemy:
	var result = get_tree().get_nodes_in_group("Enemy")
	if result:
		return result[0]
	return null
