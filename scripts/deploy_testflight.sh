#!/bin/bash

# TestFlight Deployment Script for Vela
# Make sure you have Xcode and Apple Developer account set up

set -e

echo "🚀 Starting TestFlight deployment for Vela..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found. Please run this script from the project root.${NC}"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Error: Xcode is not installed or not in PATH${NC}"
    exit 1
fi

# Check if fastlane is installed
if ! command -v fastlane &> /dev/null; then
    echo -e "${YELLOW}Warning: fastlane not found. Installing via gem...${NC}"
    sudo gem install fastlane
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Build for iOS
echo "📱 Building iOS app..."
flutter build ios --release --no-codesign

# Navigate to iOS directory
cd ios

# Archive the app
echo "📦 Archiving app..."
xcodebuild -workspace Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           -archivePath build/Runner.xcarchive \
           clean archive

# Export the archive
echo "📤 Exporting archive..."
xcodebuild -exportArchive \
           -archivePath build/Runner.xcarchive \
           -exportPath build/ios \
           -exportOptionsPlist exportOptions.plist

# Upload to App Store Connect
echo "☁️ Uploading to App Store Connect..."
xcrun altool --upload-app \
             --type ios \
             --file "build/ios/Runner.ipa" \
             --username "$APPLE_ID" \
             --password "$APPLE_APP_SPECIFIC_PASSWORD" \
             --verbose

echo -e "${GREEN}✅ Upload completed successfully!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Go to App Store Connect (https://appstoreconnect.apple.com)"
echo "2. Navigate to your app > TestFlight"
echo "3. Wait for processing to complete (usually 5-15 minutes)"
echo "4. Add internal testers or create external testing groups"
echo "5. Submit for Beta App Review if needed"

cd .. 