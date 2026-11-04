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

    test('payloadFromScan unwraps a link but passes legacy JSON through', () {
      final link = OrderLink.build(orderId: '7', storeId: '8');
      final unwrapped = OrderLink.payloadFromScan(link);
      expect(jsonDecode(unwrapped)['order_id'], '7');

      const legacy = '{"type":"order","order_id":"9","store_id":"10"}';
      expect(OrderLink.payloadFromScan(legacy), legacy);
    });

    test('accepts www host, rejects non-order paths', () {
      expect(
          OrderLink.extractPayload('https://www.thegreenmall.net/order/%7B%7D'),
          isNotNull);
      expect(OrderLink.extractPayload('https://thegreenmall.net/order/'),
          isNull);
      expect(OrderLink.extractPayload('https://thegreenmall.net/'), isNull);
    });
  });
}
