# Flutter CI/CD Pipeline Solution for iOS and Android

## Overview
Complete solution for building and deploying Flutter apps to both iOS and Android platforms using AWS services.

## Architecture

```
┌─────────────────┐
│   GitHub Repo   │
│  (Source Code)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GitHub Actions │
│  (Orchestrator) │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ Android │ │   iOS   │
│ Build   │ │  Build  │
└────┬────┘ └────┬────┘
     │           │
     └────┬──────┘
          ▼
   ┌─────────────┐
   │ Self-Hosted │
   │  Mac Runner │
   │ (from EC2   │
   │  Image)    │
   └──────┬──────┘
          │
          ▼
   ┌─────────────┐
   │  Amazon S3  │
   │ (Artifacts) │
   └──────┬──────┘
          │
     ┌────┴────┐
     │         │
     ▼         ▼
┌─────────┐ ┌─────────┐
│ Device  │ │ App     │
│ Farm    │ │ Stores  │
└─────────┘ └─────────┘
```

## Prerequisites

### AWS Account Setup
1. AWS account with appropriate permissions
2. Service limit increase for EC2 Mac instances (for both iOS and Android builds)
3. IAM roles with permissions for:
   - EC2 (instance management)
   - S3 (artifact storage)
   - Secrets Manager (for credentials)
   - Device Farm (testing)
   - EC2 Image Builder
   - GitHub Actions OIDC provider

### GitHub Setup
1. GitHub repository with source code
2. GitHub Actions enabled
3. Self-hosted runner configuration
4. OIDC provider setup for AWS authentication
5. GitHub Secrets for AWS credentials (or OIDC)

### Local Development Setup
```bash
# Install Flutter
brew install --cask flutter

# Install Android Studio (for Android builds)
brew install --cask android-studio

# Install CocoaPods (for iOS builds)
brew install cocoapods

# Install Java
brew install --cask temurin

# Configure Android SDK
flutter config --android-sdk /opt/homebrew/share/android-commandlinetools
flutter doctor --android-licenses
```

## Phase 1: Local Build Environment

### Android Build
```bash
# Install dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK (requires signing configuration)
flutter build apk --release
```

### iOS Build
```bash
# Install Xcode from App Store
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Install iOS pods
cd ios
pod install
cd ..

# Build for simulator
flutter build ios --simulator

# Build for device (requires code signing)
flutter build ios
```

## Phase 2: AWS Infrastructure Setup

### Step 1: Create VPC and Network
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnets
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24 --availability-zone us-east-1b
```

### Step 2: Request EC2 Mac Instance Limit
1. Go to AWS Support Center
2. Create case for service limit increase
3. Request: EC2 Mac instances in your region
4. Specify instance type: mac2.metal (M1) or mac2.m2 (M2 Ultra)
5. Wait for approval (1-2 business days)

### Step 3: Create Dedicated Host for Mac
```bash
# Allocate dedicated host
aws ec2 allocate-hosts \
  --instance-type mac2.metal \
  --auto-placement on \
  --host-recovery on \
  --quantity 1
```

### Step 4: Create EC2 Image Builder Component for Mac

#### Unified Flutter Build Environment Component (Mac)
```json
{
  "name": "flutter-unified-build-mac",
  "description": "Flutter build environment for both Android and iOS on Mac",
  "schemaVersion": "2.0",
  "phases": [
    {
      "name": "build",
      "steps": [
        {
          "name": "InstallFlutter",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter",
              "echo 'export PATH=/opt/flutter/bin:$PATH' >> /etc/profile",
              "export PATH='/opt/flutter/bin:/usr/local/bin:$PATH'",
              "flutter --version",
              "flutter precache --ios --android"
            ]
          }
        },
        {
          "name": "InstallXcodeCLI",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "xcode-select --switch /Applications/Xcode.app/Contents/Developer",
              "xcodebuild -runFirstLaunch"
            ]
          }
        },
        {
          "name": "InstallCocoaPods",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "sudo gem install cocoapods",
              "pod setup"
            ]
          }
        },
        {
          "name": "InstallJava",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "brew install --cask temurin",
              "java -version"
            ]
          }
        },
        {
          "name": "InstallAndroidSDK",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "brew install --cask android-commandlinetools",
              "export ANDROID_SDK_ROOT=/opt/homebrew/share/android-commandlinetools",
              "$ANDROID_SDK_ROOT/bin/sdkmanager --update",
              "$ANDROID_SDK_ROOT/bin/sdkmanager 'platform-tools' 'platforms;android-36' 'build-tools;36.0.0'",
              "flutter doctor --android-licenses"
            ]
          }
        },
        {
          "name": "ConfigureFlutter",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "flutter config --android-sdk /opt/homebrew/share/android-commandlinetools",
              "flutter doctor -v"
            ]
          }
        },
        {
          "name": "InstallBuildTools",
          "action": "ExecuteBash",
          "inputs": {
            "commands": [
              "brew install git",
              "brew install awscli"
            ]
          }
        }
      ]
    }
  ]
}
```

### Step 5: Create Image Builder Pipeline

#### Unified Mac Build Image Pipeline
```bash
# Create infrastructure configuration for Mac
aws imagebuilder create-infrastructure-configuration \
  --name flutter-mac-infra \
  --description "Infrastructure configuration for Mac builds" \
  --instance-types mac2.metal \
  --instance-profile-name <ec2-instance-profile> \
  --key-pair-name <your-key-pair> \
  --subnet-id <your-subnet-id> \
  --security-group-ids <your-security-group-id> \
  --terminate-instance-on-failure

