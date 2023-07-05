extends Control


@onready var modlistVBox: VBoxContainer = get_node("%ModlistVBox")
var newModScene = preload("res://UtilityScenes/mod_element.tscn")
var newModPopupScene = preload("res://UtilityScenes/new_mod_popup.tscn")

var newModPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting window minimum size
	DisplayServer.window_set_min_size(Vector2i(720, 640))
	pass # Replace with function body.



func _on_new_mod_button_pressed():
	if newModPopup == null:
		newModPopup = newModPopupScene.instantiate()
		add_child(newModPopup)
