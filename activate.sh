#!/usr/bin/env bash
# Activate the modified configuyrsation.nix

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"

## Main ##

echo "Requesting sudo password if it has not already been requested recently."

# Start the chain.
sudo echo "Success!" &&

	# Essentials, jeez!
	echo "Making sure that /bin/bash is available." &&
	sudo ln -vqfs `which bash` /bin/bash &&

	# Main install.
	echo "Switching to the new configuration." &&
	sudo cp $DIR/configuration.nix /etc/nixos/configuration.nix &&
	sudo nixos-rebuild switch &&
	exit 0

## Errors ##

status="$?"
echo "ERROR: A command failed with status $status, please check the output."
exit $status
