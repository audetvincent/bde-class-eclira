class_name Interactable
extends Node3D

@export var clickable:bool = true
@export var toggleable:bool = false
@export var draggable:bool = false

@export var current_state:State = State.IDLE

var is_toggled:bool = false

enum State {IDLE, HOVERED, PRESSED, DRAGGED, TOGGLED}

signal state_changed(new_state)
signal toggled(is_on)
signal clicked()
signal dragged(relative_motion)

func handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.is_action_pressed("mouse_left_click"):
		_clicked()
	else:
		set_state(State.IDLE)

func handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if current_state == State.PRESSED:
		set_state(State.DRAGGED)
		dragged.emit(event.relative)

func _on_mouse_entered():
	set_state(State.HOVERED)

func _on_mouse_exited():
	set_state(State.IDLE)

func _clicked() -> void:
	if clickable:
		set_state(State.PRESSED)
	if toggleable:
		_toggle()

func _toggle() -> void:
	is_toggled != is_toggled
	set_state(State.TOGGLED)
	toggled.emit(is_toggled)

func set_state(new_state:State) -> void:
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(current_state)
		print("STATE: ", State.find_key(current_state))
