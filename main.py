import os
    
directory = os.getcwd()

DIRECTORY_FILES = os.listdir(directory)
temp_dir = os.getenv("TEMP")
new_dir = temp_dir[slice(0, len(temp_dir) - 5)]
WORLDS_DIR_PATH = f"{new_dir}\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds"
FILES_TO_IGNORE = [".git", "output.txt", "main.py"]

def filter_ignore(file) -> bool:
    return file not in FILES_TO_IGNORE

filtered_list = [file for file in filter(filter_ignore, DIRECTORY_FILES)]
print(WORLDS_DIR_PATH)

CURRENT_WORLDS = os.listdir(WORLDS_DIR_PATH)
def filter_files(file) -> bool:
    return file in filtered_list

