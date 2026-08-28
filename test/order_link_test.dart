import 'package:flutter_test/flutter_test.dart';
import 'package:thegreenmall/dashboard/orders/order_link.dart';

void main() {
  group('OrderLink.build', () {
    test('produces the universal-link form', () {
      expect(
        OrderLink.build(storeId: 12, orderId: 345),
        'https://thegreenmall.net/order?store_id=12&order_id=345',
      );
    });

    test('stringifies String ids too', () {
      expect(
        OrderLink.build(storeId: '8', orderId: '9'),
        'https://thegreenmall.net/order?store_id=8&order_id=9',
      );
    });
  });

  group('OrderLink.parse', () {
    test('round-trips the universal-link form', () {
      final url = OrderLink.build(storeId: 12, orderId: 345);
      expect(OrderLink.parse(url), {'storeId': '12', 'orderId': '345'});
    });

    test('accepts www host, reordered params, and extra query keys', () {
      expect(
        OrderLink.parse(
            'https://www.thegreenmall.net/order?order_id=9&store_id=8&utm=x'),
        {'storeId': '8', 'orderId': '9'},
      );
    });

    test('still parses legacy JSON payloads from older builds', () {
      expect(
        OrderLink.parse('{"type":"order","order_id":7,"store_id":3}'),
        {'storeId': '3', 'orderId': '7'},
      );
    });

    test('rejects a payment link (no cross-talk with /pay)', () {
      expect(OrderLink.parse('https://thegreenmall.net/pay/abc'), isNull);
    });

    test('rejects a foreign host', () {
      expect(
        OrderLink.parse('https://evil.com/order?store_id=1&order_id=2'),
        isNull,
      );
    });

    test('rejects a link missing an id', () {
      expect(OrderLink.parse('https://thegreenmall.net/order?store_id=1'), isNull);
    });

    test('rejects plain text (the old Google-search trigger)', () {
      expect(OrderLink.parse('just some text'), isNull);
    });
  });

  group('OrderLink.isOrderLink', () {
    test('true for an order link, false for a payment link', () {
      expect(
        OrderLink.isOrderLink(OrderLink.build(storeId: 1, orderId: 2)),
        isTrue,
      );
      expect(OrderLink.isOrderLink('https://thegreenmall.net/pay/x'), isFalse);
    });
  });
}
