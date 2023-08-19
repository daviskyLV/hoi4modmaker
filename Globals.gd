extends Node

var gameModsPath: DirAccess = null
var gameInstallPath: DirAccess = null
var gameVersion: String = "1.12.*"
var version: String = "UNDEFINED"

# Define settings values upon program launch
func _ready():
	var platform := OS.get_name()
	
	# Finding game install/mods paths
	if platform.contains("Windows") || platform.contains("UWP"):
		gameModsPath = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)+"/Paradox Interactive/Hearts of Iron IV/mod")
		gameInstallPath = DirAccess.open("C:/Program Files (x86)/Steam/steamapps/common/Hearts of Iron IV")
	elif platform.contains("macOS"):
		gameModsPath = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)+"/Paradox Interactive/Hearts of Iron IV/mod")
		gameInstallPath = DirAccess.open("~/Library/Application Support/Steam/steamapps/common/Hearts of Iron IV")
	elif platform.contains("Linux"):
		gameModsPath = DirAccess.open("~/.local/share/Paradox Interactive/Hearts of Iron IV/mod")
		gameInstallPath = DirAccess.open("~/.local/share/Steam/SteamApps/common/Hearts of Iron IV")
	
