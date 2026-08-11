import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import "package:google_maps_webservice/geocoding.dart";
import 'package:intl/intl.dart';
import 'package:thegreenmall/dashboard/home/model/get_user_detail_model.dart';
import 'package:thegreenmall/utils/app_logger.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class Utility {

  static bool _isDialogShowing = false;

  static void showMessage(String title, String message) {
    Get.snackbar(title, message,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.primary);
  }

  static void showTopMessage(String title, String message) {
    Get.snackbar(title, message,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.primary);
  }

  static void showToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        fontSize: 14.0);
  }

  static void showSuccessMessage(String title, String message) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM);
  }

  static String loadImageUrl(String url) {
    return ServerCommunicator.baseUrlWithoutV1 + url;
  }

  /// Guards against the 401 redirect storm. Many requests fire concurrently,
  /// so when a session goes bad they all 401 at once. Without this flag each
  /// one calls Get.offAll(StartJourneyScreen), producing the repeated
  /// StartJourney→StartJourney navigation loop. Only the first 401 redirects;
  /// the rest no-op until a new session is established (see
  /// [resetUnauthorizedGuard], called on successful login).
  static bool _isHandlingUnauthorized = false;

  /// Handle 401 unauthorized errors - skip redirect for guest users
  static void handle401Error() {
    // Skip redirect for guest users by checking reactive variable
    if (isGuest.value == true) {
      return;
    }
    // Suppress concurrent/duplicate 401s so we redirect to login only once.
    if (_isHandlingUnauthorized) {
      return;
    }
    _isHandlingUnauthorized = true;
    // Redirect to login for authenticated users
    Get.offAll(() => const StartJourneyScreen());
  }

  /// Re-arm 401 handling once a new session exists (e.g. after a successful
  /// login), so a future genuine session expiry can redirect again.
  static void resetUnauthorizedGuard() {
    _isHandlingUnauthorized = false;
  }

  static void showConfirmAlertMessage(title,
      {String description = "",
      String? cancelText,
      String? okay,
      Function()? okayTap,
      Function()? cancelTap}) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              Center(
                child: Image.asset(
                  ImageConstants.alert48,
                  color: AppColors.red,
                  // scale: 1.5,
                ),
              ),
              height12SizedBox,
              Text(
                title,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              Visibility(
                visible: description != "",
                child: Column(
                  children: [
                    height15SizedBox,
                    Text(
                      description,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              height25SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      cancelTap ?? Get.back();
                    },
                    child: Container(
                      height: WidgetConstants.screenHeight * 0.08,
                      width: WidgetConstants.screenWidth * 0.28,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          cancelText ?? StringConstants.cancelText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  width8SizedBox,
                  InkWell(
                    onTap: () {
                      okayTap!() ?? Get.back();
                    },
                    child: Container(
                      height: WidgetConstants.screenHeight * 0.08,
                      width: WidgetConstants.screenWidth * 0.28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          okay ?? StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const <Widget>[],
      ),
    );
  }

  Future<UserDetailData?> getUserData() async {
    final dynamic storedData = await SharedPreferenceStorage.getData("userData");

    if (storedData == null) {
      return null;
    }

    if (storedData is Map<String, dynamic>) {
      return UserDetailData.fromJson(storedData);
    } else if (storedData is UserDetailData) {
      return storedData;
    }

    return null; // Fallback in case the type is unexpected
  }

  static void showAlertMessage(
    description, {
    String? title,
    String? cancelText,
    String? okay,
    Color? color,
    void Function()? okayTap,
    void Function()? cancelTap,
  }) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            height10SizedBox,
            Image.asset(
              ImageConstants.alert48,
              color: color ?? AppColors.red,
              // scale: 1.5,
            ),
            height12SizedBox,
            Visibility(
              visible: title != null,
              child: Text(
                title ?? "",
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ),
            title != null ? height15SizedBox : height0SizedBox,
            Text(
              description ?? "",
              style: TextStyle(
                  color: AppColors.blackLight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            height25SizedBox,
            InkWell(
              onTap: () {
                _isDialogShowing = false;
                okayTap ?? Get.back();
                // isLoadingValue ? true : false;
              },
              child: Container(
                height: 50.0,
                width: WidgetConstants.screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    okay ?? StringConstants.okayText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  static showAlert(
    String title,
    String message,
    String buttonText,
  ) async {
    return await Get.dialog(AlertDialog(
      title: Text(
        StringConstants.alertText,
        style: const TextStyle(color: AppColors.primary, fontSize: 20),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 18,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              child: Text(buttonText),
              onPressed: () => Get.back(result: true),
              // ** result: returns this value up the call stack **
            ),
          ],
        ),
      ],
    ));
  }

  static String parseDateTime(DateTime timestamp,
      {String format = 'MMM d, h:mm a', required String secFormat}) {
    final dateTime = timestamp.toLocal();
    return DateFormat(format).format(dateTime).toString();
  }

  static String formatDateTime(String timestamp,
      {String firstFormat = 'MMM d, h:mm a',
      secFormat = 'yyyy-MM-dd hh:mm:ss'}) {
    DateTime parseDate = DateFormat(firstFormat).parse(timestamp.toString());
    var inputDate = DateTime.parse(parseDate.toString()).toLocal();
    var outputFormat = DateFormat(secFormat);
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  // ---------------------------------------------------------------------------
  // In-process location cache — survives controller recreation (Get.delete/put).
  // Eliminates the 1-2 second GPS cold-start on every store navigation.
  // ---------------------------------------------------------------------------
  static Position? _cachedPosition;
  static Stopwatch? _cacheStopwatch; // monotonic clock — immune to system-time changes
  static const Duration _cacheMaxAge = Duration(minutes: 3);

  // Completer-based lock: non-null while a background refresh is in flight.
  // All callers that arrive while a refresh is running share the SAME Completer
  // future, guaranteeing exactly one GPS request regardless of how many
  // controllers call _refreshLocationCache() simultaneously.
  static Completer<void>? _refreshCompleter;

  /// Returns a position immediately if the in-process cache is fresh, otherwise
  /// waits for GPS. After returning, refreshes the cache in the background so
  /// the *next* navigation is instant too.
  static Future<Position> fetchCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // 1. Return in-process cache immediately if fresh.
    //    Uses a Stopwatch (monotonic) so device-clock changes don't corrupt the age.
    if (_cachedPosition != null &&
        _cacheStopwatch != null &&
        _cacheStopwatch!.elapsed <= _cacheMaxAge) {
      _refreshLocationCache(); // warm next fix in background — idempotent
      return _cachedPosition!;
    }

    // 2. Fall back to OS last-known position (usually instant).
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      final osAge = DateTime.now().difference(lastKnown.timestamp);
      if (osAge <= _cacheMaxAge) {
        _updateCache(lastKnown);
        _refreshLocationCache(); // warm fresh fix in background
        return lastKnown;
      }
    }

    // 3. No usable cache — must await a fresh GPS fix.
    try {
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
      );
      _updateCache(position);
      return position;
    } catch (e) {
      if (lastKnown != null) return lastKnown;
      return Future.error(e.toString());
    }
  }

  /// Writes a position into the cache and resets the monotonic stopwatch.
  static void _updateCache(Position position) {
    _cachedPosition = position;
    _cacheStopwatch = Stopwatch()..start();
  }

  /// Silently fetches a fresh GPS fix in the background.
  ///
  /// Uses a [Completer]-based lock: if a refresh is already in flight, this
  /// call is a no-op — the existing Completer already owns the GPS request.
  /// The Completer is completed (and nulled) only after the GPS Future fully
  /// resolves, so no second caller can slip past the guard mid-flight.
  static void _refreshLocationCache() {
    if (_refreshCompleter != null) return; // already in flight — skip
    _refreshCompleter = Completer<void>();

    Geolocator.getCurrentPosition(
      timeLimit: const Duration(seconds: 15),
    )
    // Outer timeout: defense-in-depth in case the Geolocator plugin's
    // internal timeLimit doesn't fire (e.g. plugin bug or frozen GPS stack).
    // Ensures _refreshCompleter is always cleared within 20 seconds.
    .timeout(
      const Duration(seconds: 20),
      onTimeout: () => throw TimeoutException('Location refresh timed out'),
    )
    .then((pos) {
      _updateCache(pos);
      AppLogger.debug('Location cache refreshed in background: '
          '${pos.latitude}, ${pos.longitude}');
    }).catchError((Object error) {
      // Stale cache is acceptable — the next foreground call will retry.
      // Log so developers can diagnose persistent GPS failures.
      AppLogger.warning(
          'Background location refresh failed: $error. '
          'Stale cache will be used until next foreground fetch.');
    }).whenComplete(() {
      _refreshCompleter!.complete(); // signal completion
      _refreshCompleter = null;      // release lock for next refresh cycle
    });
  }

  static alertDialog(context,
      {String title = "",
      String description = "",
      String ok = "",
      String cancel = "",
      Function()? onOk,
      void Function()? onCancel}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 20),
          ),
          content: Text(description,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  fontSize: 20)),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  onOk ?? Get.back();
                },
                child: Text(ok)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                onCancel ?? Get.back();
              },
              child: Text(cancel),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSelectionMediaDialog(BuildContext context,
      {void Function()? onGalleryClick, void Function()? onCameraClick}) {
    return showDialog(
        context: context,
        builder: (BuildContext contextt) {
          return AlertDialog(
              icon: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.back();
                    // Navigator.pop(contextt);
                  },
                  child: const Icon(
                    Icons.clear,
                    color: AppColors.primary,
                    size: 24.0,
                  ),
                ),
              ),
              title: Text(
                StringConstants.fromWherePhotoText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_sharp,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          Text(StringConstants.galleryText,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        onGalleryClick!();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          Text(StringConstants.cameraText,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        onCameraClick!();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  static String extractLocality(GeocodingResult result, String typeData,
      {bool isShortName = false}) {
    for (final component in result.addressComponents) {
      for (final type in component.types) {
        if (type == typeData) {
          if (isShortName) {
            return component.shortName;
          } else {
            return component.longName;
          }
        }
      }
    }
    return '';
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
