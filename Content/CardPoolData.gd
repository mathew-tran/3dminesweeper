extends Resource

class_name CardPoolData

@export_dir var TilesDirectory

func GetTiles():
	return Helper.GetAllFilePaths(TilesDirectory)
