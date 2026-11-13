import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/app_config.dart';
import 'package:thegreenmall/utils/image_constants.dart';

/// Branding images an admin can replace (Settings → App appearance →
/// Branding). Maps each bundled asset to its config slot so call sites only
/// swap `Image.asset(` for `BrandImage.asset(`.
const Map<String, String> _slotForAsset = {
  ImageConstants.splashBg: 'splash_background_url',
  ImageConstants.startJourneyBg: 'start_journey_background_url',
  ImageConstants.greenmall420: 'logo_url',
  ImageConstants.onBoardOne: 'onboarding_image_1',
  ImageConstants.onBoardTwo: 'onboarding_image_2',
  ImageConstants.onBoardThree: 'onboarding_image_3',
  ImageConstants.onBoardFour: 'onboarding_image_4',
  ImageConstants.defaultProduct: 'placeholder_product_url',
  ImageConstants.nodata: 'empty_state_url',
};

/// Remote URL configured for [asset]'s slot, or null to use the asset.
String? brandImageUrl(String asset) {
  final slot = _slotForAsset[asset];
  return slot == null ? null : AppConfig.current.image(slot);
}

/// For DecorationImage and other provider-based APIs.
ImageProvider brandImageProvider(String asset) {
  final url = brandImageUrl(asset);
  if (url != null) return CachedNetworkImageProvider(url);
  return AssetImage(asset);
}

/// Drop-in replacement for [Image.asset] that shows the admin-configured
/// image for [asset]'s slot when one is set, falling back to the bundled
/// asset while loading or on error.
class BrandImage extends StatelessWidget {
  const BrandImage.asset(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.scale,
    this.color,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? scale;
  final Color? color;

  Widget _asset() => Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        scale: scale,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final url = brandImageUrl(asset);
    if (url == null) return _asset();
    return Image(
      image: CachedNetworkImageProvider(url, scale: scale ?? 1.0),
      width: width,
      height: height,
      fit: fit,
      color: color,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded ? _asset() : child,
      errorBuilder: (context, error, stackTrace) => _asset(),
    );
  }
}
