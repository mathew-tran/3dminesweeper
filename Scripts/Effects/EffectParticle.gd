extends Node3D

class_name CustomPathToEffect

signal DestinationComplete

var StartPosition = Vector3.ZERO
var TargetPosition = Vector3.ZERO
var FirstPosition = Vector3.ZERO
var Speed = 400
var Progress = 0

enum EFFECT_COLOR {
	WHITE,
	BLUE,
	YELLOW,
	BLACK
}

enum STATE {
	FIRST_POSITION,
	SECOND_POSITION
}
var CurrentState = STATE.FIRST_POSITION
func _ready() -> void:
	global_position = StartPosition
	look_at_from_position(global_position, FirstPosition)
	
func Setup(targetPosition, speed, color):
	TargetPosition = targetPosition
	Speed = speed
	FirstPosition = targetPosition + Vector3(0, .1, 0)
	if color == EFFECT_COLOR.WHITE:
		$CSGMesh3D.material_override = load("res://Materials/MATERIAL_COMMON.tres")
	elif color == EFFECT_COLOR.BLUE:
		$CSGMesh3D.material_override = load("res://Materials/MATERIAL_UNCOMMON.tres")
	elif color == EFFECT_COLOR.YELLOW:
		$CSGMesh3D.material_override = load("res://Materials/MATERIAL_RARE.tres")
	elif color == EFFECT_COLOR.BLACK:
		$CSGMesh3D.material_override = load("res://Materials/MATERIAL_BLACK.tres")
func _process(delta: float) -> void:
	
	
	
	if CurrentState == STATE.FIRST_POSITION:
		Progress += delta * 5
		global_position = lerp(StartPosition, FirstPosition, Progress)	
		
		if Progress >= 1:
			Progress = 0
			CurrentState = STATE.SECOND_POSITION
			look_at_from_position(global_position, TargetPosition)
	elif CurrentState == STATE.SECOND_POSITION:
		Progress += delta * Speed
		global_position = lerp(FirstPosition, TargetPosition, Progress)
		
		if Progress >= 1:
			DestinationComplete.emit()
			queue_free()
	
