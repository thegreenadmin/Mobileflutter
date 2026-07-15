import 'package:flutter_test/flutter_test.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/model/notification_status_model.dart';

/// Builds a row shaped like one entry of the server's notification_settings list.
NotificationSettings row(String type, {required bool isForStore, required bool isEnabled}) =>
    NotificationSettings(notificationType: type, isForStore: isForStore, isEnabled: isEnabled);

void main() {
  late AccountController controller;

  setUp(() => controller = AccountController());

  test('toggles default to on before the server responds', () {
    // The backend sends when no row exists, so an un-fetched toggle must read on.
    expect(controller.isUserInboxMessagesNotify.value, isTrue);
    expect(controller.isUserOfferNotify.value, isTrue);
    expect(controller.isOwnerInboxMessagesNotify.value, isTrue);
    expect(controller.isOwnerOfferNotify.value, isTrue);
  });

  test('an enabled row keeps its toggle on', () {
    controller.applyNotificationSettings([
      row('message', isForStore: false, isEnabled: true),
      row('offer', isForStore: false, isEnabled: true),
    ]);

    expect(controller.isUserInboxMessagesNotify.value, isTrue);
    expect(controller.isUserOfferNotify.value, isTrue);
  });

  test('an explicitly disabled row turns its toggle off', () {
    controller.applyNotificationSettings([
      row('message', isForStore: false, isEnabled: false),
      row('offer', isForStore: false, isEnabled: false),
    ]);

    expect(controller.isUserInboxMessagesNotify.value, isFalse);
    expect(controller.isUserOfferNotify.value, isFalse);
  });

  test('a row missing from the response leaves its toggle on', () {
    // Real staging payload for user 50, is_for_store=true: the `order` row was
    // never created, so the API omits it entirely while the backend still sends.
    controller.applyNotificationSettings([
      row('message', isForStore: true, isEnabled: false),
      row('offer', isForStore: true, isEnabled: false),
    ]);

    expect(controller.isOwnerInboxMessagesNotify.value, isFalse);
    expect(controller.isOwnerOfferNotify.value, isFalse);
    // The omitted row must stay on to match isOpenForNotification()'s answer.
    expect(controller.isOwnerTippingNotify.value, isTrue);
  });

  test('a customer-side response does not clobber the owner-side toggles', () {
    // The list endpoint returns one side per call, so fetching the customer
    // side must leave the owner toggles untouched.
    controller.applyNotificationSettings([
      row('message', isForStore: false, isEnabled: false),
      row('offer', isForStore: false, isEnabled: false),
    ]);

    expect(controller.isUserInboxMessagesNotify.value, isFalse);
    expect(controller.isOwnerInboxMessagesNotify.value, isTrue);
    expect(controller.isOwnerOfferNotify.value, isTrue);
  });
}
