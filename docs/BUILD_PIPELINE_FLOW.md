# Mobile App Build Pipeline Flow Diagram

## Overview

This document illustrates the complete CI/CD pipeline flow from GitHub to both App Store (iOS) and Google Play Store (Android).

## Pipeline Flow Diagram

```mermaid
graph TD
    Start[Developer Push to GitHub] --> Trigger{Trigger Event}
    
    Trigger -->|Push to main/develop/devops/dev| AutoBuild
    Trigger -->|Manual Workflow Dispatch| ManualBuild
    
    AutoBuild --> PlatformCheck
    ManualBuild --> PlatformCheck
    
    PlatformCheck{Platform Selection}
    PlatformCheck -->|iOS Only| iOSBranch
    PlatformCheck -->|Android Only| AndroidBranch
    PlatformCheck -->|Both| ParallelBuild
    
    ParallelBuild --> iOSBranch
    ParallelBuild --> AndroidBranch
    
    %% iOS Pipeline
    iOSBranch[iOS Build Pipeline]
    iOSBranch --> CheckoutIOS[Checkout Code]
    CheckoutIOS --> Xcode[Select Xcode]
    Xcode --> RubyIOS[Setup Ruby & Fastlane]
    RubyIOS --> FlutterIOS[Setup Flutter 3.41.6]
    FlutterIOS --> DepIOS[Install Flutter Dependencies]
    DepIOS --> CocoaPods[Install CocoaPods]
    CocoaPods --> CodeSigning[Code Signing with Match]
    
    CodeSigning --> EnvCheckIOS{Environment}
    EnvCheckIOS -->|Beta| TestFlight[Build for TestFlight]
    EnvCheckIOS -->|Release| AppStore[Build for App Store]
    
    TestFlight --> UploadTF[Upload to TestFlight]
    UploadTF --> IncrementIOS[Increment iOS Build Number]
    AppStore --> BuildOnly[Build Only]
    BuildOnly --> IncrementIOS
    
    IncrementIOS --> CommitIOS[Commit & Push Build Number]
    CommitIOS --> ArtifactsIOS[Upload iOS Artifacts<br/>.ipa & .dSYM.zip]
    ArtifactsIOS --> EndIOS[iOS Pipeline Complete]
    
    %% Android Pipeline
    AndroidBranch[Android Build Pipeline]
    AndroidBranch --> CheckoutAndroid[Checkout Code]
    CheckoutAndroid --> RubyAndroid[Setup Ruby & Fastlane]
    RubyAndroid --> FlutterAndroid[Setup Flutter 3.41.6]
    FlutterAndroid --> DepAndroid[Install Flutter Dependencies]
    DepAndroid --> Java[Setup Java 17]
    Java --> DecodeKeystore[Decode Keystore]
    DecodeKeystore --> EnvCheckAndroid{Environment}
    
    EnvCheckAndroid -->|Beta| APK[Build APK]
    EnvCheckAndroid -->|Release| AAB[Build AAB]
    
    APK --> UploadBeta[Upload to Google Play Beta]
    UploadBeta --> IncrementAndroid[Increment Android Version Code]
    AAB --> UploadRelease[Upload to Google Play Release]
    UploadRelease --> IncrementAndroid
    
    IncrementAndroid --> CommitAndroid[Commit & Push Version Code]
    CommitAndroid --> ArtifactsAndroid[Upload Android Artifacts<br/>.apk & .aab]
    ArtifactsAndroid --> EndAndroid[Android Pipeline Complete]
    
    %% Final State
    EndIOS --> Final
    EndAndroid --> Final
    Final[Pipeline Complete]
    
    %% Styling
    classDef trigger fill:#e1f5fe
    classDef ios fill:#fce4ec
    classDef android fill:#e8f5e9
    classDef signing fill:#fff3e0
    classDef deployment fill:#f3e5f5
    classDef artifact fill:#e0f2f1
    
    class Start,Trigger trigger
    class iOSBranch,CheckoutIOS,Xcode,RubyIOS,FlutterIOS,DepIOS,CocoaPods,TestFlight,BuildOnly,IncrementIOS,CommitIOS,EndIOS ios
    class AndroidBranch,CheckoutAndroid,RubyAndroid,FlutterAndroid,DepAndroid,Java,DecodeKeystore,APK,AAB,IncrementAndroid,CommitAndroid,EndAndroid android
    class CodeSigning,DecodeKeystore signing
    class UploadTF,UploadBeta,UploadRelease deployment
    class ArtifactsIOS,ArtifactsAndroid artifact
```

