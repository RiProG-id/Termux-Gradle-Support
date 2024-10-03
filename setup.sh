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
echo "2. Install JDK (OpenJDK 17)"
echo "3. Uninstall Android SDK"
echo "4. Uninstall JDK"
echo "5. Exit"
read -p "Select an option [1-5]: " option

case $option in
1)
	sdk_version="34.0.4"
	arch=$(uname -m)
	if [ "$arch" != "x86_64" ] && [ "$arch" != "aarch64" ] && [ "$arch" != "arm" ]; then
		echo "Unknown architecture: $arch."
		exit 1
	fi
	echo "Creating Android SDK directory..."
	mkdir -p "$$HOME/android-sdk"
	echo "Downloading Android SDK..."
	curl -L -o "$$HOME/android-sdk/android-sdk.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/sdk/android-sdk.tar.xz"
	if [ $? -eq 0 ]; then
		echo "Extracting Android SDK..."
		tar -xf "$$HOME/android-sdk/android-sdk.tar.xz" -C "$$HOME/android-sdk" && echo "Android SDK extracted."
	else
		echo "Failed to download Android SDK."
		exit 1
	fi
	curl -L -o "$$HOME/android-sdk/android-sdk-platform-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/platform-tools-$sdk_version-$arch.tar.xz"
	if [ $? -eq 0 ]; then
		echo "Extracting Android SDK Platform Tools..."
		tar -xf "$$HOME/android-sdk/android-sdk-platform-tools.tar.xz" -C "$$HOME/android-sdk" && echo "Android SDK Platform Tools extracted."
	else
		echo "Failed to download Android SDK Platform Tools."
		exit 1
	fi
	echo "Downloading Android SDK Build Tools..."
	curl -L -o "$$HOME/android-sdk/android-sdk-build-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/build-tools-$sdk_version-$arch.tar.xz"
	if [ $? -eq 0 ]; then
		echo "Extracting Android SDK Build Tools..."
		tar -xf "$$HOME/android-sdk/android-sdk-build-tools.tar.xz" -C "$$HOME/android-sdk" && echo "Android SDK Build Tools extracted."
	else
		echo "Failed to download Android SDK Build Tools."
		exit 1
	fi
	echo "Downloading Android SDK Platform Tools..."
	curl -L -o "$$HOME/android-sdk/android-sdk-platform-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/v$sdk_version/platform-tools-$sdk_version-$arch.tar.xz"
	if [ $? -eq 0 ]; then
		echo "Extracting Android SDK Platform Tools..."
		tar -xf "$$HOME/android-sdk/android-sdk-platform-tools.tar.xz" -C "$$HOME/android-sdk" && echo "Android SDK Platform Tools extracted."
	else
		echo "Failed to download Android SDK Platform Tools."
		exit 1
	fi
	echo "Downloading Command-Line Tools..."
	curl -L -o "$$HOME/android-sdk/cmdline-tools.tar.xz" "https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/sdk/cmdline-tools.tar.xz"
	if [ $? -eq 0 ]; then
		echo "Extracting Command-Line Tools..."
		tar -xf "$$HOME/android-sdk/cmdline-tools.tar.xz" -C "$$HOME/android-sdk" && echo "Command-Line Tools extracted."
	else
		echo "Failed to download Command-Line Tools."
		exit 1
	fi
	ln -s "$HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager" "$PREFIX/bin/sdkmanager"
	echo "Symbolic link for sdkmanager created at $PREFIX/bin/sdkmanager."
	for config_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
		echo "Adding variables to $config_file..."
		if [ -f "$config_file" ]; then
			touch "$config_file"
		fi
		echo "export ANDROID_HOME=$HOME/android-sdk" >>"$config_file"
		echo "export ANDROID_SDK_ROOT=$HOME/android-sdk" >>"$config_file"
		echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin" >>"$config_file"
		echo "Environment variables successfully added."
	done
	;;
2)
	echo "Installing OpenJDK 17..."
	pkg install openjdk-17 -y
	if [ $? -eq 0 ]; then
		echo "OpenJDK 17 installed successfully."
	else
		echo "Failed to install OpenJDK 17."
	fi
	for config_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
		echo "Adding variables to $config_file..."
		if [ -f "$config_file" ]; then
			touch "$config_file"
		fi
		echo "export JAVA_HOME=$PREFIX/usr/opt/openjdk-17.0" >>"$config_file"
		echo "Environment variables successfully added."
	done
	;;

3)
	echo "Uninstalling Android SDK..."
	rm -rf "$HOME/android-sdk"
	if [ $? -eq 0 ]; then
		echo "Android SDK uninstalled successfully."
	else
		echo "Failed to uninstall Android SDK."
	fi
	rm -f "$PREFIX/bin/sdkmanager"
	echo "Removed symbolic link for sdkmanager at $PREFIX/bin/sdkmanager"
	echo "Clearing environment variables from $config_file..."
	if [ -f "$config_file" ]; then
		sed -i '/^export ANDROID_HOME=/d' "$config_file"
		sed -i '/^export ANDROID_SDK_ROOT=/d' "$config_file"
		sed -i '/^export PATH=.*ANDROID_HOME/d' "$config_file"
		echo "Environment variables have been cleared successfully."
		if [ ! -s "$config_file" ]; then
			rm "$config_file"
			echo "Configuration file is missing. Creating $config_file..."
		fi
	fi
	;;

4)
	echo "Uninstalling OpenJDK 17..."
	pkg uninstall openjdk-17 -y
	if [ $? -eq 0 ]; then
		echo "OpenJDK 17 uninstalled successfully."
	else
		echo "Failed to uninstall OpenJDK 17."
	fi
	echo "Clearing environment variables from $config_file..."
	if [ -f "$config_file" ]; then
		sed -i '/^export JAVA_HOME=/d' "$config_file"
		echo "Environment variables have been cleared successfully."
		if [ ! -s "$config_file" ]; then
			rm "$config_file"
			echo "Configuration file is empty and has been removed."
		fi
	fi
	;;

5)
	echo "Exiting..."
	exit 0
	;;

*)
	echo "Invalid option. Please select a valid option."
	;;
esac
