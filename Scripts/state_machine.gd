extends Node

enum Scene {COMMUNICATION, ENGINEERING, LIFE_SUPPORT, NAVIGATION}

var main_child:Node3D
var current_station:Node3D

var communication_scene:Node = preload("res://Scenes/Rooms/communication.tscn").instantiate()
var engineering_scene:Node = preload("res://Scenes/Rooms/engineering.tscn").instantiate()
var life_support_scene:Node = preload("res://Scenes/Rooms/life-support.tscn").instantiate()
var navigation_scene:Node = preload("res://Scenes/Rooms/navigation.tscn").instantiate()

@onready var scene_order: Dictionary = {
	Scene.COMMUNICATION: communication_scene,
	Scene.ENGINEERING: engineering_scene,
	Scene.LIFE_SUPPORT: life_support_scene,
	Scene.NAVIGATION: navigation_scene
}

func _ready() -> void:
	var root = get_tree().root
	main_child = root.get_child(-1)
	for n:Node3D in scene_order.values():
		n.visible = false
		main_child.add_child.call_deferred(n)
	
	await get_tree().process_frame
	current_station = main_child.get_child(0)
	current_station.visible = true

func goto_next_station() -> void:
	change_station(1)

func goto_previous_station() -> void:
	change_station(-1)

func change_station(direction: int = 1) -> void:
		current_station.visible = false
		var key = scene_order.find_key(current_station)
		var index = key + direction
		var haskey = scene_order.has(index)
		
		if !haskey:
			index = 0 if index >= scene_order.size() else scene_order.size()-1
		
		var nextStation = scene_order.get(index)
		
		current_station = nextStation
		current_station.visible = true
		print("Station : ", current_station.name)