## Detailed Process Flow

### Step 1: Build Pipeline with Code Signing

#### iOS Build Process
1. **Code Checkout**: Fetch latest code from GitHub
2. **Environment Setup**:
   - Select Xcode
   - Setup Ruby 3.2 + Fastlane
   - Setup Flutter 3.41.6
   - Install Flutter dependencies (`flutter pub get`)
   - Install CocoaPods dependencies
3. **Code Signing**:
   - Use Fastlane Match for certificate management
   - Sync signing certificates and provisioning profiles
   - Required secrets: `MATCH_PASSWORD`, `FASTLANE_PASSWORD`, Apple API keys
4. **Build**:
   - Beta: Build and upload to TestFlight
   - Release: Build for App Store distribution

#### Android Build Process
1. **Code Checkout**: Fetch latest code from GitHub
2. **Environment Setup**:
   - Setup Ruby 3.2 + Fastlane
   - Setup Flutter 3.41.6
   - Install Flutter dependencies
   - Setup Java 17
3. **Code Signing**:
   - Decode base64-encoded keystore
   - Required secrets: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, key alias
4. **Build**:
   - Beta: Build APK for testing
   - Release: Build AAB for Play Store

### Step 2: Artifact Upload to Testing Platforms

#### iOS - TestFlight (Beta)
- Automatically uploaded via Fastlane `beta` lane
- Available for internal and external testers
- Build artifacts stored for 30 days

#### Android - Google Play Store (Beta)
- APK built for beta testing
- Uploaded via Fastlane
- Available through Play Store internal/alpha/beta tracks
- Build artifacts stored for 30 days

### Step 3: Version Synchronization

#### iOS Version Management
- Build number auto-incremented in `ios/Runner.xcodeproj/project.pbxproj`
- Git commit with `[skip ci]` to prevent pipeline loops
- Ensures unique build for every commit

#### Android Version Management
- Version code auto-incremented in `android/app/build.gradle`
- Git commit with `[skip ci]` to prevent pipeline loops
- Ensures unique build for every commit

## Triggers

### Automatic Triggers
- Push to `main` branch
- Push to `develop` branch
- Push to `devops/dev` branch
- Changes in: `lib/**`, `android/**`, `ios/**`, `pubspec.yaml`

### Manual Triggers
- GitHub Actions workflow dispatch
- Parameters:
  - Platform: `ios`, `android`, or `both`
  - Environment: `beta` or `release`

## Environments

### iOS Environments
- **APP_STORE_CONFIG**: Used for both beta and release builds
- Required variables: Apple Team ID, Fastlane user, Match Git URL, API keys

### Android Environments
- **ANDROID_BETA_CONFIG**: For beta/APK builds
- **ANDROID_RELEASE_CONFIG**: For release/AAB builds
- Required secrets: Keystore file, passwords, key alias

## Artifacts

### iOS Artifacts
- `.ipa` file (30-day retention)
- `.dSYM.zip` for crash reporting (30-day retention)

### Android Artifacts
- `.aab` file for Play Store (30-day retention)
- `.apk` file for testing (30-day retention)

## Security

### Secrets Management
- All sensitive data stored in GitHub Secrets
- Certificates managed via Fastlane Match
- Keystore stored as base64-encoded secret
- API keys for App Store Connect and Google Play

