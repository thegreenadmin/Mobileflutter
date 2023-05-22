import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/nearby_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/filter_option_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

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
    searchStoreUserController.apiActiveCartApi(Get.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.14),
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
                                // Get.back();
                                Navigator.of(context).pop();
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
                                        fontWeight: FontWeight.w400),
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
                                //      ||
                                // storeHomeMainController
                                //     .productDetailResponse
                                //     .value
                                //     .data!
                                //     .product!
                                //     .cartItems!
                                //     .isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              SharedPreferenceStorage.setData(
                                                  "context", context);
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const CartScreen(),
                                                  ))
                                                  .then((value) =>
                                                      searchStoreUserController
                                                          .apiActiveCartApi(
                                                              context));
                                              Get.parameters["storeId"] =
                                                  searchStoreUserController
                                                      .storeIdValue.value;
                                              // searchStoreUserController
                                              //     .apiGetUserWalletBalance();
                                              // SharedPreferenceStorage.setData(
                                              //     "context", context);
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (_) =>
                                              //       const CartScreen(),
                                              // ));
                                              // Get.to(() => const CartScreen());
                                            },
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 22.0,
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
                height: 250,
                width: WidgetConstants.screenWidth,
                color: AppColors.primarylight,
              ),
              Positioned(
                top: 30,
                child: Stack(
                  children: [
                    SizedBox(
                        height: 250,
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
                          onTap: () {
                            searchStoreUserController.searchController.clear();
                            SharedPreferenceStorage.setData("context", context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const FilterOptionScreen(),
                            ));
                            // Get.to(const FilterOptionScreen());
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
                      GeoData addresses = await Geocoder2.getDataFromAddress(
                          address: p?.description.toString() ?? "",
                          googleMapApiKey: kGoogleApiKey);
                      searchStoreUserController.zipCodeTextController.text =
                          addresses.postalCode;
                      updateMap(addresses.latitude, addresses.longitude);
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
          TabBar(
            unselectedLabelColor: AppColors.blacklight,
            labelColor: AppColors.primary,
            onTap: (i) {
              searchStoreUserController.storeAddresses.clear();
              searchStoreUserController.page.value = 1;
              searchStoreUserController.type.value = i;
              searchStoreUserController.apiGetNearByStores(context);
            },
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
                Center(child: NearbyStoreListScreen()),
                Center(child: NearbyStoreListScreen()),
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
    await searchStoreUserController.apiGetNearByStores(context);
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

        // Prediction? p = await PlacesAutocomplete.show(
        //                       offset: 0,
        //                       radius: 1000,
        //                       types: [],
        //                       strictbounds: false,
        //                       context: context,
        //                       apiKey: accountController.kGoogleApiKey,
        //                       mode: Mode.overlay,
        //                       language: "en",
        //                       components: []);
        //                   int idx = p!.description!.indexOf(",");
        //                   List parts = [
        //                     p.description!.substring(0, idx).trim(),
        //                     p.description!.substring(idx + 1).trim()
        //                   ];
        //                   accountController.addressLine1TextController.text =
        //                       parts[0].toString();
        //                   GeoData addresses = await Geocoder2.getDataFromAddress(
        //                       address: p.description.toString(),
        //                       googleMapApiKey: accountController.kGoogleApiKey);