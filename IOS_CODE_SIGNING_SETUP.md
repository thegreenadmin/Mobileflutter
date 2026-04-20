# iOS Code Signing Setup Guide

This guide explains how to set up iOS code signing for CI/CD using Fastlane Match and App Store Connect API Key.

## Prerequisites

1. **App Store Connect API Key** (Already provided: `AuthKey_LLZ6N9KZ64.p8`)
2. **Apple Developer Account** with appropriate permissions
3. **Git repository** for storing certificates (private repo recommended)

## Step 1: Get App Store Connect API Key Information

You already have the API key file: `AuthKey_LLZ6N9KZ64.p8`

To get the required information:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys** (under Integrations section)
3. Find your key `LLZ6N9KZ64` and note:
   - **Key ID**: `LLZ6N9KZ64`
   - **Issuer ID**: Found at the top of the Keys page (format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

## Step 2: Encode the API Key to Base64

Run this command in your terminal:

```bash
base64 -i /Users/yprattipatti/Downloads/AuthKey_LLZ6N9KZ64.p8 | pbcopy
```

This will copy the base64-encoded key to your clipboard.

## Step 3: Set Up Match Certificate Repository

Fastlane Match stores your certificates and provisioning profiles in a Git repository.

### Option A: Create a New Private Repository

1. Create a new **private** repository on GitHub (e.g., `your-org/ios-certificates`)
2. Initialize it with a README
3. Copy the repository URL (e.g., `https://github.com/your-org/ios-certificates`)

### Option B: Use Existing Repository

If you already have a Match repository, use its URL.

## Step 4: Generate Match Password

Create a strong password for encrypting your certificates:

```bash
openssl rand -base64 32
```

Save this password securely - you'll need it for the GitHub secrets.

## Step 5: Configure GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add the following secrets:

### Required Secrets:

| Secret Name | Description | Example/Value |
|------------|-------------|---------------|
| `APP_STORE_CONNECT_API_KEY_KEY_ID` | Your API Key ID | `LLZ6N9KZ64` |
| `APP_STORE_CONNECT_API_KEY_ISSUER_ID` | Your Issuer ID from App Store Connect | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `APP_STORE_CONNECT_API_KEY_KEY` | Base64-encoded API key (from Step 2) | The base64 string you copied |
| `MATCH_GIT_URL` | URL of your certificates repository | `https://github.com/your-org/ios-certificates` |
| `MATCH_PASSWORD` | Password for encrypting certificates | The password from Step 4 |
| `FASTLANE_USER` | Your Apple ID email | `your-email@example.com` |

### Optional Secret (for private Match repo):

| Secret Name | Description | How to Generate |
|------------|-------------|-----------------|
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64-encoded GitHub credentials | `echo -n "username:personal_access_token" \| base64` |

**To create a GitHub Personal Access Token:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope
3. Encode it: `echo -n "your-github-username:ghp_yourtoken" | base64`

## Step 6: Update Appfile with Your Information

Edit `ios/fastlane/Appfile`:

```ruby
app_identifier("com.app.thegreenmall") # Already set
apple_id("your-apple-id@example.com") # Replace with your Apple ID
team_id("YOUR_TEAM_ID") # Replace with your Team ID
```

**To find your Team ID:**
1. Go to [Apple Developer Account](https://developer.apple.com/account)
2. Navigate to **Membership** section
3. Copy the **Team ID**

## Step 7: Update Matchfile

Edit `ios/fastlane/Matchfile` and replace:

```ruby
git_url(ENV["MATCH_GIT_URL"] || "https://github.com/YOUR_ORG/certificates")
```

With your actual repository URL if you want a default.

## Step 8: Initialize Match (First Time Only)

Run this locally to set up your certificates:

```bash
cd ios
bundle exec fastlane match appstore
bundle exec fastlane match development
bundle exec fastlane match adhoc
```

This will:
- Create certificates and provisioning profiles
- Store them in your Match repository
- Install them on your local machine

## Step 9: Test the Setup

### Local Test:
```bash
cd ios
export APP_STORE_CONNECT_API_KEY_KEY_ID="LLZ6N9KZ64"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="your-issuer-id"
export APP_STORE_CONNECT_API_KEY_KEY="your-base64-key"
bundle exec fastlane beta
```

### CI Test:
Push your changes and trigger the GitHub Actions workflow.

## Troubleshooting

### Issue: "Could not find certificate"
- Ensure Match has been initialized (Step 8)
- Verify `MATCH_GIT_URL` is correct
- Check `MATCH_PASSWORD` is correct

### Issue: "Invalid API Key"
- Verify the Key ID and Issuer ID are correct
- Ensure the base64-encoded key is complete (no line breaks)
- Check the API key has not been revoked in App Store Connect

### Issue: "Authentication failed"
- For private Match repos, ensure `MATCH_GIT_BASIC_AUTHORIZATION` is set
- Verify the GitHub personal access token has `repo` scope

### Issue: "Provisioning profile doesn't match"
- Run `bundle exec fastlane match nuke distribution` (WARNING: deletes all certificates)
- Then re-run `bundle exec fastlane match appstore`

## Security Best Practices

1. ✅ **Never commit** the `.p8` file to your repository
2. ✅ **Use a private repository** for Match certificates
3. ✅ **Rotate API keys** periodically
4. ✅ **Limit API key permissions** to only what's needed
5. ✅ **Use strong passwords** for Match encryption
6. ✅ **Enable 2FA** on your Apple Developer account

## Available Fastlane Lanes

After setup, you can use these lanes:

- `bundle exec fastlane beta` - Build and upload to TestFlight
- `bundle exec fastlane release` - Build and upload to App Store
- `bundle exec fastlane build_only` - Build without uploading
- `bundle exec fastlane sync_signing` - Sync certificates from Match

## References

- [Fastlane Match Documentation](https://docs.fastlane.tools/actions/match/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Fastlane CI Documentation](https://docs.fastlane.tools/best-practices/continuous-integration/)
