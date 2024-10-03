#!/bin/bash
pkg update
pkg upgrade
clear
echo "Termux Gradle Support"
echo "By RiProG id"
echo "Based on AndroidIDE"
if ! echo "$PREFIX" | grep -q termux; then
	echo "This script is only supported in Termux."
	exit 1
fi
echo ""
echo "Menu:"
echo "1. Install Android SDK (Version 34.0.4)"
echo "2. Uninstall Android SDK"
echo "3. Install JDK (OpenJDK 17)"
echo "4. Uninstall JDK"
printf "Select an option [1-5]: "
read -r option
echo ""
case $option in
1)
	sdk_version="34.0.4"
	arch=$(uname -m)
	if [ "$arch" != "x86_64" ] && [ "$arch" != "aarch64" ] && [ "$arch" != "arm" ]; then
		echo "Unknown architecture: $arch."
		exit 1
	fi
	echo "Creating Android SDK directory..."
	mkdir -p "$HOME/android-sdk"
	echo "Downloading Android SDK..."
	if curl -L -o "$HOME/android-sdk/android-sdk.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/sdk/android-sdk.tar.xz"; then
		echo "Extracting Android SDK..."
		tar -xf "$HOME/android-sdk/android-sdk.tar.xz" -C "$HOME/android-sdk" && echo "Android SDK extracted."
	else
		echo "Failed to download Android SDK."
		exit 1
	fi
	if curl -L -o "$HOME/android-sdk/android-sdk-platform-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/platform-tools-$sdk_version-$arch.tar.xz"; then
		echo "Extracting Android SDK Platform Tools..."
		tar -xf "$HOME/android-sdk/android-sdk-platform-tools.tar.xz" -C "$HOME/android-sdk" && echo "Android SDK Platform Tools extracted."
	else
		echo "Failed to download Android SDK Platform Tools."
		exit 1
	fi
	echo "Downloading Android SDK Build Tools..."
	if curl -L -o "$HOME/android-sdk/android-sdk-build-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/build-tools-$sdk_version-$arch.tar.xz"; then
		echo "Extracting Android SDK Build Tools..."
		tar -xf "$HOME/android-sdk/android-sdk-build-tools.tar.xz" -C "$HOME/android-sdk" && echo "Android SDK Build Tools extracted."
	else
		echo "Failed to download Android SDK Build Tools."
		exit 1
	fi
	echo "Downloading Android SDK Platform Tools..."
	if curl -L -o "$HOME/android-sdk/android-sdk-platform-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/platform-tools-$sdk_version-$arch.tar.xz"; then
		echo "Extracting Android SDK Platform Tools..."
		tar -xf "$HOME/android-sdk/android-sdk-platform-tools.tar.xz" -C "$HOME/android-sdk" && echo "Android SDK Platform Tools extracted."
	else
		echo "Failed to download Android SDK Platform Tools."
		exit 1
	fi
	echo "Downloading Command-Line Tools..."
	if curl -L -o "$HOME/android-sdk/cmdline-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/sdk/cmdline-tools.tar.xz"; then
		echo "Extracting Command-Line Tools..."
		tar -xf "$HOME/android-sdk/cmdline-tools.tar.xz" -C "$HOME/android-sdk" && echo "Command-Line Tools extracted."
	else
		echo "Failed to download Command-Line Tools."
		exit 1
	fi
	ln -s "$HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager" "$PREFIX/bin/sdkmanager"
	echo "Symbolic link for sdkmanager created at $PREFIX/bin/sdkmanager."
	echo "Removing Android SDK tar files..."
	rm -f "$HOME/android-sdk/android-sdk.tar.xz"
	echo "Removed Android SDK archive."
	rm -f "$HOME/android-sdk/android-sdk-build-tools.tar.xz"
	echo "Removed Android SDK Build Tools archive."
	rm -f "$HOME/android-sdk/android-sdk-platform-tools.tar.xz"
	echo "Removed Android SDK Platform Tools archive."
	rm -f "$HOME/android-sdk/cmdline-tools.tar.xz"
	echo "Removed Command-Line Tools archive."
	echo "All specified archives have been removed."
	for config_file in "$HOME/.bashrc" "$HOME/.zashrc"; do
		echo "Inserting environment variables from $config_file..."
		{
			echo "export ANDROID_HOME=$HOME/android-sdk"
			echo "export ANDROID_SDK_ROOT=$HOME/android-sdk"
			echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin"
		} >>"$config_file"
		echo "Environment variables successfully added."
		echo "Starting the process to remove duplicate lines from $config_file.."
		awk '!seen[$0]++' "$config_file" >"$config_file.tmp" && mv "$config_file.tmp" "$config_file"
		echo "Duplicate lines removed successfully from $config_file"
	done
	;;
2)
	echo "Uninstalling Android SDK..."
	rm -rf "$HOME/android-sdk"
	echo "Failed to uninstall Android SDK."
	echo "Removing symbolic link for sdkmanager..."
	rm -f "$PREFIX/bin/sdkmanager"
	echo "Removed symbolic link for sdkmanager at $PREFIX/bin/sdkmanager."
	for config_file in "$HOME/.bashrc" "$HOME/.zashrc"; do
		echo "Clearing environment variables from $config_file..."
		if [ -f "$config_file" ]; then
			sed -i '/^export ANDROID_HOME=/d' "$config_file"
			sed -i '/^export ANDROID_SDK_ROOT=/d' "$config_file"
			sed -i '/^export PATH=.*ANDROID_HOME/d' "$config_file"
			echo "Environment variables have been cleared successfully."
			if [ ! -s "$config_file" ]; then
				rm "$config_file"
				echo "Configuration file is missing. Deleting $config_file..."
			fi
		fi
	done
	;;
3)
	echo "Installing OpenJDK 17..."
	if pkg install openjdk-17 -y; then
		echo "OpenJDK 17 installed successfully."
	else
		echo "Failed to install OpenJDK 17."
	fi
	for config_file in "$HOME/.bashrc" "$HOME/.zashrc"; do
		echo "Inserting environment variables from $config_file..."
		echo "export JAVA_HOME=$PREFIX/lib/jvm/java-17-openjdk" >>"$config_file"
		echo "Environment variables successfully added."
		echo "Starting the process to remove duplicate lines from $config_file.."
		awk '!seen[$0]++' "$config_file" >"$config_file.tmp" && mv "$config_file.tmp" "$config_file"
		echo "Duplicate lines removed successfully from $config_file"
	done
	;;
4)
	echo "Uninstalling OpenJDK 17..."
	if pkg uninstall openjdk-17 -y; then
		echo "OpenJDK 17 uninstalled successfully."
	else
		echo "Failed to uninstall OpenJDK 17."
	fi
	for config_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
		echo "Clearing environment variables from $config_file..."
		if [ -f "$config_file" ]; then
			sed -i '/^export JAVA_HOME=/d' "$config_file"
			echo "Environment variables have been cleared successfully."
			if [ ! -s "$config_file" ]; then
				rm "$config_file"
				echo "Configuration file is missing. Deleting $config_file..."
			fi
		fi
	done
	;;
*)
	echo "Invalid option. Please select a valid option."
	;;
esac
sleep 5
echo ""
echo "Please run 'sdkmanager --licenses' before using Gradle."
echo "This ensures that all necessary enses are accepted."
echo ""
sleep 5
echo "Please close Termux."
echo "Reopen it to reload the environment variables."
echo ""
sleep 5
exit 0
