package com.thegreenmall

// Bridges integration_test/app_test.dart into a JUnit test the Android
// instrumentation runner can discover. Without this class,
// AndroidJUnitRunner finds zero @Test methods in the androidTest APK, so
// Firebase Test Lab reports the matrix as "Passed" with 0 test cases — the
// runner completes cleanly but never actually executes the Dart test.
import androidx.test.rule.ActivityTestRule
import dev.flutter.plugins.integration_test.FlutterTestRunner
import org.junit.Rule
import org.junit.runner.RunWith

@RunWith(FlutterTestRunner::class)
class MainActivityTest {
    @Rule
    @JvmField
    val rule: ActivityTestRule<MainActivity> =
        ActivityTestRule(MainActivity::class.java, /* initialTouchMode= */ true, /* launchActivity= */ false)
}
