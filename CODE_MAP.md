# Flutter Project Code Map

## Project Overview
**Project Name:** TheGreenMall
**Framework:** Flutter
**Platforms:** iOS, Android
**Architecture:** MVC with GetX state management

## Directory Structure

```
Mobileflutter/
├── .github/
│   └── workflows/
│       └── build.yml                    # GitHub Actions CI/CD workflow
├── android/                             # Android native code
│   ├── app/
│   │   ├── build.gradle                # Android app build configuration
│   │   ├── google-services.json         # Firebase/Google services config
│   │   └── src/
│   ├── build.gradle                     # Project-level build configuration
│   ├── gradle/                          # Gradle wrapper
│   ├── gradle.properties               # Gradle properties
│   ├── gradlew                          # Gradle wrapper script
│   ├── gradlew.bat                      # Gradle wrapper script (Windows)
│   ├── local.properties                 # Local SDK path
│   └── settings.gradle                  # Gradle settings
├── ios/                                 # iOS native code (113 items)
├── lib/                                 # Flutter application code
│   ├── authentication/                  # Authentication module
│   │   ├── login/                       # Login functionality
│   │   │   ├── controller/              # Login controller (GetX)
│   │   │   └── view/                    # Login screens
│   │   ├── otpverification/             # OTP verification
│   │   │   ├── controller/
│   │   │   └── view/
│   │   └── signup/                      # User registration
│   │       ├── controller/
│   │       └── view/
│   ├── bottomNavigation/                # Bottom navigation bar
│   │   ├── bottom_nav_controller.dart   # Navigation controller
│   │   └── bottom_nav_screen.dart       # Navigation screen
│   ├── dashboard/                       # Main dashboard module
│   │   ├── common_models/               # Shared data models
│   │   │   ├── common_models.dart        # Base models
│   │   │   ├── image_model.dart         # Image model
│   │   │   ├── product_categories_model.dart  # Product categories
│   │   │   ├── quantity_type_model.dart # Quantity types
│   │   │   └── store_addresses_model.dart # Store addresses
│   │   ├── home/                        # Home screen
│   │   │   ├── controller/              # Home controller
│   │   │   ├── model/                   # Home data models
│   │   │   └── view/                    # Home screens
│   │   ├── more/                        # More/settings screen
│   │   │   ├── controller/
│   │   │   └── view/
│   │   ├── offers/                      # Offers/promotions
│   │   │   ├── controller/
│   │   │   ├── model/
│   │   │   └── view/
│   │   ├── orders/                      # Order management
│   │   │   ├── controller/
│   │   │   ├── model/
│   │   │   └── view/
│   │   └── wallet/                      # Wallet functionality
│   │       ├── controller/
│   │       ├── model/
│   │       └── view/
│   ├── navigation/                      # Navigation logic
│   │   └── router.dart                  # App routing configuration
│   ├── provider/                        # State management & API
│   │   ├── err_response_model.dart      # Error response model
│   │   ├── logging.dart                 # Logging utilities
│   │   ├── network_service.dart         # Network service layer
│   │   └── user_provider.dart           # User state management
│   ├── push_notifications/              # Push notifications
│   │   ├── model/
│   │   │   └── realtime_notification_model.dart
│   │   └── push_notifications.dart       # Notification handler
│   ├── utils/                           # Utility functions & widgets
│   │   ├── api_constants.dart           # API endpoints
│   │   ├── app_colors.dart              # App color palette
│   │   ├── common_appBar.dart           # Custom app bar
│   │   ├── common_widgets.dart          # Reusable widgets
│   │   ├── constants.dart              # App constants
│   │   ├── countries_list.dart          # Country data
│   │   ├── custom_button.dart           # Custom button widget
│   │   ├── custom_textfield.dart        # Custom text field
│   │   ├── global_share_data.dart       # Global shared data
│   │   ├── google_place_autocompleted.dart # Google Places autocomplete
│   │   ├── image_constants.dart         # Image asset constants
│   │   ├── image_picker.dart            # Image picker utility
│   │   ├── mutli_select_drop_down.dart  # Multi-select dropdown
│   │   ├── pdf_download.dart           # PDF download utility
│   │   ├── server_communicator.dart     # Server communication
│   │   ├── shared_prefrences.dart      # Shared preferences wrapper
│   │   ├── sizedbox_constants.dart      # Size constants
│   │   ├── text_theme.dart              # Text theme
│   │   ├── themes.dart                  # App themes
│   │   ├── tool_tip.dart                # Tooltip widget
│   │   ├── utility.dart                 # General utilities
│   │   └── utils.dart                   # Additional utilities
│   ├── main.dart                        # App entry point
│   └── splash_screen.dart              # Splash screen
├── assets/                              # Static assets (11 items)
├── test/                                # Test files
├── .dart_tool/                          # Dart build tools
├── .git/                                # Git repository
├── .gitignore                           # Git ignore rules
├── .metadata                            # IDE metadata
├── .flutter-plugins-dependencies        # Flutter plugin dependencies
├── analysis_options.yaml                # Dart analysis options
├── pubspec.yaml                         # Flutter dependencies
├── pubspec.lock                         # Locked dependencies
├── README.md                            # Project documentation
├── FLUTTER_CI_CD_SOLUTION.md            # CI/CD solution documentation
└── xyzkeystore                          # Android keystore file
```

## Architecture Overview

### Layer Architecture
```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Views - Screens & Widgets)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Controller Layer           │
│  (GetX Controllers - Logic)         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Provider Layer             │
│  (State Management & API)          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                 │
│  (Models & Network Service)        │
└─────────────────────────────────────┘
```

### Module Structure

