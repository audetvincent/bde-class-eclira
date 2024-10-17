extends Node

enum Scene {COMMUNICATION, ENGINEERING, LIFE_SUPPORT, NAVIGATION}

var current_scene = null

var communication_scene:Node = preload("res://Scenes/Rooms/communication.tscn").instantiate()
var engineering_scene:Node = preload("res://Scenes/Rooms/communication.tscn").instantiate()
var life_support_scene:Node = preload("res://Scenes/Rooms/life-support.tscn").instantiate()
var navigation_scene:Node = preload("res://Scenes/Rooms/navigation.tscn").instantiate()

@onready var scene_order: Dictionary = {
	communication_scene: Scene.COMMUNICATION,
	engineering_scene: Scene.ENGINEERING,
	life_support_scene: Scene.LIFE_SUPPORT,
	navigation_scene: Scene.NAVIGATION
}

func _ready() -> void:
	var root = get_tree().root
	#current_scene = root.get_child(root.get_child_count() - 1)
	for n in scene_order:
		root.add_child(n)

# Make the current scene invisible and the next scene visible
func goto_next_station() -> void:
	var a = null
