// Runs integration_test/app_test.dart as an XCTest case, so Firebase Test Lab
// can run the journey on iPhones. The RunnerTests target is added to the
// Xcode project in CI (.github/ios/add_runner_tests.rb); app builds don't use it.
@import XCTest;
@import integration_test;

INTEGRATION_TEST_IOS_RUNNER(RunnerTests)
