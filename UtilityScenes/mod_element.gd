extends Button

@onready var modNameEdit: LineEdit = $Margins/HBox/TitleAndLocation/ModNameMargins/ModName

func _on_mod_name_text_submitted(_new_text):
	modNameEdit.release_focus()
	pass # Replace with function body.
