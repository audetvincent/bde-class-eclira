class_name PlayerController
extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		StateMachine.goto_next_station()
		
	if Input.is_action_just_pressed("ui_left"):
		StateMachine.goto_previous_station()
		
