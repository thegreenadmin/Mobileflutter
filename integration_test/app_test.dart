// Runs the real app (lib/main.dart's main()) end to end on a Firebase Test
// Lab device via `gcloud firebase test android run --type instrumentation`.
//
// This exists because Firebase Test Lab's Robo crawler does not reliably
// steer Flutter apps to a specific widget by resource-id — Flutter's
// semantics tree isn't exposed to Android's accessibility bridge the way
// Robo's --robo-directives matcher expects, confirmed by repeated "no
// resource name matched" results even after adding
// Semantics(identifier: ...) to the target buttons. This test drives the
// same guest flow deterministically through Flutter's own widget tree
// instead, via WidgetTester, which has no dependency on that bridge.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('guest entry reaches the app home screen', (tester) async {
    app.main();

    // pumpAndSettle's default `timeout` is 10 minutes — well past gcloud's
    // own --timeout on the instrumentation run, so a genuine hang here
    // (e.g. a spinner tied to a network call that never resolves) would
    // previously surface as an opaque Test-Lab-level "Test timed out"
    // instead of a readable Dart assertion. Bound it explicitly so a real
    // hang fails fast with an actionable error.
    const settleTimeout = Duration(seconds: 30);

    // Splash screen holds for a fixed 3s before routing to StartJourneyScreen.
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      settleTimeout,
    );

    final guestButton = find.text(StringConstants.continueAsGuestText);
    expect(
      guestButton,
      findsOneWidget,
      reason: 'Expected the guest entry button on the welcome screen',
    );

    await tester.tap(guestButton);
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      settleTimeout,
    );

    expect(
      find.byType(BottomNavigation),
      findsOneWidget,
      reason: 'Guest entry should land on the app home screen',
    );
  });
}
