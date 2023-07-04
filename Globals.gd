extends Node

var gamePath: DirAccess
var gameModPath: DirAccess

# Define settings values upon program launch
func _ready():
	var platform := OS.get_name()
	
	# Setting up default directories
	if platform.contains("Windows") || platform.contains("UWP"):
		var homeDir := DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
		homeDir.change_dir("../") # user directory
		gamePath = DirAccess.open(homeDir.get_current_dir())
		gameModPath = DirAccess.open(homeDir.get_current_dir())
	elif platform.contains("macOS") || platform.contains("Linux") || platform.contains("BSD"):
		var homeDir := DirAccess.open("~") # by default as home dir
		if homeDir != null:
			gamePath = DirAccess.open(homeDir.get_current_dir())
			gameModPath = DirAccess.open(homeDir.get_current_dir())
		else:
			gamePath = DirAccess.open(OS.get_data_dir())
			gameModPath = DirAccess.open(OS.get_data_dir())
	
	# Finding default gameModPath
	if platform.contains("Windows") || platform.contains("UWP") || platform.contains("macOS"):
		if gameModPath.dir_exists("Documents/Paradox Interactive/Hearts of Iron IV/mod"):
			gameModPath.change_dir("Documents/Paradox Interactive/Hearts of Iron IV/mod")
	elif platform.contains("Linux"):
		if gameModPath.dir_exists(".local/share/Paradox Interactive/Hearts of Iron IV/mod"):
			gameModPath.change_dir(".local/share/Paradox Interactive/Hearts of Iron IV/mod")
		
	
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
	
