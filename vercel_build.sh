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
flutter build web --dart-define=SUPABASE_URL=https://tyzoyeplrkfgokezlaqy.supabase.co --dart-define=SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5em95ZXBscmtmZ29rZXpsYXF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzNDg1MDAsImV4cCI6MjA4MDkyNDUwMH0.0uJ1DxKV4jW1R-lZLVWEDRwXjWqwTwhkGx3DSRfiC4c