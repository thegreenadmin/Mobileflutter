import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/model/orders_model.dart' as model;
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'component/order_status_enum.dart';

/// Scans a customer's order QR (payload: {"type":"order","order_id","store_id"})
/// and opens that order's fulfil screen. Modeled on the payments
/// BarcodeScannerScreen: live camera with overlay + torch, and an
/// upload-from-gallery fallback.
class OrderBarcodeScannerScreen extends StatefulWidget {
  const OrderBarcodeScannerScreen({super.key});

  @override
  State<OrderBarcodeScannerScreen> createState() =>
      _OrderBarcodeScannerScreenState();
}

class _OrderBarcodeScannerScreenState extends State<OrderBarcodeScannerScreen>
    with GlobalVarMixin, SingleTickerProviderStateMixin {
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  late final AnimationController _lineCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  bool _handling = false; // guards duplicate detections while navigating
  bool _torchOn = false;

  @override
  void dispose() {
    _lineCtrl.dispose();
    _scanner.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final raw =
        capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (raw == null || raw.isEmpty) return;
    await _resolveAndProceed(raw);
  }

  Future<void> _uploadFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final BarcodeCapture? result = await _scanner.analyzeImage(picked.path);
    final raw = (result != null && result.barcodes.isNotEmpty)
        ? result.barcodes.first.rawValue
        : null;
    if (raw == null || raw.isEmpty) {
      Utility.showAlertMessage(AlertStringConstants.noOrderCodeInImageText);
      return;
    }
    await _resolveAndProceed(raw);
  }

  /// Order QRs carry {"type":"order","order_id":..,"store_id":..}.
  Map<String, String>? _parseOrderCode(String raw) {
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

  bool _hasStoreAccess(String storeId) {
    return hasStoreAccess.value && permissionStoreList.isEmpty ||
        permissionStoreList.any((element) =>
            element.storeId == storeId && element.isStoreOwner == true ||
            element.storeId == storeId &&
                element.controllers!.any((ele) =>
                    ele.controllerKey ==
                    PermissionKey.manageOrders.statusName));
  }

  /// Which orders tab the fulfil screen should open on for [statusName].
  int _tabIndexForStatus(String statusName) {
    if (statusName == OrderStatusEnum.receivedOrder.statusName) return 0;
    if (statusName == OrderStatusEnum.inProgress.statusName) return 1;
    if (statusName == OrderStatusEnum.inTransit.statusName ||
        statusName == OrderStatusEnum.readyForPickup.statusName) {
      return 2;
    }
    return 3;
  }

  Future<void> _resolveAndProceed(String raw) async {
    if (_handling) return;
    setState(() => _handling = true);

    final code = _parseOrderCode(raw);
    if (code == null) {
      Utility.showAlertMessage(AlertStringConstants.notAValidOrderCodeText);
      setState(() => _handling = false);
      return;
    }
    if (!_hasStoreAccess(code['storeId']!)) {
      Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
      setState(() => _handling = false);
      return;
    }

    // Fetch the order to learn its current status so the fulfil screen opens
    // on the matching tab with the right action button.
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    final value = await UserProvider().getWithHeadersApi(
        "${ServerCommunicator.baseUrl}${ServerCommunicator.storeOrderDetail}?store_id=${code['storeId']}&order_id=${code['orderId']}",
        headers,
        showLoading: true);
    if (!mounted) return;

    if (value?.body["status"] != ApiConstants.statusCode200 &&
        value?.body["status"] != ApiConstants.statusCode201) {
      Utility.showAlertMessage(value?.body['message'] ??
          AlertStringConstants.notAValidOrderCodeText);
      setState(() => _handling = false);
      return;
    }

    final detail = model.GetStoreOrderDetailModel.fromJson(value?.body);
    final statusName = detail
            .data?.order?.orderHistories?.last.orderStatus?.orderStatusName ??
        "";
    if (statusName == OrderStatusEnum.returnRequest.statusName) {
      Utility.showAlertMessage(
          AlertStringConstants.orderReturnRequestScanText);
      setState(() => _handling = false);
      return;
    }

    final ordersHomeMainController = Get.put(OrdersHomeMainController());
    ordersHomeMainController.storeId.value = code['storeId']!;
    ordersHomeMainController.orderId.value = code['orderId']!;
    ordersHomeMainController.selectedIndex.value =
        _tabIndexForStatus(statusName);

    await _scanner.stop();
    // Await the pushed route so the camera stays stopped (and detection stays
    // gated by [_handling]) while the fulfil screen is on top; restarting
    // without awaiting lets the camera re-detect the same QR in a loop.
    await Get.to(
        () => MarkOrderStatusScreen(
              orderId: code['orderId'],
              storeId: code['storeId'],
              orderStatus: "",
              isFromNotification: true,
            ),
        id: pageIdApp.value);
    if (mounted) {
      setState(() => _handling = false);
      _scanner.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(id: pageIdApp.value),
        ),
        title: Text(
          StringConstants.scanOrderBarcodeText,
          style: const TextStyle(
              color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              StringConstants.alignOrderCodeText,
              style: TextStyle(color: AppColors.blackLight, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            height12SizedBox,
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 0.85,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _scanner,
                      onDetect: _onDetect,
                      errorBuilder: (context, error) =>
                          _CameraError(error: error),
                    ),
                    _ScannerOverlay(animation: _lineCtrl),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: FloatingActionButton.small(
                          heroTag: 'orderScanTorch',
                          backgroundColor: AppColors.white,
                          onPressed: () {
                            _scanner.toggleTorch();
                            setState(() => _torchOn = !_torchOn);
                          },
                          child: Icon(
                            _torchOn ? Icons.flash_on : Icons.flash_off,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height20SizedBox,
            Row(children: const [
              Expanded(child: Divider()),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('OR')),
              Expanded(child: Divider()),
            ]),
            height12SizedBox,
            OutlinedButton.icon(
              onPressed: _uploadFromGallery,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.image_outlined, color: AppColors.primary),
              label: Text(StringConstants.uploadFromGalleryText,
                  style: const TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  final Animation<double> animation;
  const _ScannerOverlay({required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Center(
            child: Container(
              width: constraints.maxWidth * 0.78,
              height: constraints.maxHeight * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final top =
                  constraints.maxHeight * (0.27 + 0.46 * animation.value);
              return Positioned(
                top: top,
                left: constraints.maxWidth * 0.13,
                right: constraints.maxWidth * 0.13,
                child: Container(height: 2, color: AppColors.primary),
              );
            },
          ),
        ],
      );
    });
  }
}

class _CameraError extends StatelessWidget {
  final MobileScannerException error;
  const _CameraError({required this.error});

  @override
  Widget build(BuildContext context) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            denied ? Icons.no_photography_outlined : Icons.error_outline,
            color: Colors.white70,
            size: 40,
          ),
          height12SizedBox,
          Text(
            denied ? 'Camera access needed' : 'Camera unavailable',
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          height8SizedBox,
          Text(
            denied
                ? 'Allow camera access to scan order codes. You can enable it in Settings.'
                : 'We couldn\'t start the camera. Please try again.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (denied) ...[
            height12SizedBox,
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ],
      ),
    );
  }
}
