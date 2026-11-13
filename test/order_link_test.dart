import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:thegreenmall/dashboard/orders/order_link.dart';

void main() {
  group('OrderLink', () {
    test('build round-trips through extractPayload to the original code', () {
      final link = OrderLink.build(orderId: '123', storeId: '45');
      expect(link, startsWith('https://thegreenmall.net/order/'));

      final payload = OrderLink.extractPayload(link);
      expect(payload, isNotNull);

      final decoded = jsonDecode(payload!);
      expect(decoded['type'], 'order');
      expect(decoded['order_id'], '123');
      expect(decoded['store_id'], '45');
    });

    test('build accepts int ids too', () {
      final link = OrderLink.build(orderId: 9, storeId: 8);
      final decoded = jsonDecode(OrderLink.extractPayload(link)!);
      expect(decoded['order_id'], 9);
      expect(decoded['store_id'], 8);
    });

    test('isOrderLink recognises an order link and rejects others', () {
      expect(OrderLink.isOrderLink(OrderLink.build(orderId: '1', storeId: '2')),
          isTrue);
      // A payment link is not an order link.
      expect(OrderLink.isOrderLink('https://thegreenmall.net/pay/abc'), isFalse);
      // Wrong host.
      expect(OrderLink.isOrderLink('https://evil.example/order/abc'), isFalse);
      // Bare JSON (legacy QR) is not a URL.
      expect(
          OrderLink.isOrderLink('{"type":"order","order_id":"1","store_id":"2"}'),
          isFalse);
    });

    test('extractPayload accepts the legacy query-string form', () {
      final payload = OrderLink.extractPayload(
          'https://www.thegreenmall.net/order?order_id=9&store_id=8&utm=x');
      expect(payload, isNotNull);
      final decoded = jsonDecode(payload!);
      expect(decoded['order_id'], '9');
      expect(decoded['store_id'], '8');
      // A query-form link missing an id is not a valid order link.
      expect(OrderLink.extractPayload('https://thegreenmall.net/order?store_id=8'),
          isNull);
    });

    test('payloadFromScan unwraps a link but passes legacy JSON through', () {
      final link = OrderLink.build(orderId: '7', storeId: '8');
      final unwrapped = OrderLink.payloadFromScan(link);
      expect(jsonDecode(unwrapped)['order_id'], '7');

      const legacy = '{"type":"order","order_id":"9","store_id":"10"}';
      expect(OrderLink.payloadFromScan(legacy), legacy);
    });

    test('rejects an empty path and non-order paths', () {
      expect(OrderLink.extractPayload('https://thegreenmall.net/order/'), isNull);
      expect(OrderLink.extractPayload('https://thegreenmall.net/'), isNull);
    });
  });
}
