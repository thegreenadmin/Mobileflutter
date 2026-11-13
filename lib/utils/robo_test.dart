/// Set only for the Firebase Test Lab iOS Robo build
/// (`flutter build ios --dart-define=ROBO_TEST=true`). Store and TestFlight
/// builds never set it, so everything it guards is compiled out of them.
///
/// Robo can type the phone number on iOS but not the OTP: the code boxes keep
/// their input in a hidden field that never reports keyboard focus, and Robo
/// only types into a focused field. With this set, the OTP screen enters the
/// demo account's fixed code itself.
const bool kRoboTest = bool.fromEnvironment('ROBO_TEST');

/// Test Lab's demo account, the one the Robo login script uses.
const String roboDemoPhone = '0000000000';
const String roboDemoOtp = '0000';
