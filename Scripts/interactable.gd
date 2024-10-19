class_name Interactable
extends Node3D

@export var clickable:bool = true
@export var toggleable:bool = false
@export var draggable:bool = false

@export var current_state:State = State.IDLE

var is_toggled:bool = false
var is_dragging:bool = false

enum State {IDLE, HOVERED, PRESSED, DRAGGED, TOGGLED}

signal state_changed(new_state:State)
signal toggled(is_on)
signal clicked()

func handle_mouse_click() -> void:
	_clicked()

func handle_mouse_release() -> void:
	_released()

func _on_mouse_entered():
	set_state(State.HOVERED)

func _on_mouse_exited():
	if current_state == State.HOVERED:
		set_state(State.IDLE)

func _clicked() -> void:
	if clickable:
		set_state(State.PRESSED)
	if toggleable:
		_toggle()

func _released() -> void:
	set_state(State.IDLE)

func _toggle() -> void:
	is_toggled != is_toggled
	set_state(State.TOGGLED)
	toggled.emit(is_toggled)

func set_state(new_state:State) -> void:
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(current_state)
