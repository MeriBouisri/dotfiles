#!/bin/bash

# Path constants
NVIM_ENVS="$HOME/nvim-envs"
NVIM_KWORD="nvim"
TARGET_NVIM_CONFIG="$HOME/.config/nvim"
TARGET_NVIM_LOCAL="$HOME/.local"
TARGET_NVIM_DATA="$XDG_DATA_HOME/nvim"
TARGET_NVIM_CACHE="$XDG_CACHE_HOME/nvim"

# Mandatory directories inside an nvim-env dir
SOURCE_NVIM_CONFIG="config"
SOURCE_NVIM_LOCAL="local"
SOURCE_NVIM_LOCAL_DIRS=("share" "state")

NVIM_DEFAULT_ENV="nvim-kauboj"

# ===============================
# ===== UTILITARY FUNCTIONS =====
# ===============================
extract_symlink_basename() {
	local sep='/'
	local source_symlink=$(readlink $1)

	# If empty source, then the target is not a symlink
	[ -z "$source_symlink" ] && return

	# Remove path prefix (NVIM_ENVS)
	# Return the name of the first field, which should be the name of the source folder
	echo $(echo "${source_symlink#${NVIM_ENVS}/}" | awk -F$sep '{print $1}')
}

# =======================================
# ===== NVIM ENVIRONMENT VALIDATION =====
# =======================================

# Check if NeoVim environment directory exists. If not, create it.
if [ ! -d "$NVIM_ENVS" ]; then
	echo "Creating NeoVim environment directory..."
	mkdir $NVIM_ENVS:

	if [ $? -eq 0 ]; then
		echo "Successfully created directory: $NVIM_ENVS"
	else
		echo "ERROR: Failed to create directory $NVIM_ENVS" >&2
		exit 1
	fi
fi

# Check if NeoVim environment directory is empty
if [ -z "$(ls -A "$NVIM_ENVS")" ]; then
	echo "ERROR: NeoVim environment directory is empty" >&2
	exit 1
fi

# Set the selected environment
new_symlink_source_basename=$1
if [ -z "$new_symlink_source_basename" ]; then
	new_symlink_source_basename=$NVIM_DEFAULT_ENV
fi

# Check if the environment directory exists
new_symlink_source_path=$NVIM_ENVS/$new_symlink_source_basename
if [ ! -d "$new_symlink_source_path" ]; then
	echo "ERROR: NeoVim environment doesn't exist: $new_symlink_source_path" >&2
	exit 1
fi

# Check if the environment directory is valid (must contain ./config/ folder)
new_symlink_source_config=$new_symlink_source_path/$SOURCE_NVIM_CONFIG
if [ ! -d "$new_symlink_source_config" ]; then
	echo "ERROR: NeoVim environment config/ folder doesn't exist: $new_symlink_source_config" >&2
	exit 1
fi

# ===== SOURCE LOCAL FILES =====

new_symlink_source_local=$new_symlink_source_path/$SOURCE_NVIM_LOCAL
if [ ! -d "$new_symlink_source_local" ]; then
	echo "Creating local environment folder..."
	mkdir $new_symlink_source_local
fi

new_symlink_source_local_data="$new_symlink_source_local/share"
if [ ! -d "$new_symlink_source_local_data" ]; then
	echo "Creating new local data folder..."
	mkdir $new_symlink_source_local_data
fi

new_symlink_source_local_cache="$new_symlink_source_local/state"
if [ ! -d "$new_symlink_source_local_cache" ]; then
	echo "Creating new local cache folder..."
	mkdir $new_symlink_source_local_cache
fi

# ===============================
# ===== ENVIRONMENT SYMLINK =====
# ===============================

# Check if symlink already exists
if [ -d "$TARGET_NVIM_CONFIG" ]; then
	current_symlink_source_config=$(readlink $TARGET_NVIM_CONFIG)
	current_symlink_source_path="${current_symlink_source_config%${SOURCE_NVIM_CONFIG}}"
	current_symlink_source_basename=$(extract_symlink_basename $TARGET_NVIM_CONFIG)

	current_symlink_source_local=$current_symlink_source_path$SOURCE_NVIM_LOCAL
	current_symlink_source_local_data="$current_symlink_source_local/share"
	current_symlink_source_local_cache="$current_symlink_source_local/state"

	echo "Current NeoVim environment symlink: $current_symlink_source_basename"

	# Check for duplicate symlink
	if [[ "$current_symlink_source_config" == "$new_symlink_source_config" ]]; then
		echo "NeoVim environment already linked: $new_symlink_source_basename"
	else
		# Unlink current symlink
		echo "Unlinking current environment configuration..."
		rm -r "$TARGET_NVIM_CONFIG"

		echo "Linking new environment configuration..."
		ln -s "$new_symlink_source_config" "$TARGET_NVIM_CONFIG"
		if [ $? -eq 0 ]; then
			echo "Successfully linked new configuration!"
		else
			echo "ERROR: Failed to link new configuration" >&2
		fi
	fi

	if [ -d "$TARGET_NVIM_DATA" ]; then
		echo "Unlinking current environment data... "
		rsync -av --delete --no-links "$TARGET_NVIM_DATA/" "$current_symlink_source_local_data"
    rm -r "$TARGET_NVIM_DATA"
    if [ $? -eq 1 ]; then
      echo "ERROR: Couldn't remove current environment data: $TARGET_NVIM_DATA" >&2 
      exit 1
    fi
    echo "Linking new environment data..."
    ln -s "$new_symlink_source_local_data" "$TARGET_NVIM_DATA"
    echo "Successfully linked new environment data: $(readlink $TARGET_NVIM_DATA)"

	fi

	if [ -d "$TARGET_NVIM_CACHE" ]; then
		echo "Unlinking current environment cache..."
		rsync -av --delete --no-links "$TARGET_NVIM_CACHE/" "$current_symlink_source_local_cache"
		rm -r "$TARGET_NVIM_CACHE"
    if [ $? -eq 1 ]; then
      echo "ERROR: Couldn't remove current environment cache: $TARGET_NVIM_CACHE" >&2
      exit 1
    fi
    echo "Linking new environment cache..."
    ln -s "$new_symlink_source_local_cache" "$TARGET_NVIM_CACHE"
    echo "Successfully linked new environment cache: $(readlink $TARGET_NVIM_CACHE)"
	fi
fi

