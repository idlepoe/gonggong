flutter pub run flutter_launcher_icons
flutter pub run build_runner build --delete-conflicting-outputs
gsutil cors set cors.json gs://ulala-now2.firebasestorage.app
.\gradlew signingReport


flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting


flutter build appbundle --release


shorebird release android


flutter pub get
shorebird patch --platforms=android --release-version=1.0.8+9

flutter clean
flutter pub get
flutter build windows
flutter pub run msix:create