### Code Signing
- iOS: Match-based certificate management
- Android: Keystore-based signing
- Automatic sync on each build

## Component Interaction Diagram

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant MacOS as macOS Runner
    participant Ubuntu as Ubuntu Runner
    participant Fastlane as Fastlane
    participant Match as Fastlane Match
    participant Git as Git Repo
    participant ASC as App Store Connect
    participant TF as TestFlight
    participant GPC as Google Play Console
    
    %% Trigger
    Dev->>GH: Push code / Manual trigger
    GH->>GHA: Trigger workflow
    
    %% iOS Pipeline
    par iOS Pipeline
        GHA->>MacOS: Start iOS job
        MacOS->>GH: Checkout code
        MacOS->>MacOS: Setup environment (Xcode, Ruby, Flutter)
        MacOS->>Fastlane: Execute sync_signing
        Fastlane->>Match: Request certificates
        Match-->>Fastlane: Return certs & profiles
        Fastlane->>MacOS: Apply signing
        
        alt Beta Build
            MacOS->>Fastlane: Execute beta lane
            Fastlane->>ASC: Authenticate with API key
            Fastlane->>TF: Upload .ipa
            TF-->>Fastlane: Upload confirmation
        else Release Build
            MacOS->>Fastlane: Execute build_only
            Fastlane->>MacOS: Generate .ipa
        end
        
        MacOS->>MacOS: Increment build number
        MacOS->>Git: Commit build number
        MacOS->>GH: Push with [skip ci]
        MacOS->>GHA: Upload artifacts
    and Android Pipeline
        GHA->>Ubuntu: Start Android job
        Ubuntu->>GH: Checkout code
        Ubuntu->>Ubuntu: Setup environment (Ruby, Flutter, Java)
        Ubuntu->>Ubuntu: Decode keystore
        Ubuntu->>Fastlane: Execute build
        
        alt Beta Build
            Ubuntu->>Fastlane: Build APK
            Fastlane->>Ubuntu: Generate .apk
            Ubuntu->>GPC: Upload APK (via Fastlane)
            GPC-->>Ubuntu: Upload confirmation
        else Release Build
            Ubuntu->>Fastlane: Build AAB
            Fastlane->>Ubuntu: Generate .aab
            Ubuntu->>GPC: Upload AAB (via Fastlane)
            GPC-->>Ubuntu: Upload confirmation
        end
        
        Ubuntu->>Ubuntu: Increment version code
        Ubuntu->>Git: Commit version code
        Ubuntu->>GH: Push with [skip ci]
        Ubuntu->>GHA: Upload artifacts
    end
    
    %% Completion
    GHA-->>Dev: Pipeline complete notification
```

## Interaction Details

### iOS Interactions
1. **GitHub → macOS Runner**: Job initiation and code checkout
2. **Fastlane ↔ Match**: Certificate and provisioning profile retrieval
3. **Fastlane → App Store Connect**: Authentication and API communication
4. **Fastlane → TestFlight**: IPA upload for beta testing
5. **macOS Runner → Git**: Build number increment commits
6. **macOS Runner → GitHub Actions**: Artifact upload

### Android Interactions
1. **GitHub → Ubuntu Runner**: Job initiation and code checkout
2. **Ubuntu Runner → Keystore**: Local decoding and signing
3. **Fastlane → Google Play Console**: APK/AAB upload via API
4. **Ubuntu Runner → Git**: Version code increment commits
5. **Ubuntu Runner → GitHub Actions**: Artifact upload

### Key Interaction Points
- **Secrets Flow**: GitHub Secrets → Runner environment variables → Fastlane
- **Code Signing**: Match (iOS) / Keystore (Android) → Build process
- **Version Control**: Auto-increment → Git commit → GitHub push with `[skip ci]`
- **Artifact Storage**: Build outputs → GitHub Actions artifacts (30-day retention)
- **Platform Communication**: Fastlane acts as intermediary for Apple/Google APIs
