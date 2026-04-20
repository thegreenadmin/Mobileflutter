# Fastlane Setup Guide

This guide explains how to set up and use Fastlane for deploying the The Green Mall app to Apple App Store and Google Play Store.

## Prerequisites

### For iOS
- Apple Developer Account
- Xcode installed
- Ruby installed (macOS comes with Ruby pre-installed)

### For Android
- Google Play Console account
- Service account JSON key from Google Play Console
- Ruby installed

## Installation

1. Install Bundler (if not already installed):
```bash
gem install bundler
```

2. Install Fastlane dependencies:
```bash
bundle install
```

## Configuration

### iOS Configuration

1. Update `ios/fastlane/Appfile` with your Apple Developer credentials:
```ruby
app_identifier("com.app.thegreenmall")
apple_id("your-apple-id@email.com")
team_id("YOUR_TEAM_ID")  # Find in Apple Developer Portal
```

2. Set up Fastlane Match for code signing:
```bash
cd ios
fastlane match init
```

Choose "Git storage" and provide your Git repository URL for storing certificates.

3. Generate certificates and provisioning profiles:
```bash
fastlane match development
fastlane match adhoc
fastlane match appstore
```

### Android Configuration

1. Create a service account in Google Play Console:
   - Go to Settings > API access
   - Click "Create Service Account"
   - This will open the Google Cloud Console
   - Create a service account and download the JSON key

2. Place the JSON key file at `android/fastlane/service-account.json`

3. Grant permissions to the service account in Google Play Console:
   - Go to Settings > API access
   - Select your service account
   - Grant "Admin" or "Release Manager" permissions

4. Update `android/fastlane/Appfile` if needed:
```ruby
package_name("com.app.thegreenmall")
json_key_file("./fastlane/service-account.json")
```

## Available Lanes

### iOS Lanes

Run from the `ios` directory:

- `fastlane beta` - Build and upload to TestFlight
- `fastlane release` - Build and submit to App Store (for review)
- `fastlane dev` - Build development version
- `fastlane adhoc` - Build ad-hoc version for testing
- `fastlane register_devices` - Register new devices for ad-hoc testing
- `fastlane sync_signing` - Sync signing certificates from Match
- `fastlane test` - Run unit tests
- `fastlane screenshots` - Capture screenshots for App Store
- `fastlane download_dsyms` - Download dSYM files and upload to Crashlytics

### Android Lanes

Run from the `android` directory:

- `fastlane debug` - Build debug APK
- `fastlane release` - Build release APK
- `fastlane beta` - Build and upload to Google Play Internal Testing
- `fastlane deploy` - Deploy to Google Play Production
- `fastlane alpha` - Deploy to Google Play Alpha track
- `fastlane beta_track` - Deploy to Google Play Beta track
- `fastlane upload_metadata` - Upload metadata to Google Play Store
- `fastlane test` - Run unit tests
- `fastlane build_apk` - Build APK for distribution
- `fastlane build_bundle` - Build App Bundle for distribution
- `fastlane screenshots` - Upload screenshots to Google Play Store

## Usage Examples

### Deploy iOS Beta to TestFlight
```bash
cd ios
fastlane beta
```

### Deploy iOS to App Store
```bash
cd ios
fastlane release
```

### Deploy Android Beta to Internal Testing
```bash
cd android
fastlane beta
```

### Deploy Android to Production
```bash
cd android
fastlane deploy
```

## Device Registration for iOS Ad-Hoc Testing

1. Get the UDID of test devices (use Xcode or online tools)
2. Add devices to `ios/fastlane/devices.txt`:
```
12345678-1234-1234-1234-123456789012, iPhone 15 Pro
87654321-4321-4321-4321-210987654321, iPad Pro
```

3. Register devices:
```bash
cd ios
fastlane register_devices
```

## CI/CD Integration

The existing GitHub Actions workflow can be extended to use Fastlane. Add these steps to your workflow:

### iOS Build with Fastlane
```yaml
- name: Install Fastlane
  run: |
    cd ios
    bundle install

- name: Build iOS with Fastlane
  run: |
    cd ios
    fastlane beta
```

### Android Build with Fastlane
```yaml
- name: Install Fastlane
  run: |
    cd android
    bundle install

- name: Build Android with Fastlane
  run: |
    cd android
    fastlane beta
```

## Environment Variables

For CI/CD, set these environment variables:

### iOS
- `FASTLANE_APPLE_ID` - Your Apple ID email
- `FASTLANE_TEAM_ID` - Your Apple Developer Team ID
- `MATCH_PASSWORD` - Password for encrypting Match certificates
- `MATCH_GIT_URL` - Git repository URL for Match storage

### Android
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Base64 encoded service account JSON

## Troubleshooting

### iOS Issues

**Code signing errors:**
- Ensure you've run `fastlane match` for the appropriate environment
- Check that your team ID is correct in Appfile
- Verify your Apple Developer account is active

**Xcode version mismatch:**
- Update Xcode to the latest version
- Run `sudo xcode-select --switch /Applications/Xcode.app`

### Android Issues

**Authentication errors:**
- Verify service account JSON is correctly placed
- Ensure service account has proper permissions in Google Play Console
- Check that the package name matches your Google Play app

**Build errors:**
- Ensure keystore properties are set in `android/key.properties`
- Verify keystore file exists and is accessible

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Fastlane Match Guide](https://docs.fastlane.tools/actions/match/)
- [Google Play Console API](https://developers.google.com/android-publisher)
- [Apple App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
