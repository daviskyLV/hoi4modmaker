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
@onready var folderRegex := RegEx.new()

# Checks if mod can be created
func validityCheck():
	# Basic input checks
	if modTitle.text.length() < 3:
		createButton.disabled = true
		createButton.tooltip_text = "Mod title must be at least 3 characters long"
		return
	
	if supportedVersion.text.is_empty():
		createButton.disabled = true
		createButton.tooltip_text = "Empty supported game version"
		return
	
	# Mod folder check
	if modFolder.text.is_empty():
		createButton.disabled = true
		createButton.tooltip_text = "Empty mod folder name"
		return
		
	var invalidFolder := folderRegex.search(modFolder.text)
	if invalidFolder:
		createButton.disabled = true
		createButton.tooltip_text = "Mod folder contains invalid characters"
		return
	
	# Checking if min/max amount of tags is selected
	var tagsSelected := 0
	for tag in tagsGrid.get_children():
		if tag is CheckBox:
			tagsSelected += 1 if tag.is_pressed() else 0
	
	if tagsSelected == 0 or tagsSelected > 10:
		createButton.disabled = true
		createButton.tooltip_text = "Invalid amount of tags"
		return
	
	# All checks passed
	createButton.disabled = false
	createButton.tooltip_text = ""

# Validating and setting the thumbnail file
func validateThumbnail() -> bool:
	if !thumbnailPath.text.is_empty():
		if !FileAccess.file_exists(thumbnailPath.text):
			createButton.disabled = true
			thumbnailImage.texture = null
			createButton.tooltip_text = "Invalid thumbnail path"
			return false
		
		var image := Image.load_from_file(thumbnailPath.text)
		thumbnailImage.texture = ImageTexture.create_from_image(image)
		
		var f := FileAccess.open(thumbnailPath.text, FileAccess.READ)
		if f.get_length() > 1000*1000: # max 1 MB
			createButton.disabled = true
			createButton.tooltip_text = "Thumbnail too large!"
			f.close()
			return false
		f.close()
	else:
		thumbnailImage.texture = null
	
	return true


# Called when the node enters the scene tree for the first time.
func _ready():
	folderRegex.compile("[^0-9A-Za-z_]+")
	supportedVersion.text = Globals.gameVersion
	selectImgFile.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	selectFolder.root_subfolder = Globals.gameModsPath.get_current_dir()
	
	# Listening to tags buttons
	for tag in tagsGrid.get_children():
		if tag is CheckBox:
			tag.toggled.connect(tagToggled)
	
	# Updating UI
	validityCheck()


func tagToggled(_buttonPressed):
	validityCheck()

# Text Inputs
func _on_mod_title_text_changed(_new_text):
	validityCheck()

func _on_supported_version_text_changed(_new_text):
	validityCheck()


# Main bottom buttons
func _on_cancel_pressed():
	queue_free()

func _on_create_pressed():
	var sanitizedTitle := modTitle.text.c_escape()
	
	# Creating mod directory
	var modPath := DirAccess.open(Globals.gameModsPath.get_current_dir(true))
	modPath.make_dir(modFolder.text)
	modPath.change_dir(modFolder.text)
	
	# Mod tags text
	var tagsText := "tags={\n"
	for tag in tagsGrid.get_children():
		if tag.is_pressed():
			tagsText += "\t\""+ tag.get_text() +"\"\n"
	tagsText += "}\n"
	
	# Mod thumbnail
	var thumbnailText := ""
	if !thumbnailPath.text.is_empty():
		thumbnailText = "picture=\""+ thumbnailPath.text.get_file() +"\"\n"
		modPath.copy(thumbnailPath.text,
			modPath.get_current_dir(true)+"/thumbnail."+ thumbnailPath.text.get_extension()
		)
		
	
	# Mod internal descriptor file
	var descriptorContent := str(
		"version=\"1.0\"\n",
		tagsText,
		"name=\""+ sanitizedTitle +"\"\n",
		thumbnailText,
		'supported_version="'+supportedVersion.text+'"'
	)
	var descInFile := FileAccess.open(modPath.get_current_dir(true)+"/descriptor.mod",FileAccess.WRITE)
	descInFile.store_string(descriptorContent)
	descInFile.close()
	
	# Mod external descriptor file (in mod/ folder)
	var descExtFile := FileAccess.open(modPath.get_current_dir(true)+"/../"+ modFolder.text +".mod",
		FileAccess.WRITE)
	descExtFile.store_string(str(
		descriptorContent,
		"\npath=\""+modPath.get_current_dir(true)+"\""
	))
	descExtFile.close()
	
	queue_free()


# Mod thumbnail stuff
func _on_thumbnail_reset_pressed():
	thumbnailPath.text = ""
	if validateThumbnail():
		validityCheck()

func _on_thumbnail_select_pressed():
	selectImgFile.show()

func _on_select_image_file_file_selected(path):
	thumbnailPath.text = path
	if validateThumbnail():
		validityCheck()

func _on_thumbnail_path_text_changed(_new_text):
	if validateThumbnail():
		validityCheck()


# Mod folder stuff
func _on_mod_folder_button_pressed():
	selectFolder.show()

func _on_select_folder_dir_selected(dir):
	modFolder.text = dir

func _on_mod_folder_text_changed(_new_text):
	validityCheck()
