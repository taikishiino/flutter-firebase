path:
	export PATH="$PATH:/Users/taikishiino/Downloads/flutter/bin"
start-android:
	flutter emulators --launch Pixel_2_API_30
start-ios:
	flutter emulators --launch apple_ios_simulator
force-upgrade:
	flutter update-packages --force-upgrade
	flutter clean
	flutter upgrade
deploy-web:
	firebase deploy --only hosting:flutter-firebase-f165b
