import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Scans user / merchant barcodes & QR codes, with manual entry and
/// upload-from-gallery fallbacks (spec 5.2).
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final PaymentController c = Get.find<PaymentController>();
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.ean13,
      BarcodeFormat.pdf417,
    ],
  );
  late final AnimationController _lineCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

  bool _manual = false;
  bool _handling = false; // guards against duplicate detections while navigating
  bool _torchOn = false;

  late final String _type; // 'p2p' | 'p2b'

  @override
  void initState() {
    super.initState();
    _type = ((Get.arguments as Map?)?['type'] as String?) ?? c.paymentType.value;
    // Start each launch from a clean slate so a prior payment doesn't leak in.
    c.resetFlow();
    c.paymentType.value = _type;
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    _scanner.dispose();
    super.dispose();
  }

  bool get _isP2B => _type == 'p2b';

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling || _manual) return;
    final raw = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (raw == null || raw.isEmpty) return;
    await _resolveAndProceed(() => c.decodeScannedCode(raw));
  }

  Future<void> _resolveAndProceed(Future Function() resolver) async {
    if (_handling) return;
    setState(() => _handling = true);
    final recipient = await resolver();
    if (!mounted) return;
    if (recipient != null) {
      await _scanner.stop();
      Get.toNamed(PaymentRoutes.details);
      // Allow re-scanning if the user returns.
      if (mounted) {
        setState(() => _handling = false);
        _scanner.start();
      }
    } else {
      _showError(c.errorMessage.value);
      setState(() => _handling = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.isEmpty ? 'Invalid or unsupported code.' : message),
        backgroundColor: PayTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _uploadFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final BarcodeCapture? result = await _scanner.analyzeImage(picked.path);
    final raw = (result != null && result.barcodes.isNotEmpty)
        ? result.barcodes.first.rawValue
        : null;
    if (raw == null || raw.isEmpty) {
      _showError('No payment code found in the selected image.');
      return;
    }
    await _resolveAndProceed(() => c.decodeScannedCode(raw));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        children: [
          PayAppBar(
            title: _isP2B ? 'P2B – Pay a Business' : 'P2P – Pay a Person',
            subtitle: _isP2B ? 'Scan merchant barcode' : 'Scan or enter recipient barcode',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
            child: _ScanModeToggle(
              manual: _manual,
              manualLabel: _isP2B ? 'Enter Merchant ID' : 'Enter Mobile',
              onChanged: (m) => setState(() => _manual = m),
            ),
          ),
          const SizedBox(height: PayTheme.itemGap),
          Expanded(
            child: _manual ? _buildManualEntry() : _buildScanner(),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        children: [
          Text(
            'Align the barcode within the frame',
            style: PayTheme.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PayTheme.itemGap),
          ClipRRect(
            borderRadius: BorderRadius.circular(PayTheme.cardRadius),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scanner,
                    onDetect: _onDetect,
                    errorBuilder: (context, error) => _CameraError(error: error),
                  ),
                  _ScannerOverlay(animation: _lineCtrl),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FloatingActionButton.small(
                        heroTag: 'torch',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          _scanner.toggleTorch();
                          setState(() => _torchOn = !_torchOn);
                        },
                        child: Icon(
                          _torchOn ? Icons.flash_on : Icons.flash_off,
                          color: PayTheme.primaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: PayTheme.sectionGap),
          Row(children: const [
            Expanded(child: Divider()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('OR')),
            Expanded(child: Divider()),
          ]),
          const SizedBox(height: PayTheme.itemGap),
          OutlinedButton.icon(
            onPressed: _uploadFromGallery,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(PayTheme.buttonHeight),
              side: const BorderSide(color: PayTheme.accent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.image_outlined, color: PayTheme.accent),
            label: const Text('Upload from Gallery', style: TextStyle(color: PayTheme.accent)),
          ),
          const SizedBox(height: PayTheme.sectionGap),
        ],
      ),
    );
  }

  Widget _buildManualEntry() {
    return _isP2B ? const _MerchantIdEntry() : const _MobileEntry();
  }
}