# Create distribution configuration
aws imagebuilder create-distribution-configuration \
  --name flutter-mac-dist \
  --description "Distribution configuration for Mac builds" \
  --distribution-configurations '[
    {
      "AmiDistributionConfiguration": {
        "Name": "flutter-mac-build-{{ imagebuilder:buildDate }}",
        "Description": "Flutter build environment for iOS and Android"
      }
    }
  ]'

# Create image recipe
aws imagebuilder create-image-recipe \
  --name flutter-mac-recipe \
  --description "Flutter build recipe for Mac" \
  --semantic-version 1.0.0 \
  --components file://component.json

# Create image pipeline
aws imagebuilder create-image-pipeline \
  --name flutter-mac-pipeline \
  --description "Unified Flutter build pipeline for iOS and Android on Mac" \
  --image-recipe-arn <mac-recipe-arn> \
  --infrastructure-configuration-arn <mac-infra-config-arn> \
  --distribution-configuration-arn <mac-dist-config-arn>
```

## Phase 3: GitHub Actions Setup

### Step 1: Create Self-Hosted Mac Runner

#### Option A: Use EC2 Image Builder AMI
```bash
# Launch Mac instance from Image Builder AMI
aws ec2 run-instances \
  --image-id <your-mac-ami-from-image-builder> \
  --instance-type mac2.metal \
  --key-pair <your-key-pair> \
  --subnet-id <your-subnet> \
  --security-group-ids <your-security-group> \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=github-mac-runner}]'

# Get instance public IP
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=github-mac-runner" --query 'Reservations[0].Instances[0].InstanceId' --output text)
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# SSH into instance and configure GitHub runner
ssh -i <your-key.pem> ec2-user@$PUBLIC_IP
```

#### Option B: Configure Runner on Instance
```bash
# On the Mac instance
mkdir actions-runner && cd actions-runner
curl -o actions-runner-osx-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-arm64-2.311.0.tar.gz
tar xzf ./actions-runner-osx-arm64-2.311.0.tar.gz
./config.sh --url https://github.com/your-org/your-repo --token <runner-token>
./svc.sh install
./svc.sh start
```

### Step 2: Configure GitHub OIDC with AWS

#### Create IAM OIDC Provider
```bash
# Get GitHub OIDC provider URL
GITHUB_OIDC_PROVIDER="oidc.github.com/your-org"

# Create OIDC provider
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831b378b440f
```

#### Create IAM Role for GitHub Actions
```bash
# Create trust policy
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:*"
        }
      }
    }
  ]
}
EOF

# Create IAM role
aws iam create-role \
  --role-name github-actions-role \
  --assume-role-policy-document file://trust-policy.json

# Attach permissions
aws iam attach-role-policy \
  --role-name github-actions-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

aws iam attach-role-policy \
  --role-name github-actions-role \
  --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWriteAccess
```

### Step 3: Create GitHub Actions Workflows

#### Android Build Workflow
```yaml
# .github/workflows/android-build.yml
name: Build Android

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  build-android:
    runs-on: [self-hosted, macos]
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-actions-role
          aws-region: us-east-1

      - name: Install dependencies
        run: |
          flutter pub get

      - name: Build Android APK
        run: |
          flutter build apk --release

      - name: Upload to S3
        run: |
          aws s3 cp build/app/outputs/flutter-apk/app-release.apk s3://flutter-builds/android/

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

#### iOS Build Workflow
```yaml
# .github/workflows/ios-build.yml
name: Build iOS

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  build-ios:
    runs-on: [self-hosted, macos]
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-actions-role
          aws-region: us-east-1

      - name: Install dependencies
        run: |
          flutter pub get
          cd ios && pod install && cd ..

      - name: Build iOS app
        run: |
          flutter build ios --simulator

      - name: Upload to S3
        run: |
          aws s3 cp build/ios/iphonesimulator/Runner.app s3://flutter-builds/ios/

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: ios-app
          path: build/ios/iphonesimulator/Runner.app
```

