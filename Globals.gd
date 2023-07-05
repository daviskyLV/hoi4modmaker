extends Node

var gamePath: DirAccess = DirAccess.open(OS.get_data_dir())
var gameDataPath: DirAccess = DirAccess.open(OS.get_data_dir())
var parsedLaunchSettings: Dictionary = {}
var gameVersion: String = "1.0.0"
var modSubpath: String = ""

# Define settings values upon program launch
func _ready():
	var platform := OS.get_name()
	
	# Setting up default directories
	if platform.contains("Windows") || platform.contains("UWP"):
		var homeDir := DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
		if homeDir == null:
			return
		
		homeDir.change_dir("../") # user directory
		gamePath = DirAccess.open(homeDir.get_current_dir())
	elif platform.contains("macOS") || platform.contains("Linux") || platform.contains("BSD"):
		var homeDir := DirAccess.open("~") # by default as home dir
		if homeDir != null:
			gamePath = DirAccess.open(homeDir.get_current_dir())
		else:
			gamePath = DirAccess.open(OS.get_data_dir())
	else:
		gamePath = DirAccess.open(OS.get_data_dir())
	
	# Checking for null directories
	if gamePath == null:
		gamePath = DirAccess.open(OS.get_data_dir())
		return
	
	# Finding game path
	if platform.contains("Linux"):
		if gamePath.dir_exists(".local/share/Paradox Interactive/Hearts of Iron IV"):
			gamePath.change_dir(".local/share/Paradox Interactive/Hearts of Iron IV")
	elif platform.contains("Windows") || platform.contains("UWP"):
		var err = gamePath.change_dir("../../") # C:/ directory
		if !err:
			# checking for steam installation
			if gamePath.dir_exists("Program Files (x86)/Steam/steamapps/common/Hearts of Iron IV"):
				gamePath.change_dir("Program Files (x86)/Steam/steamapps/common/Hearts of Iron IV")
	elif platform.contains("macOS"):
		# Checking for steam installation
		if gamePath.dir_exists("Library/Application Support/Steam/steamapps/common/Hearts of Iron IV"):
			gamePath.change_dir("Library/Application Support/Steam/steamapps/common/Hearts of Iron IV")
	
	# Accessing launch settings file
	var launchSettingsFile: FileAccess
	if gamePath.file_exists("launcher-settings.json"):
		launchSettingsFile = FileAccess.open(gamePath.get_current_dir()+"/launcher-settings.json", FileAccess.READ)
	else:
		return
	
	# Parsing json
	var parsedJson: Dictionary = JSON.parse_string(launchSettingsFile.get_as_text())
	if parsedJson == null:
		return
	
	# Getting values from json
	gameVersion = parsedJson.rawVersion
	var parsedDataPath: String = parsedJson.gameDataPath
	parsedDataPath = parsedDataPath.replace("%USER_DOCUMENTS%", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	gameDataPath = DirAccess.open(parsedDataPath)
	modSubpath = parsedJson.gameCachePaths[5]
	parsedLaunchSettings = parsedJson
	
