#!/bin/bash

# iOS Certificate Creation Script
# This script creates iOS certificates and provisioning profiles using Fastlane Match
# Run this script from the project root directory

set -e

echo "=========================================="
echo "iOS Certificate Creation Script"
echo "=========================================="
echo ""

# Check if we're in the project root
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: Please run this script from the project root directory"
    exit 1
fi

# Use env vars if set, otherwise prompt interactively
if [ -z "$APPLE_ID" ]; then
    read -p "Enter your Apple ID (email): " APPLE_ID
fi

if [ -z "$APPLE_PASSWORD" ]; then
    read -sp "Enter your Apple ID password: " APPLE_PASSWORD
    echo ""
fi

if [ -z "$TEAM_ID" ]; then
    read -p "Enter your Apple Team ID: " TEAM_ID
fi

if [ -z "$GIT_URL" ]; then
    read -p "Enter Match Git URL (default: https://github.com/thegreenadmin/mobileapp-certificates.git): " GIT_URL
fi
GIT_URL=${GIT_URL:-"https://github.com/thegreenadmin/mobileapp-certificates.git"}

if [ -z "$MATCH_PASS" ]; then
    read -p "Enter Match password for encryption: " MATCH_PASS
fi

echo ""
echo "=========================================="
echo "Configuration Summary:"
echo "Apple ID: $APPLE_ID"
echo "Team ID: $TEAM_ID"
echo "Git URL: $GIT_URL"
echo "=========================================="
echo ""

if [ -n "$AUTO_CONFIRM" ]; then
    CONFIRM="y"
else
    read -p "Do you want to proceed? (y/n): " CONFIRM
fi
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Creating certificates..."
echo ""

# Set environment variables for Fastlane
export FASTLANE_USER="$APPLE_ID"
export FASTLANE_PASSWORD="$APPLE_PASSWORD"
export APPLE_TEAM_ID="$TEAM_ID"
export MATCH_PASSWORD="$MATCH_PASS"
export MATCH_GIT_URL="$GIT_URL"
export MATCH_GIT_BASIC_AUTHORIZATION="${MATCH_GIT_BASIC_AUTHORIZATION:-""}"

# Ensure correct Ruby version (3.2+) is available
echo "Checking Ruby version..."
RUBY_VER=$(ruby -e 'puts RUBY_VERSION' 2>/dev/null)
echo "Current Ruby: $RUBY_VER"

if ! ruby -e 'exit(RUBY_VERSION >= "3.2.0" ? 0 : 1)' 2>/dev/null; then
    echo "Ruby 3.2+ required. Attempting to install via rbenv..."
    
    # Install rbenv if not available
    if ! command -v rbenv &>/dev/null; then
        if command -v brew &>/dev/null; then
            echo "Installing rbenv via Homebrew..."
            brew install rbenv ruby-build
            export PATH="$HOME/.rbenv/bin:$PATH"
            eval "$(rbenv init -)"
        else
            echo "ERROR: Please install rbenv or Homebrew first"
            echo "  Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    else
        export PATH="$HOME/.rbenv/bin:$PATH"
        eval "$(rbenv init -)"
    fi

    # Install Ruby 3.2 via rbenv
    echo "Installing Ruby 3.2.0 via rbenv..."
    rbenv install 3.2.0 --skip-existing
    rbenv local 3.2.0
    export PATH="$HOME/.rbenv/shims:$PATH"
fi

# Install correct bundler version
echo "Installing bundler 4.0.8..."
gem install bundler:4.0.8 --no-document

# Navigate to iOS directory
cd ios

# Install dependencies
echo "Installing Fastlane dependencies..."
bundle install

# Create App Store certificates and provisioning profiles
echo "Creating App Store certificates..."
bundle exec fastlane match appstore \
    --git_url "$GIT_URL" \
    --app_identifier "com.thegreenmall" \
    --username "$APPLE_ID" \
    --team_id "$TEAM_ID"

# Ask if they want development certificates too
echo ""
read -p "Do you also want to create Development certificates? (y/n): " CREATE_DEV
if [ "$CREATE_DEV" == "y" ] || [ "$CREATE_DEV" == "Y" ]; then
    echo "Creating Development certificates..."
    bundle exec fastlane match development \
        --git_url "$GIT_URL" \
        --app_identifier "com.thegreenmall" \
        --username "$APPLE_ID" \
        --team_id "$TEAM_ID"
fi

cd ..

echo ""
echo "=========================================="
echo "Certificate creation completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Certificates have been stored in: $GIT_URL"
echo "2. Add MATCH_PASSWORD to your GitHub repository secrets"
echo "3. Add MATCH_GIT_URL to your GitHub repository variables"
echo "4. Add FASTLANE_USER to your GitHub repository variables"
echo "5. Add FASTLANE_PASSWORD to your GitHub repository secrets"
echo "6. Add APPLE_TEAM_ID to your GitHub repository variables (if not already set)"
echo ""
