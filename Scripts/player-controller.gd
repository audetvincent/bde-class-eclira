class_name PlayerController
extends Camera3D

var interactable: Interactable = null
var ray_length: float = 10.0

func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var from:Vector3 = self.project_ray_origin(mouse_position)
	var to:Vector3 = self.project_ray_normal(mouse_position) * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	var result: = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		if collider is Interactable:
			if interactable != collider:
				if interactable:
					interactable._on_mouse_exited()
				interactable = collider
				interactable._on_mouse_entered()
		else:
			if interactable:
				interactable._on_mouse_exited()
				interactable = null
	else:
		if interactable:
			interactable._on_mouse_exited()
			interactable = null
	
	if Input.is_action_just_pressed("ui_right"):
		StateMachine.goto_next_station()
		
	if Input.is_action_just_pressed("ui_left"):
		StateMachine.goto_previous_station()

func _unhandled_input(event: InputEvent) -> void:
	if interactable:
		if event is InputEventMouseButton:
			interactable.handle_mouse_button(event)
		elif event is InputEventMouseMotion:
			interactable.handle_mouse_motion(event)
