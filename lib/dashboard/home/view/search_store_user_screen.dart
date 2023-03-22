import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/favourite_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/filter_option_screen.dart';
import 'package:thegreenmall/dashboard/home/view/nearby_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/previous_store_list_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class SearchStoreUserScreen extends StatefulWidget {
  const SearchStoreUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchStoreUserScreen> createState() => _SearchStoreUserScreenState();
}

class _SearchStoreUserScreenState extends State<SearchStoreUserScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

  var kGoogleApiKey = "AIzaSyApn9TIiD-soa2XRoqHvaZTLMY0zT7o-7Y";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    fetchCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => Text(
                                      "Hi, "
                                      "${searchStoreUserController.firstName!.value} ${searchStoreUserController.lastName!.value}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Text(
                                  StringConstants.searchForStoreText,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                ],
              )),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: WidgetConstants.screenWidth,
                color: AppColors.primarylight,
              ),
              Positioned(
                top: 30,
                child: Stack(
                  children: [
                    Container(
                      color: AppColors.greenlight,
                      height: 800,
                      width: WidgetConstants.screenWidth,
                      // child:
                      // GoogleMap(
                      //   mapType: MapType.normal,
                      //   initialCameraPosition: _kGooglePlex,
                      //   onMapCreated: (GoogleMapController controller) {
                      //     _controller.complete(controller);
                      //   },
                      // )
                    ),
                    Positioned(
                        top: 170,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            Get.to(const FilterOptionScreen());
                          },
                          child: Image.asset(
                            "assets/filterbutton.png",
                            scale: 3,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: InkWell(
                  onTap: () async {
                    Prediction? p = await PlacesAutocomplete.show(
                        offset: 0,
                        radius: 1000,
                        types: [],
                        strictbounds: false,
                        region: "ar",
                        context: context,
                        apiKey: kGoogleApiKey,
                        mode: Mode.overlay,
                        // Mode.fullscreen
                        language: "en",
                        components: [Component(Component.country, "in")]);
                    GeoData addresses = await Geocoder2.getDataFromAddress(
                        address: p?.description.toString()??'',
                        googleMapApiKey: kGoogleApiKey);
                    updateMap(addresses.latitude, addresses.longitude);
                  },
                  child: TextFormField(
                      enabled: false,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        prefixIcon: Image.asset(
                          "assets/search.png",
                          scale: 4,
                        ),
                        hintText: StringConstants.searchText,
                        hintStyle: const TextStyle(color: AppColors.grey),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
          TabBar(
            unselectedLabelColor: AppColors.blacklight,
            labelColor: AppColors.primary,
            tabs: [
              Tab(
                child: Text(
                  StringConstants.nearbyText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  StringConstants.previousText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  StringConstants.favoriteText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: NearbyStoreListScreen()),
                Center(child: PreviousStoreListScreen()),
                Center(child: FavouriteStoreListScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateMap(lat, lng) async {
    CameraPosition kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 0.0,
        zoom: 14.15);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void fetchCurrentLocation() async {
    Position currentLocation = await _determinePosition();
    updateMap(currentLocation.latitude, currentLocation.longitude);
  }
}
