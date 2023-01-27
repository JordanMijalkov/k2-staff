# kiosk

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Building

To manage environment settings, we are using Dart's compile-time `dart-define` system. For every Paramter we want to set,
we coould do so via something like:
```
flutter build web \
      --dart-define=HTTP_PROTOCOL=$HTTP_PROTOCOL \
      --dart-define=K2_API_URL=$K2_API_URL \
      --dart-define=COGNITO_USER_POOL_ID=$COGNITO_USER_POOL_ID \
      --dart-define=COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID
```
This works for both `build` and `run`. The example above sets values to a correspoinding environment variable, but the can be set explicitly as well.

Please note that there is a bug in flutter, that requires decalring these as a `const` when laoded in the code, or else they don't work!

The following additonal platform-specific info assumes you pass in the needed `--dart-define`s, after the main command, as in the example above!

### Building for Web

You should be sure you are in the `beta` channel of flutter, as you will need that to use the web target for `flutter run`. You will need
to run `flutter config --enable-web` once, to set your flutter environment that you want to enable the web option.

For a production build that is minified + includes tree-shaking, you only need to
```
flutter build web
```
This will output the static site in `build/web`, and it can then be packaged/Dockerized and deployed as any static site can be.

For our deployment strategy, see
* `Dockerfile`
* `k2-kiosk-chart` helm chart
* `./azure-pipeline/master-deploy.yaml`

### Building for iOS

### Apple Things

Official Help:
https://flutter.dev/docs/deployment/ios
https://docs.microsoft.com/en-us/appcenter/build/ios/code-signing

#### Step 1: There's an App for That
Set up an app on AppstoreConnect - make note of the `Bundle ID`, it can't be changed. Currently,
it's set up with a base Bundle Id of `com.kangarootime.k2.*` and you set the Bundle ID Suffix to be representative
of the app, so in out case our app Bundle ID is `com.kangarootime.k2.workforce`.

Update the lines containing `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj` to
match the `Bundle ID`

#### Step 2: App Center
CI/CD is set up in AppCenter, and eventually to deploy to TestFlight (See next step).

You'll need to set up an App in AppCenter, selecting iOS and Objective C/Swift. Then, you can point it towards
the git repository in Azure. NOTE: We'll need one for iOS and one for Android, so perhaps name it something like
`AppName | iOS`. For Flutter, we'll use the `Post Clone` script hook to do the building. See
* `ios/appcenter-post-clone.sh`
This is a typical CI/CD script - it install/sets up flutter, and then builds the project. The main
line is
```
flutter build ios --release --no-codesign
```
Notice that we're building a release version for ios but NOT signing it (`--no-codesign`)! We will use
the AppCenter Build system to do that for us.

Select the `Build` option from the AppCenter menu bar, and configure the `master` branch. NOTE, that
these branches and their configurations will disappear from AppCenter when deleted from the repository!

Some of the options to set:
* XCode Version (currently using 11.3.1)
* Build frequency (every push vs manual trigger)
* Turn ON `Automatically increment build number` and use `Build number format: Build ID`
* Turn ON Environment variables, and set the values used for the `--dart-define=ABC=$ABC`s
* Sign Builds! (This is where the magic happens)
* Distribute Builds (We'll revisit this below)

To Sign a build, you'll need to upload a `.mobileprovision` Provisioning Profile and a (password protected)
`.p12` Certificate from the Apple Developer portal. Unfortunately, getting those is outside the scope of
this README.

With all of that set up, it is possible to create your first signed build, which can be uploaded to
Test Flight....

#### Step 3: Test Flight
App Center can only upload new versions to existing apps that are already published on the App Store or TestFlight.

So you'll need to do that. See `Step 2`,

Since we're trying to get Test Flight to Build + Sign our app anyway, I recommend getting the configuration in a state
where you can manually run + sign a build for iOS, download that artifact, and upload it to the app store as the first
build. Then, you can be pretty sure the following builds will be good to go. You can upload the build with a utility
named `Transporter`. You can find more info on it from TestFLight directly.

Once uploaded, you'll need to make sure the app is "ready to test", which also includes going through a dialog about
encryption used in the app via the Test Flight portal. Once that is good to go, you can re-visit AppCenter.

In AppCenter, adjust the Build for the master branch, and go to the `Distribute Builds` section. Turn it on,
select `Store`, and follow the guide to link it to the App + TestFlight! It should be a pretty painless
wizard to follow.

### Building for Android

Official Links:
https://flutter.dev/docs/deployment/android
https://docs.microsoft.com/en-us/appcenter/distribution/stores/googleplay

Less Official Links:
https://buildflutter.com/deploying-flutter-apps-via-appcenter/

### Step 1: There's Another App For That
Google also requires the first version of your Google Play application to be published to production through the Google console.
The AppCenter Distribution link above goes over most everything that is needed.

### Step 2: App Center

You'll need a keystore to sign your builds. The Flutter "Official Link" above goes over this.

You'll need to edit `android/.gitignore` to allow some files to be tracked, or else AppCenter won't detect it as an Android project.
Note the three things commented out below.

```
#gradle-wrapper.jar
/.gradle
/captures/
#/gradlew
#/gradlew.bat
/local.properties
GeneratedPluginRegistrant.java
```

You'll have to increment the build number for Android, as the AppCenter build settings don't seem to override the final product
(at least for app bundles).
```
fluter build \
  ...
  --build-number=$APPCENTER_BUILD_ID
```

### Step 3: Google Play Store

AppCenter says it will only connect to default tracks for an App, however, what the really means is it will only connect
to default `alpha`, `beta`, and `production` tracks. The first time you upload an app, _in a single track_,
don't expect to do anything with it until the next day...

We'll CICD into a private alhpa track, and can release builds into `production` (or `beta`) as needed.

## Running the App

Just as with the build, we need to set the `--dart-define`'s to set some parameters, if we don't want them to point
to the default `develop` values. It's probably easiest to set some run configurations in your environment.

```sh
flutter run \
      --dart-define=HTTP_PROTOCOL=$HTTP_PROTOCOL \
      --dart-define=K2_API_URL=$K2_API_URL \
      --dart-define=COGNITO_USER_POOL_ID=$COGNITO_USER_POOL_ID \
      --dart-define=COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID
```
