extends Node3D

class_name CustomPathToEffect

signal DestinationComplete

var StartPosition = Vector3.ZERO
var TargetPosition = Vector3.ZERO
var FirstPosition = Vector3.ZERO
var Speed = 400
var Progress = 0

enum STATE {
	FIRST_POSITION,
	SECOND_POSITION
}
var CurrentState = STATE.FIRST_POSITION
func _ready() -> void:
	StartPosition = global_position
	
func Setup(targetPosition, speed):
	TargetPosition = targetPosition
	Speed = speed
	FirstPosition = targetPosition + Vector3(0, .1, 0)

	
func _process(delta: float) -> void:
	
	
	
	if CurrentState == STATE.FIRST_POSITION:
		look_at(FirstPosition)
		Progress += delta * 5
		global_position = lerp(StartPosition, FirstPosition, Progress)	
		if Progress >= 1:
			Progress = 0
			CurrentState = STATE.SECOND_POSITION
	elif CurrentState == STATE.SECOND_POSITION:
		look_at(TargetPosition)
		Progress += delta * Speed
		global_position = lerp(FirstPosition, TargetPosition, Progress)
		if Progress >= 1:
			DestinationComplete.emit()
			queue_free()
	
