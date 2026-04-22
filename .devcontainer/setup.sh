#!/bin/bash
set -e

echo "🚀 Installing system dependencies..."
sudo apt update
sudo apt install -y wget unzip curl git xz-utils zip libglu1-mesa

echo "🚀 Installing Flutter..."
cd /home/vscode
git clone https://github.com/flutter/flutter.git -b stable

echo "🚀 Setting environment variables..."
echo 'export PATH="$PATH:/home/vscode/flutter/bin"' >> ~/.bashrc
echo 'export ANDROID_HOME=/home/vscode/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc

export PATH="$PATH:/home/vscode/flutter/bin"

echo "🚀 Installing Android SDK..."
mkdir -p /home/vscode/Android/Sdk/cmdline-tools
cd /home/vscode/Android/Sdk/cmdline-tools

wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-*.zip
mv cmdline-tools latest

export ANDROID_HOME=/home/vscode/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

echo "🚀 Accepting licenses..."
yes | sdkmanager --licenses

echo "🚀 Installing SDK 36..."
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0"

echo "🚀 Configure Flutter..."
flutter config --android-sdk $ANDROID_HOME

echo "🚀 Running doctor..."
flutter doctor