#### Unified Build Workflow (Both Platforms)
```yaml
# .github/workflows/build.yml
name: Build Flutter App

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  build-android:
    runs-on: [self-hosted, macos]
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-actions-role
          aws-region: us-east-1

      - name: Build Android APK
        run: |
          flutter pub get
          flutter build apk --release
          aws s3 cp build/app/outputs/flutter-apk/app-release.apk s3://flutter-builds/android/

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: [self-hosted, macos]
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-actions-role
          aws-region: us-east-1

      - name: Build iOS app
        run: |
          flutter pub get
          cd ios && pod install && cd ..
          flutter build ios --simulator
          aws s3 cp build/ios/iphonesimulator/Runner.app s3://flutter-builds/ios/

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: ios-app
          path: build/ios/iphonesimulator/Runner.app
```

### Step 4: Auto-Scaling Self-Hosted Runners

#### Use AWS Auto Scaling with Mac Instances
```bash
# Create launch template
aws ec2 create-launch-template \
  --name github-mac-runner-template \
  --image-id <your-mac-ami-from-image-builder> \
  --instance-type mac2.metal \
  --key-name <your-key-pair> \
  --user-data file://user-data.sh

# User data script (user-data.sh)
cat > user-data.sh << 'EOF'
#!/bin/bash
mkdir actions-runner && cd actions-runner
curl -o actions-runner-osx-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-arm64-2.311.0.tar.gz
tar xzf ./actions-runner-osx-arm64-2.311.0.tar.gz
./config.sh --url https://github.com/your-org/your-repo --token <runner-token>
./svc.sh install
./svc.sh start
EOF

# Create auto scaling group
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name github-mac-runners \
  --launch-template LaunchTemplateId=<launch-template-id> \
  --min-size 0 \
  --max-size 3 \
  --desired-capacity 1 \
  --vpc-zone-identifier <subnet-id-1>,<subnet-id-2>
```

## Phase 4: Code Signing Management

### Store Credentials in Secrets Manager
```bash
# Android keystore
aws secretsmanager create-secret \
  --name flutter/android-keystore \
  --secret-string file://keystore.json

# iOS certificates
aws secretsmanager create-secret \
  --name flutter/ios-certificates \
  --secret-string file://ios-certs.json
```

### Use in GitHub Actions
```yaml
# Add to your workflow
- name: Retrieve Android keystore
  run: |
    export ANDROID_KEYSTORE=$(aws secretsmanager get-secret-value --secret-id flutter/android-keystore --query SecretString --output text)
    echo $ANDROID_KEYSTORE > android/keystore.jks

- name: Retrieve iOS certificates
  run: |
    export IOS_CERTS=$(aws secretsmanager get-secret-value --secret-id flutter/ios-certificates --query SecretString --output text)
    echo $IOS_CERTS > ios/certs.p12
```

## Phase 5: Testing Integration

### AWS Device Farm Setup
```bash
# Create Device Farm project
aws devicefarm create-project --name flutter-testing

# Upload test artifacts
aws devicefarm upload \
  --project-arn <project-arn> \
  --name flutter-tests \
  --type APPIUM_PYTHON_TEST_PACKAGE \
  --file appium-tests.zip

# Schedule test run
aws devicefarm schedule-run \
  --project-arn <project-arn> \
  --app-arn <app-arn> \
  --device-pool-arn <device-pool-arn> \
  --name flutter-test-run
```

## Phase 6: Deployment

### Android Deployment to Google Play
```yaml
# Add to workflow after build step
- name: Deploy to Google Play
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
    packageName: com.yourcompany.yourapp
    releaseFiles: build/app/outputs/flutter-apk/app-release.apk
    track: internal
    status: completed
```

### iOS Deployment to TestFlight
```yaml
# Add to workflow after build step
- name: Deploy to TestFlight
  uses: apple-actions/upload-testflight-build@v1
  with:
    app-id: ${{ secrets.APPLE_APP_ID }}
    api-key-id: ${{ secrets.APPLE_API_KEY_ID }}
    api-key-issuer-id: ${{ secrets.APPLE_API_KEY_ISSUER_ID }}
    file-path: build/ios/ipa/yourapp.ipa
```

### Alternative: Deploy via AWS Lambda
```yaml
- name: Trigger Lambda deployment
  run: |
    aws lambda invoke \
      --function-name deploy-to-play-store \
      --payload '{"apk_path": "s3://flutter-builds/android/app-release.apk"}' \
      response.json
```

## Cost Optimization

### 1. Self-Hosted Runner Management
- Use auto-scaling to scale runners based on GitHub Actions queue
- Scale to 0 when no builds are running
- Use spot instances for runners (up to 70% savings)
- Schedule builds during off-peak hours for better spot availability

