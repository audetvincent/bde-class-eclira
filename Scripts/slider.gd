class_name SliderInteractable
extends Interactable

@export var current_value:float = 0.0
@export var mouse_incr:float = .001
@export var slider_joint:SliderJoint3D

# Define Axis, gives us the direction vector of the slider's axis.
@onready var axis:Vector3 = slider_joint.global_basis.x.normalized()
@onready var minimum_value:float = slider_joint.get_param(SliderJoint3D.PARAM_LINEAR_LIMIT_LOWER)
@onready var maximum_value:float = slider_joint.get_param(SliderJoint3D.PARAM_LINEAR_LIMIT_UPPER)
@onready var length:float = maximum_value - minimum_value

func start_drag() -> void:
	is_dragging = true

func drag(mouse_relative:Vector2) -> void:
	# Convert 2D mouse movement to 3D space
	var movement_world = global_basis.x * -mouse_relative.x + global_basis.y * -mouse_relative.y
	# Calculate Drag gives the amount to move
	var drag_amount = movement_world.dot(axis) * mouse_incr
	
	var current_position:Vector3 = global_transform.origin
	# Measures the new position relative to the joint's origin.
	var new_position:Vector3 = current_position + axis * drag_amount
	
	# Manually apply the scale vector so that it can be apply to 
	# the scalar_projection and the constrained_position.
	# We do that because otherwise the boundary set by the SlideJoint3D are not respected
	var scale_projection:Vector3 = Vector3(
		axis.x * scale.x,
		axis.y * scale.y,
		axis.z * scale.z,
	)
	var scalar_projection:float = axis.dot(new_position - slider_joint.global_transform.origin) * scale_projection.length() 
	
	# Gets the actual new position, clamped along the axis
	var constrained_position:Vector3 = axis * clamp(scalar_projection, minimum_value, maximum_value) / scale_projection.length()
	# Apply the contrained position to the joint'origin
	global_transform.origin = slider_joint.global_transform.origin + constrained_position
	
	current_value = get_position_percentage()

func get_position_percentage() -> float:
	var current_position:Vector3 = global_transform.origin
	var joint_origin:Vector3 = slider_joint.global_transform.origin
	
	var scalar_projection = axis.dot(current_position-joint_origin)
	var normalized_value = (maximum_value-scalar_projection)/(maximum_value-minimum_value)
	
	return normalized_value * 100

func _process(delta: float) -> void:
	if !is_dragging:
		return
