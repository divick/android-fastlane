#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT=$DIR/..

cd $PROJECT_ROOT

_usage="
Usage: TARGET_SDK=[27|28|29|30|31|32|33|34] ./bin/build-image.sh
"
if [[ ! -v TARGET_SDK ]]; then
  echo "Please specify TARGET_SDK to build.";
  echo "$_usage";
  exit;
elif [[ -z "${TARGET_SDK}" ]]; then
  echo "TARGET_SDK cannot be empty. Please specify TARGET_SDK to build";
  echo "$_usage";
  exit;
else
    target=${TARGET_SDK}
fi
docker build --build-arg TARGET_SDK=${TARGET_SDK} -t gorapidio/android-fastlane:android-${TARGET_SDK} -f android-${target}/Dockerfile android-${target}/
