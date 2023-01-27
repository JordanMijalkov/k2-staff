#!/usr/bin/env bash
# place this script in project/android/app/
cd ..
# fail if any command fails
set -e

# We will need to add SSH info so our flutter library will resolve from Azure
ssh-keyscan -t rsa ssh.dev.azure.com >>~/.ssh/known_hosts
echo "$AZURE_ID_RSA" | base64 -D >~/.ssh/id_rsa_k2_ci
chmod 600 ~/.ssh/id_rsa_k2_ci
ssh-add ~/.ssh/id_rsa_k2_ci

# debug log
set -x

cd ..
# choose a different release channel if you want - https://github.com/flutter/flutter/wiki/Flutter-build-release-channels
# stable - recommended for production

git clone -b stable https://github.com/flutter/flutter.git
export PATH=$(pwd)/flutter/bin:$PATH

flutter channel stable
flutter doctor
flutter --version

flutter clean

flutter pub get
flutter pub run intl_utils:generate

flutter build apk --release \
  --build-number=$APPCENTER_BUILD_ID

flutter build appbundle --release \
  --build-number=$APPCENTER_BUILD_ID

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
#flutter build appbundle

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/
mv build/app/outputs/apk/release/app-release.apk $_

# copy the AAB where AppCenter will find it
mkdir -p android/app/build/outputs/bundle/
mv build/app/outputs/bundle/release/app-release.aab $_
