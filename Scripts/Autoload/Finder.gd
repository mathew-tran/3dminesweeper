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

func GetTilePreviewSpot():
	var result = get_tree().get_nodes_in_group("TilePreview")
	if result:
		return result[0]
	return null
	
func GetGraveyardPreviewSpot():
	var result = get_tree().get_nodes_in_group("GraveyardPreview")
	if result:
		return result[0]
	return null
	
func GetInfoPopup() -> InfoPopup:
	var result = get_tree().get_nodes_in_group("InfoPopup")
	if result:
		return result[0]
	return null
		
