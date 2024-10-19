class_name PlayerController
extends Camera3D

var ray_length: float = 10.0
var interactable: Interactable = null
var drag_interactable:SliderInteractable = null

func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var from:Vector3 = self.project_ray_origin(mouse_position)
	var to:Vector3 = self.project_ray_normal(mouse_position) * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	
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
	else:
		if interactable:
			interactable._on_mouse_exited()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_left_click"):
			handle_mouse_left_click(event.position)
			if interactable:
				interactable.handle_mouse_click()
		elif event.is_action_released("mouse_left_click"):
			if interactable:
				interactable.handle_mouse_release()
			drag_interactable = null
	
	if event is InputEventMouseMotion:
		if drag_interactable:
			drag_interactable.drag(event.relative)
	
	if event is InputEventAction:
		if event.is_action_pressed("ui_right"):
			StateMachine.goto_next_station()
		if event.is_action_just_pressed("ui_left"):
			StateMachine.goto_previous_station()

func handle_mouse_left_click(mouse_position:Vector2) -> void:
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider.has_method("start_drag"):
			result.collider.start_drag()
			drag_interactable = result.collider
		elif result.collider is Interactable:
			interactable = result.collider
