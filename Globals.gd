extends Node

var gamePath: DirAccess = DirAccess.open(OS.get_data_dir()) # by default as home dir
var gameModPath: DirAccess = DirAccess.open(OS.get_data_dir())

# Define settings values upon program launch
func _ready():
	var platform := OS.get_name()
	
	# Finding default gameModPath
	if platform.contains("Linux"):
		if gameModPath.dir_exists(".local/share/Paradox Interactive/Hearts of Iron IV"):
			gameModPath.change_dir(".local/share/Paradox Interactive/Hearts of Iron IV")
	elif platform.contains("Windows") || platform.contains("UWP") || platform.contains("macOS"):
		if gameModPath.dir_exists("Documents/Paradox Interactive/Hearts of Iron IV"):
			gameModPath.change_dir("Documents/Paradox Interactive/Hearts of Iron IV")
		
	
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
	
