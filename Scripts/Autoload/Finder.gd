extends Node

func GetGame() -> Game:
	var result = get_tree().get_nodes_in_group("Game")
	if result:
		return result[0]
	return null
	
func GetEnemy() -> Enemy:
	var result = get_tree().get_nodes_in_group("Enemy")
	if result:
		return result[0]
	return null
