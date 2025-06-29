extends Node3D

class_name CustomPathToEffect

signal DestinationComplete

var StartPosition = Vector3.ZERO
var TargetPosition = Vector3.ZERO
var Speed = 400
var Progress = 0

func _ready() -> void:
	StartPosition = global_position
	
func Setup(targetPosition, speed):
	TargetPosition = targetPosition
	Speed = speed
	
func _process(delta: float) -> void:
	Progress += delta * Speed
	global_position = lerp(StartPosition, TargetPosition, Progress)
	if Progress >= 1:
		DestinationComplete.emit()
		queue_free()
