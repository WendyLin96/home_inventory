#!/usr/bin/env bash
set -e

if [ ! -d flutter ]; then
  echo "Downloading Flutter..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
  echo "Flutter cached, skip download"
fi

export PATH="$PATH:`pwd`/flutter/bin"

flutter --version
flutter pub get
flutter build web
