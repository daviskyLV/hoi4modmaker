extends Control


var modlistVBox: VBoxContainer
var newModScene = preload("res://UtilityScenes/mod_element.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting window minimum size
	DisplayServer.window_set_min_size(Vector2i(720, 640))
	modlistVBox = $Margins/Tabs/Modlist/Mods/List/VBox
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_mod_button_pressed():
	var newModInstance = newModScene.instantiate()
	modlistVBox.add_child(newModInstance)
	pass # Replace with function body.
