import 'dart:convert';

import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/model/orders_model.dart' as model;
import 'package:thegreenmall/dashboard/orders/order_link.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_status_enum.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Parsed order code carried by a pickup QR: {"type":"order","order_id":..,
/// "store_id":..}. Returns null when [raw] isn't a valid order payload.
Map<String, String>? parseOrderCode(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map || decoded['type'] != 'order') return null;
    final orderId = decoded['order_id']?.toString() ?? '';
    final storeId = decoded['store_id']?.toString() ?? '';
    if (orderId.isEmpty || storeId.isEmpty) return null;
    return {'orderId': orderId, 'storeId': storeId};
  } catch (_) {
    return null;
  }
}

/// Whether the signed-in user may fulfil orders for [storeId].
bool hasStoreAccessFor(String storeId) {
  return hasStoreAccess.value && permissionStoreList.isEmpty ||
      permissionStoreList.any((element) =>
          element.storeId == storeId && element.isStoreOwner == true ||
          element.storeId == storeId &&
              element.controllers!.any((ele) =>
                  ele.controllerKey ==
                  PermissionKey.manageOrders.statusName));
}

/// Which orders tab the fulfil screen should open on for [statusName].
int tabIndexForStatus(String statusName) {
  if (statusName == OrderStatusEnum.receivedOrder.statusName) return 0;
  if (statusName == OrderStatusEnum.inProgress.statusName) return 1;
  if (statusName == OrderStatusEnum.inTransit.statusName ||
      statusName == OrderStatusEnum.readyForPickup.statusName) {
    return 2;
  }
  return 3;
}

/// Resolves a scanned or deep-linked order value — an [OrderLink] URL
/// (`https://thegreenmall.net/order/<token>`) or a bare {"type":"order",..}
/// JSON payload — and opens that order's fulfil screen.
///
/// Shared by the in-app [OrderBarcodeScannerScreen] and the universal-link
/// [DeepLinkService]. [navId] is the GetX nested-navigator id to push on (the
/// orders tab shell); pass null to push on the root navigator, which the
/// deep-link handler uses on cold start where the shell isn't mounted yet.
///
/// Returns null on success (after the fulfil screen is dismissed), or a
/// user-facing error message the caller should surface.
Future<String?> resolveOrderAndOpen(String rawOrLink, {int? navId}) async {
  final code = parseOrderCode(OrderLink.payloadFromScan(rawOrLink));
  if (code == null) return AlertStringConstants.notAValidOrderCodeText;

  if (!hasStoreAccessFor(code['storeId']!)) {
    return AlertStringConstants.notAuthorizedToStoreText;
  }

  // Fetch the order to learn its current status so the fulfil screen opens on
  // the matching tab with the right action button.
  final Map<String, String> headers = {
    StringConstants.authorizationText:
        "${StringConstants.bearerText} ${authToken.value}",
  };
  final value = await UserProvider().getWithHeadersApi(
      "${ServerCommunicator.baseUrl}${ServerCommunicator.storeOrderDetail}?store_id=${code['storeId']}&order_id=${code['orderId']}",
      headers,
      showLoading: true);

  if (value?.body["status"] != ApiConstants.statusCode200 &&
      value?.body["status"] != ApiConstants.statusCode201) {
    return value?.body['message'] ??
        AlertStringConstants.notAValidOrderCodeText;
  }

  final detail = model.GetStoreOrderDetailModel.fromJson(value?.body);
  final statusName =
      detail.data?.order?.orderHistories?.last.orderStatus?.orderStatusName ??
          "";
  if (statusName == OrderStatusEnum.returnRequest.statusName) {
    return AlertStringConstants.orderReturnRequestScanText;
  }

  final ordersHomeMainController = Get.put(OrdersHomeMainController());
  ordersHomeMainController.storeId.value = code['storeId']!;
  ordersHomeMainController.orderId.value = code['orderId']!;
  ordersHomeMainController.selectedIndex.value = tabIndexForStatus(statusName);

  MarkOrderStatusScreen screen() => MarkOrderStatusScreen(
        orderId: code['orderId'],
        storeId: code['storeId'],
        orderStatus: "",
        isFromNotification: true,
      );
  // Await the pushed route so the caller (e.g. the scanner) can keep its camera
  // stopped while the fulfil screen is on top and restart it on return.
  if (navId != null) {
    await Get.to(screen, id: navId);
  } else {
    await Get.to(screen);
  }
  return null;
}
