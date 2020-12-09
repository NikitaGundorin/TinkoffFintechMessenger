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
### ios build_for_testing
```
fastlane ios build_for_testing
```
Install dependencies and build app for testing
### ios run_tests_without_building
```
fastlane ios run_tests_without_building
```
Run tests on built app
### ios send_notification_to_discord
```
fastlane ios send_notification_to_discord
```
Send notification to Discord
### ios build_and_run_tests
```
fastlane ios build_and_run_tests
```
Run build_for_testing and run_tests_without_building lanes

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
