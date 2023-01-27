#!/usr/bin/env bash
#Place this script in project/ios/

echo "Uninstalling all CocoaPods versions"
sudo gem uninstall cocoapods --all --executables

COCOAPODS_VER=`sed -n -e 's/^COCOAPODS: \([0-9.]*\)/\1/p' Podfile.lock`

echo "Installing CocoaPods version $COCOAPODS_VER"
sudo gem install cocoapods #-v $COCOAPODS_VER

# fail if any command fails
set -e

# We will need to add SSH info so our flutter library will resolve from Azure
ssh-keyscan -t rsa ssh.dev.azure.com >>~/.ssh/known_hosts
echo "$AZURE_ID_RSA" | base64 -D >~/.ssh/id_rsa_k2_ci
chmod 600 ~/.ssh/id_rsa_k2_ci
ssh-add ~/.ssh/id_rsa_k2_ci

# debug log
set -x

pod setup

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=$(pwd)/flutter/bin:$PATH

flutter channel stable
flutter doctor
echo "Installed flutter to $(pwd)/flutter"
flutter --version

flutter clean

flutter pub get
flutter pub run intl_utils:generate

flutter build ios --release --no-codesign 
  # --dart-define=K2_API_URL=$K2_API_URL \
  # --dart-define=K2_API_URL_RESOLVER_PATH=$K2_API_URL_RESOLVER_PATH \
  # --dart-define=K2_API_URL_WS_PATH=$K2_API_URL_WS_PATH \
  # --dart-define=K2_API_SECURE_PROTOCOL=$K2_API_SECURE_PROTOCOL \
  # --dart-define=COGNITO_USER_POOL_ID=$COGNITO_USER_POOL_ID \
  # --dart-define=COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID
