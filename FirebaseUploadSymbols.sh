./Pods/FirebaseCrashlytics/upload-symbols -gsp ./TonScan/GoogleService-Info.plist -p ios ./appDsyms
rm -rf ./appDsyms

./Pods/FirebaseCrashlytics/upload-symbols -gsp ./TonScan/GoogleService-Info.plist -p ios ./dSYMs
rm -rf ./dSYMs