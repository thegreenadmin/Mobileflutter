import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_gate.dart';
import 'package:thegreenmall/utils/platform_freeze.dart';

Map<String, dynamic> frozen(String mode, String message) => {
      'status': 503,
      'code': 'PLATFORM_FROZEN',
      'mode': mode,
      'message': message,
      'errors': [message],
    };

void main() {
  group('isFrozenResponse', () {
    test('only a 503 with the freeze code counts', () {
      expect(PlatformFreeze.isFrozenResponse(503, frozen('full', 'x')), isTrue);
      expect(PlatformFreeze.isFrozenResponse(503, {'message': 'busy'}), isFalse);
      expect(PlatformFreeze.isFrozenResponse(503, 'Service Unavailable'), isFalse);
      expect(PlatformFreeze.isFrozenResponse(200, frozen('full', 'x')), isFalse);
      expect(PlatformFreeze.isFrozenResponse(null, null), isFalse);
    });

    test('other responses are left to the caller', () {
      expect(PlatformFreeze.handle(200, {'status': 200}), isFalse);
      expect(PlatformFreeze.handle(500, {'message': 'oops'}), isFalse);
    });
  });

  testWidgets('a full freeze replaces the app with the maintenance screen',
      (tester) async {
    PlatformFreeze.lifted();
    await tester.pumpWidget(const GetMaterialApp(
        home: Scaffold(body: Text('Home screen'))));
    expect(find.text('Home screen'), findsOneWidget);

    final handled = PlatformFreeze.handle(
        503, frozen('full', 'Back at 5pm after an update.'));
    expect(handled, isTrue);
    await tester.pumpAndSettle();

    expect(find.byType(AppBlockedScreen), findsOneWidget);
    expect(find.text('Back at 5pm after an update.'), findsOneWidget);
    expect(find.text('Home screen'), findsNothing);

    // A second refused call while the screen is up doesn't stack another.
    PlatformFreeze.handle(503, frozen('full', 'Back at 5pm after an update.'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBlockedScreen), findsOneWidget);
    PlatformFreeze.lifted();
  });
}
