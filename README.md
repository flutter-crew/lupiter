# lupiter
![Logo](./icon.png?raw=true "Logo")

### Create
flutter create --org com.fluttercrew --platforms=ios,android --overwrite lupiter

### Build
flutter build apk --target "lib/lupiter.dart" --release --split-per-abi --split-debug-info --obfuscate

#### Generate Assets
flutter pub run "tool/generate_assets.dart" --class-name LupiterAssets --output-file "lib\\generated\\lupiter_assets.g.dart" --exclude "\\fonts\\"

#### Generate Translations
flutter pub run "tool/generate_localization.dart" -f keys -S "assets/translations" -O "lib/generated" -o ${workspaceFolder}_localization.g.dart

#### Create Launch Icons
flutter pub run flutter_launcher_icons:main

#### Native Splash
flutter pub run flutter_native_splash:create
flutter pub run flutter_native_splash:remove

### Release
Android `Release key` and `key.properties` in android/app