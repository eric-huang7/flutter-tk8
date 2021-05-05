fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios development
```
fastlane ios development
```
Upload a new Development build to firebase
### ios staging
```
fastlane ios staging
```
Upload a new Staging build to firebase
### ios testflight_app
```
fastlane ios testflight_app
```
Upload new build to testfligh
### ios generate_push_debug_app
```
fastlane ios generate_push_debug_app
```
Update debug push notification certificate
### ios generate_push_appcenter_apps
```
fastlane ios generate_push_appcenter_apps
```
Update push notification certificates for apps in AppCenter

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
