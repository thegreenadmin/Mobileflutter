import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/favourite_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/filter_option_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/nearby_store_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_store_list_screen.dart';
import 'package:thegreenmall/utils/google_place_autocompleted.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

class SearchStoreUserScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  const SearchStoreUserScreen({Key? key, this.firstName, this.lastName}) : super(key: key);

  @override
  State<SearchStoreUserScreen> createState() => _SearchStoreUserScreenState();
}

class _SearchStoreUserScreenState extends State<SearchStoreUserScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver, GlobalVarMixin{
  TabController? _tabController;
  // Tracks the last tab index that a guest is allowed to be on (always 0).
  int _lastAllowedTabIndex = 0;
  SearchStoreUserController searchStoreUserController =
  Get.isRegistered<SearchStoreUserController>()
      ? Get.find<SearchStoreUserController>()
      : Get.put(SearchStoreUserController());
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
        initialIndex: searchStoreUserController.initialIndex.value,
        length: 3,
        vsync: this);

    searchStoreUserController.miles.value = "50";
    searchStoreUserController.clearNearbyPArms();
    searchStoreUserController.updateCurrentLocation();
    searchStoreUserController.apiActiveCartApi();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await permission.Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildLocation(),
                buildGoogleMap(),
                buildTabBar(),
                buildTabBarView(),
              ],
            ),
            //LOADING OVERLAY
            Obx(() {
              return searchStoreUserController.isLoading.value
                  ? Container(
                color: Colors.black.withValues(alpha: 0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),)
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Expanded buildTabBarView() {
    return Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children:  [
                    NearbyStoreListScreen(),
                    PreviousStoreListScreen(),
                    FavouriteStoreListScreen(),
                  ],
                ),
              );
  }

  SizedBox buildTabBar() {
    return SizedBox(
                width: WidgetConstants.screenWidth,
                height: 40,
                child: TabBar(
                  unselectedLabelColor: AppColors.blackLight,
                  labelColor: AppColors.primary,
                  indicatorColor: AppColors.primary,
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  isScrollable: false,
                  onTap: (i) async {
                    // Flutter calls animateTo(i) before onTap fires, so
                    // _tabController!.index is already i at this point.
                    // We counter-animate back to _lastAllowedTabIndex instead.
                    if (isGuest.value == true && (i == 1 || i == 2)) {
                      _tabController?.animateTo(_lastAllowedTabIndex);
                      GuestAccessModal.show(
                        title: "Login Required",
                        message: "Please login to access Previous and Favorite stores",
                      );
                      return;
                    }

                    _lastAllowedTabIndex = i;
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
                    searchStoreUserController.miles.value = "50";
                    if (i == 0 &&
                        searchStoreUserController.isClicked.value == false) {
                      searchStoreUserController.placeId.value = "";
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
              );
  }

  Stack buildGoogleMap() {
    return Stack(
                children: [
                  Container(
                    height: WidgetConstants.screenHeight * 0.3, //250,
                    width: WidgetConstants.screenWidth,
                    color: AppColors.primaryLight,
                  ),
                  Positioned(
                    top: 25,
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
                              initialCameraPosition:
                                  searchStoreUserController.kGooglePlex,
                              markers: Set<Marker>.of(
                                  searchStoreUserController.markers.values),
                              onMapCreated: (GoogleMapController controller) {
                                searchStoreUserController.googleMapController =
                                    Completer();
                                searchStoreUserController.googleMapController
                                    .complete(controller);

                                // if (!searchStoreUserController
                                //     .googleMapController.isCompleted) {
                                //   searchStoreUserController.googleMapController
                                //       .complete(controller);
                                // }
                              },
                            )),
                        Positioned(
                            top: WidgetConstants.screenHeight * 0.22,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                                searchController.clear();
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
                  Positioned(
                    top: 0,
                    left: 18,
                    right: 18,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5, // cap to 300 if enough room
                      ),
                      child: GooglePlaceAutocompleteField(
                        apiKey: searchStoreUserController.kGoogleApiKey,
                           validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterAddressText;
                                        }
                                        return null;
                                      },
                        controller: searchController,
                        onPlaceSelected: (Place place) {

                          final components = place.addressComponents ?? [];

                          String? getComponent(String type) {
                            return components
                                .firstWhere((c) => c.types.contains(type), orElse: () => AddressComponent( name: '', shortName: '', types: []))
                                .name;
                          }

                          searchStoreUserController.city.value =
                              getComponent('locality') ?? '';

                          searchStoreUserController.country.value =
                              getComponent('country') ?? '';

                          searchStoreUserController.state.value =
                              getComponent('administrative_area_level_1') ?? '';

                          searchStoreUserController.zipCodeTextController.text =
                              getComponent('postal_code') ?? '';
                          searchStoreUserController.placeId.value =
                              place.id.toString() ?? "";
                          searchStoreUserController.lat.value = place.latLng?.lat??0.0;
                          searchStoreUserController.lng.value =place.latLng?.lat??0.0;
                          searchStoreUserController.updateMap(place.latLng?.lat??0.0,
                              place.latLng?.lng??0.0,isSearchVal: true);
                        },
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
                              searchController.clear();
                              searchStoreUserController.clearNearbyPArms();
                              searchStoreUserController.updateCurrentLocation();
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
                        ),
                        textStyle: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                 /* Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                    child: GooglePlaceAutocompleteField(
                      apiKey: searchStoreUserController.kGoogleApiKey,
                      *//*   validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterAddressText;
                                        }
                                        return null;
                                      },*//*
                      controller: searchController,
                      onPlaceSelected: (Place place) {

                        final components = place.addressComponents ?? [];

                        String? getComponent(String type) {
                          return components
                              .firstWhere((c) => c.types.contains(type), orElse: () => AddressComponent( name: '', shortName: '', types: []))
                              .name;
                        }

                        searchStoreUserController.city.value =
                            getComponent('locality') ?? '';

                        searchStoreUserController.country.value =
                            getComponent('country') ?? '';

                        searchStoreUserController.state.value =
                            getComponent('administrative_area_level_1') ?? '';

                        searchStoreUserController.zipCodeTextController.text =
                            getComponent('postal_code') ?? '';
                        searchStoreUserController.placeId.value =
                            place.id.toString() ?? "";
                        searchStoreUserController.lat.value = place.latLng?.lat??0.0;
                        searchStoreUserController.lng.value =place.latLng?.lat??0.0;
                        searchStoreUserController.updateMap(place.latLng?.lat??0.0,
                            place.latLng?.lng??0.0,isSearchVal: true);
                      },
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
                              searchController.clear();
                              searchStoreUserController.clearNearbyPArms();
                              searchStoreUserController.updateCurrentLocation();
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
                        ),
                      textStyle: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),*/

                  /*Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          Prediction? p = await PlacesAutocomplete.show(
                              offset: 0,
                              radius: 1000,
                              types: [],
                              strictbounds: false,
                              context: context,
                              apiKey: searchStoreUserController.kGoogleApiKey,
                              mode: Mode.overlay,
                              language: "en",
                              components: []);
                          searchStoreUserController.searchController.text =
                              p?.description!.toString() ?? "";
                          ///ADDRESSES BY GEOCODING
                          searchStoreUserController.placeId.value =
                              p?.placeId.toString() ?? "";
                          final geocoding = GoogleMapsGeocoding(
                              apiKey: searchStoreUserController.kGoogleApiKey);
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
                            // print("ADDRESSES BY GEOCODING:------------------");
                            // print(response.results.first.geometry.location.lat);
                            // print(response.results.first.geometry.location.lng);

                            searchStoreUserController.lat.value = response.results.first.geometry.location.lat;
                            searchStoreUserController.lng.value = response.results.first.geometry.location.lng;
                            searchStoreUserController.updateMap(response.results.first.geometry.location.lat,
                                response.results.first.geometry.location.lng,isSearchVal: true);
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
                              searchStoreUserController.clearNearbyPArms();
                              searchStoreUserController.updateCurrentLocation();
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
                  ),*/
                ],
              );
  }

  Container buildLocation() {
    return Container(
                height: 135,
                color: AppColors.primaryLight,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, top: 55, bottom: 0),
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

                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                  width8SizedBox,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                   Text(
                                              'Hi, ${widget.firstName ??""} ${widget.lastName}',
                                              overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600),
                                        ),

                                      Text(
                                        StringConstants.searchForStoreText,
                                        style: const TextStyle(
                                            fontSize: 16,
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

                                                    // Get.parameters["storeId"] =
                                                    //     searchStoreUserController
                                                    //         .storeIdValue.value;
                                                    await Get.to(() => CartScreen(storeId: searchStoreUserController
                                                        .storeIdValue.value,),
                                                        id: pageIdApp.value)
                                                        ?.then((value) {
                                                      searchStoreUserController
                                                          .apiActiveCartApi();

                                                    });

                                                  },
                                                  child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 18.0,
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
                                                                    .cartCount.value
                                                                    .toString(),
                                                                style:
                                                                const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 8,
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
                        height4SizedBox,
                        Obx(() => Text(
                          searchStoreUserController.miles.value != ""
                              ? "Nearby stores are shown from ${searchStoreUserController.miles.value} miles radius"
                              : StringConstants.nearByLabelForMilesText,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.black),
                        )),
                        height4SizedBox,
                      ],
                    )),
              );
  }

}