class _ScanModeToggle extends StatelessWidget {
  final bool manual;
  final String manualLabel;
  final ValueChanged<bool> onChanged;
  const _ScanModeToggle(
      {required this.manual, required this.manualLabel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(String text, bool isManual) {
      final selected = manual == isManual;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(isManual),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? PayTheme.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : PayTheme.secondaryText)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [tab('Scan Barcode', false), tab(manualLabel, true)]),
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
          // Corner frame
          Center(
            child: Container(
              width: constraints.maxWidth * 0.78,
              height: constraints.maxHeight * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: PayTheme.accent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Animated scan line
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final top = constraints.maxHeight * (0.27 + 0.46 * animation.value);
              return Positioned(
                top: top,
                left: constraints.maxWidth * 0.13,
                right: constraints.maxWidth * 0.13,
                child: Container(height: 2, color: PayTheme.accent),
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
      child: PayMessageView(
        icon: denied ? Icons.no_photography_outlined : Icons.error_outline,
        iconColor: Colors.white70,
        title: denied ? 'Camera access needed' : 'Camera unavailable',
        message: denied
            ? 'Allow camera access to scan payment codes. You can enable it in Settings.'
            : 'We couldn\'t start the camera. Please try again or enter details manually.',
        actionText: denied ? 'Open Settings' : null,
        onAction: denied ? () => openAppSettings() : null,
      ),
    );
  }
}

class _MobileEntry extends StatefulWidget {
  const _MobileEntry();
  @override
  State<_MobileEntry> createState() => _MobileEntryState();
}

class _MobileEntryState extends State<_MobileEntry> {
  final PaymentController c = Get.find<PaymentController>();
  final _phoneController = TextEditingController();
  // Matches the registration/login flow: digits in the field, dial code via flag.
  String _phoneNumber = '';
  String _countryCode = '+1';
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone =
        _phoneNumber.isNotEmpty ? _phoneNumber : _phoneController.text.trim();
    if (phone.isEmpty) return;
    setState(() => _loading = true);
    // Backend stores phone and phone_code separately, so send digits only.
    final r = await c.lookupRecipient(phone: phone, phoneCode: _countryCode);
    if (!mounted) return;
    setState(() => _loading = false);
    if (r != null) {
      Get.toNamed(PaymentRoutes.details);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(c.errorMessage.value),
        backgroundColor: PayTheme.error,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        children: [
          IntlPhoneField(
            initialCountryCode: StringConstants.usText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _phoneController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.phone,
            style: const TextStyle(
                color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w400),
            showDropdownIcon: false,
            flagsButtonMargin: const EdgeInsets.all(10),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: Image.asset(ImageConstants.calling),
              alignLabelWithHint: true,
              hintText: StringConstants.mobileText,
              hintStyle: const TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
              ),
            ),
            onCountryChanged: (value) {
              setState(() => _countryCode = "+${value.dialCode}");
            },
            onChanged: (phone) {
              _phoneNumber = phone.number;
              _countryCode = phone.countryCode;
            },
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: PayTheme.sectionGap),
          PayButton(text: 'Continue', loading: _loading, onTap: _submit),
        ],
      ),
    );
  }
}

class _MerchantIdEntry extends StatefulWidget {
  const _MerchantIdEntry();
  @override
  State<_MerchantIdEntry> createState() => _MerchantIdEntryState();
}

class _MerchantIdEntryState extends State<_MerchantIdEntry> {
  final PaymentController c = Get.find<PaymentController>();
  final _merchant = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_merchant.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final r = await c.lookupRecipient(merchantId: _merchant.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    if (r != null) {
      Get.toNamed(PaymentRoutes.details);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(c.errorMessage.value),
        backgroundColor: PayTheme.error,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        children: [
          TextField(
            controller: _merchant,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Merchant ID',
              filled: true,
              fillColor: PayTheme.cardSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: PayTheme.divider),
              ),
            ),
          ),
          const SizedBox(height: PayTheme.sectionGap),
          PayButton(text: 'Continue', loading: _loading, onTap: _submit),
        ],
      ),
    );
  }
}