#### 1. Authentication Module
**Purpose:** User authentication flow
**Components:**
- **Login:** User login with credentials
- **OTP Verification:** Two-factor authentication
- **Signup:** New user registration

**Flow:**
```
Splash Screen → Login → OTP Verification → Dashboard
           ↓
        Signup
```

**Key Files:**
- `authentication/login/controller/`
- `authentication/otpverification/controller/`
- `authentication/signup/controller/`

#### 2. Dashboard Module
**Purpose:** Main application interface
**Components:**
- **Home:** Product browsing and search
- **Orders:** Order history and management
- **Offers:** Promotions and discounts
- **Wallet:** Payment and balance management
- **More:** Settings and profile

**Key Files:**
- `dashboard/home/`
- `dashboard/orders/`
- `dashboard/offers/`
- `dashboard/wallet/`
- `dashboard/more/`

#### 3. Navigation Module
**Purpose:** App routing and navigation
**Components:**
- **Router:** Route configuration
- **Bottom Navigation:** Tab-based navigation

**Key Files:**
- `navigation/router.dart`
- `bottomNavigation/`

#### 4. Provider Module
**Purpose:** State management and API communication
**Components:**
- **User Provider:** User state management
- **Network Service:** API calls
- **Logging:** Error logging
- **Error Response:** Error handling

**Key Files:**
- `provider/user_provider.dart`
- `provider/network_service.dart`
- `provider/logging.dart`

#### 5. Utils Module
**Purpose:** Shared utilities and widgets
**Components:**
- **API Constants:** Endpoint definitions
- **App Colors:** Color palette
- **Custom Widgets:** Reusable UI components
- **Image Picker:** Image selection
- **PDF Download:** Document handling

**Key Files:**
- `utils/api_constants.dart`
- `utils/app_colors.dart`
- `utils/common_widgets.dart`
- `utils/custom_button.dart`
- `utils/custom_textfield.dart`

## Data Flow

### Authentication Flow
```
User Input (View)
    ↓
Controller (GetX)
    ↓
Provider (User Provider)
    ↓
Network Service (API Call)
    ↓
API Response
    ↓
Model (Data Parsing)
    ↓
Controller (State Update)
    ↓
View (UI Refresh)
```

### Order Placement Flow
```
Product Selection (Home View)
    ↓
Add to Cart (Cart Controller)
    ↓
Checkout (Orders Controller)
    ↓
Payment (Wallet/Payment Gateway)
    ↓
Order Confirmation
    ↓
Order History (Orders View)
```

## Key Dependencies

### Flutter SDK
- Flutter 3.41.6
- Dart SDK constraints

### State Management
- GetX (Controller pattern)

### UI Components
- Flutter built-in widgets
- Custom widgets in utils/

### API & Networking
- HTTP requests via network_service.dart
- API constants defined in api_constants.dart

### Firebase Integration
- Firebase Core
- Firebase Dynamic Links
- Firebase Messaging (Push notifications)

### Maps & Location
- Google Maps
- Google Places
- Geolocation
- Geocoding

### Other Key Packages
- Image picker
- File picker
- Shared preferences
- PDF viewer
- In-app purchases
- Local authentication
- Payment integration

## CI/CD Integration

### GitHub Actions Workflow
**Location:** `.github/workflows/build.yml`

**Features:**
- Self-hosted Mac runner
- OIDC AWS authentication
- Android APK build
- iOS app build
- S3 artifact storage
- Conditional deployment

### AWS Integration
- S3 for artifact storage
- Secrets Manager for credentials
- EC2 Image Builder for build environment
- Device Farm for testing

## Build Configuration

### Android
- **Build Tool:** Gradle
- **SDK Version:** 36
- **Keystore:** xyzkeystore
- **Signing:** Configured in gradle.properties

### iOS
- **Build Tool:** Xcode
- **Platform:** iOS 26.4
- **Simulators:** Multiple iOS simulators available
- **Code Signing:** Requires certificates (not configured for debug builds)

## Security Considerations

### Credentials
- AWS credentials via OIDC (no hardcoded keys)
- Android keystore: xyzkeystore
- iOS certificates: Stored in AWS Secrets Manager

### API Security
- API endpoints defined in api_constants.dart
- Network service handles authentication
- Error response model for error handling

## Development Workflow

### Local Development
1. Install Flutter SDK
2. Install dependencies: `flutter pub get`
3. Run app: `flutter run`
4. Test on simulator/emulator

### CI/CD Pipeline
1. Push to GitHub
2. GitHub Actions triggers build
3. Self-hosted Mac runner executes build
4. Artifacts uploaded to S3
5. Optional deployment to app stores

## Key Files Reference

### Configuration Files
- `pubspec.yaml` - Dependencies and project metadata
- `analysis_options.yaml` - Dart linting rules
- `.gitignore` - Git ignore patterns

### Entry Points
- `lib/main.dart` - App entry point
- `lib/splash_screen.dart` - Splash screen

### Core Logic
- `lib/navigation/router.dart` - App routing
- `lib/provider/network_service.dart` - API communication
- `lib/provider/user_provider.dart` - User state

### Utilities
- `lib/utils/api_constants.dart` - API endpoints
- `lib/utils/app_colors.dart` - App theming
- `lib/utils/common_widgets.dart` - Reusable widgets

## Testing
- Test files in `test/` directory
- Currently minimal test coverage

## Performance Metrics
- Flutter jank metrics tracked (flutter_jank_metrics_01.json)
- Build logs available (flutter_01.log)

## Notes
- Project uses GetX for state management
- MVC architecture pattern
- Modular structure for maintainability
- CI/CD configured with GitHub Actions and AWS
- Both iOS and Android builds successfully completed
