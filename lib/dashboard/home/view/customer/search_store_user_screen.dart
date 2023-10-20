import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/geocoding.dart";
import "package:google_maps_webservice/places.dart";
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/favourite_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/filter_option_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/nearby_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_store_list_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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

  var kGoogleApiKey = "";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    // zoom: 14.4746,
    zoom: 50.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    searchStoreUserController.searchController.clear();
    _tabController = TabController(
        initialIndex: searchStoreUserController.initialIndex.value,
        length: 3,
        vsync: this);

    updateCurrentLocation();
    searchStoreUserController.apiActiveCartApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.158),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 50, bottom: 0),
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
                                Get.back(id: pageIdApp.value);

                                Get.delete<SearchStoreUserController>();
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
                                Obx(
                                  () => Text(
                                    'Hi, ${searchStoreUserController.firstName?.value} ${searchStoreUserController.lastName?.value}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
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
                        Row(
                          children: [
                            Obx(
                              () => Visibility(
                                visible:
                                    searchStoreUserController.cartCount.value !=
                                        0,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Get.to(
                                                      () => const CartScreen(),
                                                      id: pageIdApp.value)
                                                  ?.then((value) =>
                                                      searchStoreUserController
                                                          .apiActiveCartApi());
                                              Get.parameters["storeId"] =
                                                  searchStoreUserController
                                                      .storeIdValue.value;
                                            },
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor: Colors.white,
                                                  child: Image.asset(
                                                      ImageConstants.cart,
                                                      height: 16),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.5),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 15,
                                                        minHeight: 15,
                                                      ),
                                                      child: Obx(
                                                        () => Text(
                                                          searchStoreUserController
                                                              .cartItems.length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Image.asset(
                              ImageConstants.homeMall,
                              scale: 4,
                            ),
                          ],
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
                height: WidgetConstants.screenHeight * 0.3, //250,
                width: WidgetConstants.screenWidth,
                color: AppColors.primarylight,
              ),
              Positioned(
                top: 30,
                child: Stack(
                  children: [
                    SizedBox(
                        height: WidgetConstants.screenHeight * 0.3, //250,
                        width: WidgetConstants.screenWidth,
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          zoomControlsEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          initialCameraPosition: _kGooglePlex,
                          markers: Set<Marker>.of(markers.values),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        )),
                    Positioned(
                        top: 170,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            searchStoreUserController.searchController.clear();
                            await Get.to(() => const FilterOptionScreen(),
                                id: pageIdApp.value);
                          },
                          child: Image.asset(
                            ImageConstants.filterbutton,
                            scale: 3,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 1),
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTap: () async {
                      Prediction? p = await PlacesAutocomplete.show(
                          offset: 0,
                          radius: 1000,
                          types: [],
                          strictbounds: false,
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay,
                          language: "en",
                          components: []);
                      searchStoreUserController.searchController.text =
                          p?.description!.toString() ?? "";

                      ///ADDRESSES BY GEOCODING
                      searchStoreUserController.placeId.value =
                          p?.placeId.toString() ?? "";
                      final geocoding =
                          GoogleMapsGeocoding(apiKey: kGoogleApiKey);
                      GeocodingResponse response = await geocoding
                          .searchByAddress(p?.description.toString() ?? "");
                      final result = response.results.isNotEmpty
                          ? response.results.first
                          : null;
                      if (result != null) {
                        searchStoreUserController.city.value =
                            Utility.extractLocality(result, "locality");
                        searchStoreUserController.country.value =
                            Utility.extractLocality(result, "country");
                        searchStoreUserController.zipCodeTextController.text =
                            Utility.extractLocality(result, "postal_code");
                        searchStoreUserController.state.value =
                            Utility.extractLocality(
                                result, "administrative_area_level_1");
                        updateMap(response.results.first.geometry.location.lat,
                            response.results.first.geometry.location.lng);
                      }
                    },
                    controller: searchStoreUserController.searchController,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      prefixIcon: Image.asset(
                        ImageConstants.search,
                        color: AppColors.grey,
                        scale: 4,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          searchStoreUserController.searchController.clear();
                        },
                        child: Image.asset(
                          ImageConstants.cross,
                          scale: 4,
                        ),
                      ),
                      focusColor: AppColors.grey,
                      hintText: StringConstants.searchText,
                      hintStyle: const TextStyle(color: AppColors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            width: WidgetConstants.screenWidth,
            height: 40,
            child: TabBar(
              unselectedLabelColor: AppColors.blacklight,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w400),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              isScrollable: false,
              onTap: (i) async {
                searchStoreUserController.storeAddresses.clear();
                searchStoreUserController.previousStore.clear();
                searchStoreUserController.favouriteStore.clear();
                searchStoreUserController.page.value = 1;
                searchStoreUserController.type.value = i;
                searchStoreUserController.totalCount.value = 0;
                Get.parameters["isFromHome"] = "true";
                Get.parameters["isFromFav"] = "false";
                Get.parameters["isFromMenu"] = "false";
                Get.parameters["isFromOptions"] = "false";
                if (i == 0 &&
                    searchStoreUserController.isClicked.value == false) {
                  await searchStoreUserController.apiGetNearByStores();
                } else if (i == 1 &&
                    searchStoreUserController.isClicked.value == false) {
                  await searchStoreUserController.apiGetPreviousStores();
                } else if (i == 2 &&
                    searchStoreUserController.isClicked.value == false) {
                  await searchStoreUserController.apiGetFavoriteStores();
                }
              },
              tabs: [
                Tab(
                  child: Text(
                    StringConstants.nearbyText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Tab(
                  child: Text(
                    StringConstants.previousText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Tab(
                  child: Text(
                    StringConstants.favoriteText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
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
    searchStoreUserController.lat = lat;
    searchStoreUserController.lng = lng;
    searchStoreUserController.type.value = 0;
    // Get.back();
    await searchStoreUserController.apiGetNearByStores(isSearch: true);
    updateMarker(lat, lng);
  }

  void updateMarker(latitude, longitude) async {
    const MarkerId markerId = MarkerId("12345");
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageConstants.marker, 60);
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: LatLng(latitude, longitude),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  late GlobalConfigs secureData;

  void updateCurrentLocation() async {
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   Get.dialog(
    //       const Center(
    //           child: CircularProgressIndicator(color: AppColors.primary)),
    //       barrierDismissible: false);
    // });
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];
    Position currentLocation = await Utility.fetchCurrentLocation();

    updateMap(currentLocation.latitude, currentLocation.longitude);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
