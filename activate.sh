#!/usr/bin/env bash
# Activate the modified configuyrsation.nix

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"

nix_ext="nix"
nixos_dir="/etc/nixos"
date_YYYYMMDD="`date "+%Y%m%d"`"
backup_dir="$nixos_dir/${date_YYYYMMDD}_Backups"

## Main ##

echo "Requesting sudo password if it has not already been requested recently."
sudo echo "Success!"

# Make a backup if one does not already exist for today.
if [[ ! -e "$backup_dir" ]]; then
	echo -e "\nSaving backups for today."
	sudo mkdir -pv "$backup_dir"
	sudo cp -v "$nixos_dir"/*."$nix_ext" "$backup_dir"/
fi

# Ensure unmaintained files exist for import.
nix_static=$nixos_dir/static.nix
if [[ ! -e $nix_static ]]; then
	echo "Creating '$nix_static'."
	echo -e "{ config, pkgs, nix, ... }:\n\n{\n  #\n}" | sudo tee $nix_static
fi
nix_ansible=$nixos_dir/ansible.nix
if [[ ! -e $nix_ansible ]]; then
	echo "Creating '$nix_ansible' from '$nix_static'."
	cp -v $nix_static $nix_ansible
fi

# Start the chain.
sleep 0 &&

	# Essentials, jeez!
	echo -e "\nMaking sure that /bin/bash is available." &&
	sudo ln -vfs `which bash` /bin/bash &&

	# Main install.
	echo -e "\nSwitching to the new configuration." &&
	sudo cp "$DIR"/*."$nix_ext" "$nixos_dir"/ &&
	sudo nixos-rebuild switch &&

	# Completed successfully.
	echo -e "\nSuccess!" &&
	exit 0

## Errors ##

status="$?"
echo "ERROR: A command failed with status $status, please check the output."
exit $status
