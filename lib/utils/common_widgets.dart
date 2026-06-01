import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'image_constants.dart';

class CommonTheme {
  getColors() {
    return !Get.isDarkMode ? AppColors.white : AppColors.black;
  }
}

class CommonWidgets {
  //Bold
  // static Widget txtViewBold(
  //     String text, Color color, double size, double height,
  //     {FontWeight weight}) {
  //   return Text(
  //     text,
  //     overflow: TextOverflow.ellipsis,
  //     style: TextStyle(
  //         color: color,
  //         fontSize: size,
  //         height: 0,
  //         fontWeight: weight ?? FontWeight.bold,
  //         fontFamily: 'Poppins'),
  //   );
  // }

  //500
  // static Widget txtViewMediumBold(String text, Color color, double size,
  //     {FontWeight weight}) {
  //   return Text(
  //     text,
  //     overflow: TextOverflow.ellipsis,
  //     style: TextStyle(
  //         color: color,
  //         fontSize: size,
  //         fontWeight: FontWeight.w500,
  //         fontFamily: 'Poppins'),
  //   );
  // }

  // //400
  // static Widget txtViewSemiBold(String text, Color color, double size,
  //     {FontWeight weight}) {
  //   return Text(
  //     text,
  //     overflow: TextOverflow.ellipsis,
  //     style: TextStyle(
  //         color: color,
  //         fontSize: size,
  //         fontWeight: FontWeight.w400,
  //         fontFamily: 'Poppins'),
  //   );
  // }

  //Italics
  static Widget txtViewItalics(String text, Color color, double size) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontStyle: FontStyle.italic,
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins'),
    );
  }

  static Widget txtView(String text, Color color, double size) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins'),
    );
  }

  static Widget imageView(String image) {
    return Image.asset(
      image,
      fit: BoxFit.fill,
    );
  }

  static Widget appBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blackLight,
            size: 35,
          ),
        ),
      ),
    );
  }

  static Widget cachedNetworkImage(String? imgUrl,
      {BoxFit? fit,
      double? width,
      double? height,
      String assetImg = ImageConstants.defaultProduct,
      Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
      Widget Function(BuildContext, String, dynamic)? errorWidget,
      Widget Function(BuildContext, String)? placeholder,
      Color? color,
      BlendMode? colorBlendMode}) {
    return imgUrl != null && imgUrl != ""
        ? CachedNetworkImage(
            filterQuality: FilterQuality.medium,
            imageUrl: imgUrl,
            fit: fit ?? BoxFit.fill,
            width: width,
            color: color,
            colorBlendMode: colorBlendMode,
            height: height,
            memCacheWidth: width != null ? (width * 2).toInt() : null,
            memCacheHeight: height != null ? (height * 2).toInt() : null,
            placeholder: placeholder ??
                (context, url) => Image.asset(
                      assetImg,
                      fit: BoxFit.fill,
                      width: width,
                      height: height,
                    ),
            imageBuilder: imageBuilder,
            errorWidget: errorWidget ??
                (context, url, error) => Image.asset(
                      assetImg,
                      fit: BoxFit.fill,
                      width: width,
                      height: height,
                    ),
          )
        : Image.asset(
            assetImg,
            fit: BoxFit.fill,
            width: width,
            height: height,
          );
  }

  static Widget loadingIndicator() {
    return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: AppColors.primary,
          ),
        ));
  }

  static Widget circleCachedNetworkImage(String? imgUrl,
      {BoxFit? fit,
      double? width,
      double? height,
      double? radius,
      String assetImg = ImageConstants.defaultProduct,
      Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
      Widget Function(BuildContext, String, dynamic)? errorWidget,
      Widget Function(BuildContext, String)? placeholder,
      Color? color,
      Color? assetColor,
      Color? assetBackgroundColor,
      BlendMode? colorBlendMode}) {
    // Guard against null or empty URL — avoids failed network request and error flash
    if (imgUrl == null || imgUrl.isEmpty) {
      return CircleAvatar(
        radius: radius ?? 25.0,
        backgroundColor: assetBackgroundColor ?? Colors.transparent,
        backgroundImage: AssetImage(assetImg),
      );
    }
    return CachedNetworkImage(
      filterQuality: FilterQuality.medium,
      imageUrl: imgUrl,
      // Prefer explicit width/height at 2× pixel density when provided.
      // Fall back to diameter (radius × 2) at 2× only when no explicit size is given.
      // This avoids distortion when the source image is non-square.
      memCacheWidth: width != null ? (width * 2).toInt() : (radius != null ? (radius * 4).toInt() : null),
      memCacheHeight: height != null ? (height * 2).toInt() : (radius != null ? (radius * 4).toInt() : null),
      fit: fit ?? BoxFit.fill,
      width: width,
      color: color,
      colorBlendMode: colorBlendMode,
      height: height,
      placeholder: placeholder ??
          (context, url) => CircleAvatar(
                radius: radius ?? 25.0,
                backgroundColor: assetBackgroundColor ?? Colors.transparent,
                backgroundImage: AssetImage(
                  assetImg,
                ),
              ),
      imageBuilder: imageBuilder ??
          (context, imageProvider) {
            return CircleAvatar(
              radius: radius ?? 25.0,
              backgroundColor: Colors.transparent,
              backgroundImage: imageProvider,
            );
          },
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius ?? 25.0,
        backgroundColor: assetBackgroundColor ?? Colors.transparent,
        backgroundImage: AssetImage(assetImg),
      ),
    );
  }

  static UnderlineInputBorder underlineInputBorder(
      {double? borderRadius, Color? color}) {
    return UnderlineInputBorder(

        borderSide: BorderSide(
          width: 1.0,
          color: color ?? AppColors.primary,
        ));
  }

  static OutlineInputBorder outlineInputBorder(
      {double? borderRadius, Color? color}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
        borderSide: BorderSide(
          width: 1.0,
          color: color ?? AppColors.primary,
        ));
  }


}
