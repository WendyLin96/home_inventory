#!/usr/bin/env bash
set -e

# Flutter 已經安裝好或透過 caching
flutter pub get

# build web 並帶入 Vercel 環境變數
flutter build web \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_KEY=$SUPABASE_KEY