### 2. Build Scheduling
- Batch Android and iOS builds together on the same runner
- Sequential builds to maximize runner utilization
- Use workflow concurrency to limit parallel builds
- Schedule builds during business hours to reuse runners

### 3. Caching
- Use GitHub Actions cache for Flutter dependencies
- Cache CocoaPods and Gradle dependencies
- Use EC2 Image Builder to pre-configure AMIs with all dependencies
- Cache build artifacts in S3 for faster deployments

### 4. S3 Lifecycle Policies
- Move old builds to Glacier after 90 days
- Delete builds older than 1 year
- Use intelligent tiering for cost optimization

### 5. GitHub Actions Cost Comparison
- **GitHub-hosted runners**: Included in GitHub plans (limited minutes)
- **Self-hosted Mac runners**: ~$1.08/hour (mac2.metal)
- **Spot instances**: Up to 70% savings on Mac instances
- **Savings**: Self-hosted runners can be cheaper for high-volume builds
- **Trade-off**: Requires infrastructure management

## Security Best Practices

### 1. IAM Roles
- Least privilege principle
- Separate roles for build, deploy, and test stages

### 2. Secrets Management
- Never hardcode credentials
- Rotate certificates regularly
- Use KMS encryption for secrets

### 3. Network Security
- Use VPC endpoints for AWS services
- Restrict security groups to necessary ports
- Enable VPC Flow Logs

### 4. Compliance
- Enable CloudTrail for audit logging
- Use AWS Config for compliance monitoring
- Implement guardrails with AWS Control Tower

## Monitoring and Alerting

### GitHub Actions Metrics
- Build success/failure rates
- Build duration
- Runner utilization
- Workflow queue time

### CloudWatch Metrics for AWS Resources
- S3 storage costs
- EC2 instance usage
- Lambda invocation counts
- Secrets Manager access

### CloudWatch Alarms
- Build failure rate > 10%
- Build duration > 30 minutes
- Monthly cost > budget threshold
- Runner instance not responding

### GitHub Actions Monitoring
- Use GitHub Actions built-in monitoring
- Enable workflow run notifications
- Monitor runner status via GitHub API
- Use third-party tools like Datadog or New Relic

### Dashboard Integration
```yaml
# Add to workflow to send metrics to CloudWatch
- name: Send metrics to CloudWatch
  uses: jakejarvis/cloudwatch-action@master
  with:
    namespace: GitHubActions
    metric-name: BuildDuration
    metric-value: ${{ job.duration }}
    metric-dimensions: '{"Platform": "android"}'
```

## Troubleshooting

### Common Issues

#### iOS Build Fails - No Space
```bash
# Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean Flutter cache
flutter clean
```

#### Android Build Fails - License Issues
```bash
flutter doctor --android-licenses
```

#### Mac Instance Not Available
- Check service limits
- Request limit increase
- Consider using spot instances

#### Code Signing Errors
- Verify certificates in Secrets Manager
- Check certificate expiration
- Ensure proper IAM permissions

## Maintenance

### Regular Tasks
- Weekly: Review build logs for errors
- Monthly: Rotate certificates
- Quarterly: Review and optimize costs
- Annually: Update Flutter SDK and dependencies

### Update Pipeline
```bash
# Update buildspec
aws codebuild update-project --name flutter-android-build --source buildspec-v2.yml

# Update pipeline
aws codepipeline update-pipeline --pipeline file://pipeline-config-v2.json
```

## Appendix

### Useful Commands
```bash
# Flutter
flutter doctor
flutter clean
flutter pub get
flutter build apk
flutter build ios

# GitHub Actions
gh workflow list
gh workflow run build.yml
gh run list
gh run view

# AWS
aws ec2 describe-instances
aws imagebuilder list-image-pipelines
aws s3 ls s3://flutter-builds/
aws secretsmanager list-secrets

# Local
brew install --cask flutter
brew install cocoapods
brew install gh
```

### GitHub CLI Commands
```bash
# Install GitHub CLI
brew install gh

# Authenticate with GitHub
gh auth login

# List workflows
gh workflow list

# Trigger workflow manually
gh workflow run build.yml

# View workflow runs
gh run list

# View specific run
gh run view <run-id>

# View runner status
gh api /orgs/your-org/actions/runners
```

### References
- [Flutter Build Documentation](https://flutter.dev/docs/deployment)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [AWS EC2 Mac Instances](https://aws.amazon.com/ec2/instance-types/mac/)
- [AWS EC2 Image Builder](https://aws.amazon.com/image-builder/)
- [AWS Device Farm](https://aws.amazon.com/device-farm/)
- [GitHub Actions OIDC with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
