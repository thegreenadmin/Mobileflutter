// Runs integration_test/app_test.dart as an XCTest case, so Firebase Test Lab
// can run the journey on iPhones. The RunnerTests target is added to the
// Xcode project in CI (.github/ios/add_runner_tests.rb); app builds don't use it.
//
// Not INTEGRATION_TEST_IOS_RUNNER: that macro runs every Dart test while
// XCTest is still discovering tests, and Xcode stops discovery after ~13
// minutes ("The test runner timed out while preparing to run tests"), well
// before the journey ends. Running the Dart tests inside one test method
// keeps them in the execution phase, which has no such limit.
@import XCTest;
@import integration_test;

@interface RunnerTests : XCTestCase
@end

@implementation RunnerTests

- (void)testIntegrationJourney {
  FLTIntegrationTestRunner *runner = [[FLTIntegrationTestRunner alloc] init];
  __block NSUInteger results = 0;
  [runner testIntegrationTestWithResults:^(SEL testSelector, BOOL success,
                                           NSString *failureMessage) {
    results++;
    XCTAssertTrue(success, @"%@: %@", NSStringFromSelector(testSelector),
                  failureMessage);
  }];
  XCTAssertGreaterThan(results, 0u, @"no Dart tests reported a result");
}

@end
