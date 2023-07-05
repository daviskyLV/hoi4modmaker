extends Node

@onready var modTitle: LineEdit = get_node("%ModTitle")
@onready var modFolder: LineEdit = get_node("%ModFolder")
@onready var supportedVersion: LineEdit = get_node("%SupportedVersion")
@onready var thumbnailImage: TextureRect = get_node("%ThumbnailImage")
@onready var thumbnailPath: LineEdit = get_node("%ThumbnailPath")
@onready var tagsGrid: GridContainer = get_node("%TagsGrid")
@onready var createButton: Button = get_node("%Create")

@onready var selectImgFile: NativeFileDialog = $SelectImageFile
@onready var selectFolder: NativeFileDialog = $SelectFolder

@onready var modPath := DirAccess.open(Globals.gameDataPath.get_current_dir())

# Checks if mod can be created
func validityCheck():
	if modFolder.text.is_empty():
		createButton.disabled = true
		return
	if supportedVersion.text.is_empty():
		createButton.disabled = true
		return
	if modTitle.text.is_empty():
		createButton.disabled = true
		return
	createButton.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	modPath.change_dir(Globals.modSubpath)
	modFolder.text = Globals.modSubpath
	supportedVersion.text = Globals.gameVersion
	selectImgFile.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	selectFolder.root_subfolder = Globals.gameDataPath.get_current_dir()



func _on_mod_title_text_changed(new_text):
	validityCheck()


func _on_mod_folder_text_changed(new_text):
	validityCheck()


func _on_supported_version_text_changed(new_text):
	validityCheck()


func _on_cancel_pressed():
	queue_free()


func _on_thumbnail_reset_pressed():
	thumbnailImage.texture = null
	thumbnailPath.text = ""


func _on_thumbnail_select_pressed():
	selectImgFile.show()
	pass # Replace with function body.

func _on_select_image_file_file_selected(path):
	thumbnailPath.text = path
	pass # Replace with function body.


func _on_mod_folder_button_pressed():
	selectFolder.show()
	pass # Replace with function body.

func _on_select_folder_dir_selected(dir):
	modFolder.text = dir
	pass # Replace with function body.
