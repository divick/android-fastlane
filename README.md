# android-fastlane

## What is this image for?

  Use this image to have required tools like JAVA, android sdk and build tools,
  ruby and fastlane preinstalled for building android apks for using fastlane.

  You can use this image for your gitlab or other CI/CD builds too.

## Requirements

  * docker version 18.09 or above

## How Tos

### Build the docker image

#### Using helper script in bin directory, for a given TARGET_SDK

```
TARGET_SDK=28 ./bin/build-image.sh
```

#### To override the [SDK_TOOLS|BUILD_TOOLS|RUBY|FASTLANE] versions
```
docker build --build-arg FASTLANE_VESION=<fastlane-version> -t <whatever-tag> -f android-<sdk-version> android-<sdk-version>
```
