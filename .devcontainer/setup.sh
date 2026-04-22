#!/bin/bash

set -e

echo "🚀 Installing dependencies..."
sudo apt update
sudo apt install -y wget unzip curl git xz-utils zip libglu1-mesa

echo "🚀 Installing Flutter..."
cd $HOME
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

echo "🚀 Setting PATH..."
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
export PATH="$PATH:$HOME/flutter/bin"

echo "🚀 Installing Android SDK..."
mkdir -p $HOME/Android/Sdk/cmdline-tools
cd $HOME/Android/Sdk/cmdline-tools

if [ ! -d "latest" ]; then
  wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  unzip commandlinetools-linux-*.zip
  mv cmdline-tools latest
fi

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

echo "export ANDROID_HOME=$HOME/Android/Sdk" >> ~/.bashrc
echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin" >> ~/.bashrc
echo "export PATH=\$PATH:\$ANDROID_HOME/platform-tools" >> ~/.bashrc

echo "🚀 Accepting licenses..."
yes | sdkmanager --licenses

echo "🚀 Installing SDK 36..."
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0"

echo "🚀 Configuring Flutter..."
flutter config --android-sdk $ANDROID_HOME

echo "🚀 Done! Run: flutter doctor"