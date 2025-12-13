#!/usr/bin/env bash
set -e

echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

flutter --version
flutter pub get
flutter build web
