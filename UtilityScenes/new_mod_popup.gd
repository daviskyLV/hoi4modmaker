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

var prevModPathInput = "mod/"

# Checks if mod can be created
func validityCheck():
	if supportedVersion.text.is_empty():
		createButton.disabled = true
		return
	if modTitle.text.is_empty():
		createButton.disabled = true
		return
		
	createButton.disabled = false

# Validating and setting the thumbnail file
func validateThumbnail():
	if !thumbnailPath.text.is_empty():
		if !FileAccess.file_exists(thumbnailPath.text):
			createButton.disabled = true
			thumbnailImage.texture = null
			return
		
		var image := Image.load_from_file(thumbnailPath.text)
		thumbnailImage.texture = ImageTexture.create_from_image(image)
	
	validityCheck()


# Called when the node enters the scene tree for the first time.
func _ready():
	modPath.change_dir(Globals.modSubpath)
	modFolder.text = Globals.modSubpath
	supportedVersion.text = Globals.gameVersion
	selectImgFile.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	selectFolder.root_subfolder = modPath.get_current_dir()



func _on_mod_title_text_changed(new_text):
	validityCheck()


func _on_supported_version_text_changed(new_text):
	validityCheck()


# Main bottom buttons
func _on_cancel_pressed():
	queue_free()

func _on_create_pressed():
	var sanitizedName: String
	if modFolder.text.length() < 5:
		# No mod folder name inputted, creating from mod name
		sanitizedName = modTitle.text.to_snake_case()
	else:
		sanitizedName = modFolder.text.substr(4)
	
	var regex = RegEx.new()
	regex.compile("\\W+")
	sanitizedName = regex.sub(sanitizedName,"", true)
	regex.compile("\\_+")
	sanitizedName = regex.sub(sanitizedName,"_", true)
	if sanitizedName.is_empty():
		sanitizedName = "newMod"
	
	modPath.make_dir(sanitizedName)
	modPath.change_dir(sanitizedName)
	
	var descriptorContent: String = str(
		'version="1.0"\n',
		"tags={}\n",
		'name="'+modTitle.text+'"\n',
		'supported_version="'+supportedVersion.text+'"'
	)
	var descFile = FileAccess.open(modPath.get_current_dir()+"/descriptor.mod",FileAccess.WRITE)
	print(modPath.get_current_dir()+"/descriptor.mod")
	descFile.store_string(descriptorContent)
	descFile.close()
	
	queue_free()


# Mod thumbnail stuff
func _on_thumbnail_reset_pressed():
	thumbnailImage.texture = null
	thumbnailPath.text = ""

func _on_thumbnail_select_pressed():
	selectImgFile.show()

func _on_select_image_file_file_selected(path):
	thumbnailPath.text = path
	validateThumbnail()

func _on_thumbnail_path_text_changed(new_text):
	validateThumbnail()


# Mod folder stuff
func _on_mod_folder_button_pressed():
	selectFolder.show()

func _on_select_folder_dir_selected(dir):
	modFolder.text = dir

func _on_mod_folder_text_changed(new_text):
	if modFolder.text.is_empty():
		modFolder.text = prevModPathInput
		return
	else:
		if modFolder.text.length() < 4:
			modFolder.text = prevModPathInput
			return
		
		var cut = modFolder.text.substr(0, 4)
		if cut != "mod/":
			modFolder.text = prevModPathInput
			return
	
	prevModPathInput = modFolder.text

