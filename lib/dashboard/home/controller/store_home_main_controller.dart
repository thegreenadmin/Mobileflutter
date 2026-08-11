
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/store_home_main_args.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../../offers/controller/offers_controller.dart';

class StoreHomeMainController extends GetxController  with GlobalVarMixin{

  Rx<StoreDetailsResponse> storeDetailsResponse = StoreDetailsResponse().obs;
  late StoreOffersListResponse offersListResponse = StoreOffersListResponse();
  RxList<Offer> offersList = <Offer>[].obs;
  Rx<Offer> offerObj = Offer().obs;
  late StoreCategoriesListResponse categoriesListResponse =
      StoreCategoriesListResponse();
  RxList<Category> categoriesList = <Category>[].obs;
  Rx<ShopProductDetailResponse> productDetailResponse =
      ShopProductDetailResponse().obs;

  late CartListResponse cartListResponse = CartListResponse();
  RxList<CartItem> cartItems = <CartItem>[].obs;
  Rx<CartListData> cartData = CartListData().obs;
  late FeatureProductListResponse featureProductListResponse =
      FeatureProductListResponse();

  RxList<FeatureProduct> featureProductList = <FeatureProduct>[].obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();
  RxList<UserAddresses> userAddress = <UserAddresses>[].obs;
  Rx<UserAddresses> selectedUserAddress = UserAddresses().obs;

  final OffersController offersController = Get.put(OffersController());
  UserFeaturedProductModel userFeaturedProductModel =
      UserFeaturedProductModel();
  RxList<ProductsList> featuredUserProductList = <ProductsList>[].obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  late PreviousOrdersModel previousOrdersModel = PreviousOrdersModel();
  RxList<PreviousOrdersProducts> previousOrderList =
      <PreviousOrdersProducts>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt currentIndexProducts = 0.obs;
  RxString storeLocation = "".obs;
  RxInt listIndex = 2.obs;
  RxInt cartCount = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxInt invokedIndex = 0.obs;
  RxInt lastSelectedIndex = 0.obs;

  // Guards against re-entrant product taps. The tap handlers await network
  // calls before showing the detail screen; without this guard a second tap
  // (or a double-fired InkWell) during those awaits would advance invokedIndex
  // past the detail screen into build()'s default branch (StoreHomeScreen).
  bool _isOpeningProduct = false;
  RxInt popUpIndex = 1.obs;
  RxInt activeStep = 0.obs;
  RxInt pageId = 0.obs;
  RxInt itemsCount = 1.obs;
  RxDouble walletBalance = 0.0.obs;
  RxString storeDeliveryServiceId = "0".obs;
  RxString userAddressId = "0".obs;
  RxString productId = "".obs;
  RxString categoryId = "".obs;
  RxString categoryName = "".obs;
  RxBool isFromHome = false.obs;
  RxBool isFromFav = false.obs;
  RxBool isFromMenu = false.obs;
  RxBool isFavouriteStore = false.obs;
  RxBool isVerifiedStore = false.obs;
  RxBool isDeleteCartItem = false.obs;
  RxBool isFavouriteProduct = false.obs;
  RxString orderStatus = "".obs;
  RxBool? isInsufficientBalance = false.obs;
  RxBool isValidAddress = false.obs;
  RxBool isOrderDeliverable = false.obs;
  RxString storeIdValue = "0".obs;
  RxBool isLoading = false.obs;
  RxBool showLoading = true.obs;
  bool _isFetchingLocation = false; // guard against concurrent getCurrentLocation calls
  RxBool isPlaceOrder = true.obs;
  RxBool isFromOptions = false.obs;
  RxBool isFromAddProduct = false.obs;
  RxString storeId = "0".obs;
  RxString selectedDeliveryService = "".obs;
  RxString storeAddressId = "".obs;
  RxString? role = "".obs;
  RxDouble cartTotalPrice = 0.0.obs;

  RxList horizontalTabList = [
    StringConstants.storeText,
    StringConstants.menuText,
    StringConstants.favoriteText,
    StringConstants.optionsText,
  ].obs;
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  ActiveCartModel activeCartModel = ActiveCartModel();
  RxList<ProductImage>? productIm = <ProductImage>[].obs;

  bool get hasPrivacyPage => storeDetailsResponse.value.data?.store != null && storeDetailsResponse.value.data!.store!.storePages!.any((element) =>
  element.storePageType == "privacy" &&
      element.storePageContent?.dynamicUrl != null &&
      listIndex.value < 4);
  bool get hasTermsPage => storeDetailsResponse.value.data?.store != null && storeDetailsResponse.value.data!.store!.storePages!
      .any((element) =>
  element.storePageType == "terms" &&
      element.storePageContent?.dynamicUrl != null &&
      listIndex.value < 4);

  String? _lastArgsKey;

  void applyArgs(StoreHomeMainArgs args) {
    final newKey =
        '${args.storeId}_${args.productId}_${args.invokedIndex}_${args.categoryId}';

    // Debug logging
    print("=== APPLY ARGS DEBUG ===");
    print("New storeId from args: ${args.storeId}");
    print("New productId from args: ${args.productId}");
    print("New invokedIndex from args: ${args.invokedIndex}");
    print("Current storeId: ${storeId.value}");
    print("Current productId: ${productId.value}");
    print("Last args key: $_lastArgsKey");
    print("New args key: $newKey");
    print("Is switching stores: ${storeId.value != (args.storeId ?? "0")}");
    print("========================");

    if (_lastArgsKey == newKey) {
      print("Returning early - same args key");
      return;
    }

    _lastArgsKey = newKey;

    final bool isSwitchingStore = storeId.value != (args.storeId ?? "0");

    // Assign new values first
    storeId.value = args.storeId ?? "0";
    invokedIndex.value = args.invokedIndex ?? 0;
    productId.value = args.productId ?? "";
    categoryName.value = args.categoryName ?? "";
    categoryId.value = args.categoryId ?? "";
    isFromHome.value = args.isFromHome ?? false;
    isFromFav.value = args.isFromFav ?? false;
    isFromMenu.value = args.isFromMenu ?? false;
    isFromOptions.value = args.isFromOptions ?? false;

    // Clear old store data if switched (API will be called by handleInitialFlow)
    if (isSwitchingStore) {
      print("Clearing old store data for: ${storeId.value}");
      storeDetailsResponse.value = StoreDetailsResponse();
      listIndex.value = 2;
    }

    // Refresh store details for authenticated users when navigating to store
    if (!isGuest.value && storeId.value.isNotEmpty && storeId.value != "0") {
      getCurrentLocation();
    }
  }


  void handleInitialFlow() {
    print("=== HANDLE INITIAL FLOW DEBUG ===");
    print("storeId: ${storeId.value}");
    print("isGuest: ${isGuest.value}");
    print("isFromMenu: ${isFromMenu.value}");
    print("isFromFav: ${isFromFav.value}");
    print("isFromHome: ${isFromHome.value}");
    print("===================================");

    if (storeId.value.isNotEmpty) {
      getCurrentLocation();
    }

    // Skip JWT-required API calls for guest users, but allow public data
    if (isGuest.value == true) {
      print("Guest user flow");
      if (isFromMenu.value) {
        selectedIndex.value = 1;
        apiGetStoreCategoriesApi();
        if (productId.value.isNotEmpty && productId.value != "0") {
          print("Calling product detail API for guest from menu, productId: ${productId.value}");
          apiGetShopProductDetailApi();
        }
      } else if (isFromFav.value) {
        selectedIndex.value = 2;
        apiFeatureProductListApi(isFeaturedProduct: true);
        if (productId.value.isNotEmpty && productId.value != "0") {
          print("Calling product detail API for guest from fav, productId: ${productId.value}");
          apiGetShopProductDetailApi();
        }
      } else if (isFromHome.value) {
        selectedIndex.value = 0;
        apiGetStoreOffersApi();
        apiFeatureProductListApi(isFeaturedProduct: true);
        if (productId.value.isNotEmpty && productId.value != "0") {
          print("Calling product detail API for guest from home, productId: ${productId.value}");
          apiGetShopProductDetailApi();
        }
      } else {
        print("No navigation flags set, calling onIndexChange(0)");
        onIndexChange(0);
      }
      return;
    }

    print("Authenticated user flow");
    if (isFromMenu.value) {
      selectedIndex.value = 1;
      apiGetStoreCategoriesApi();
      if (productId.value.isNotEmpty && productId.value != "0") {
        print("Calling product detail API from menu flow, productId: ${productId.value}");
        apiGetShopProductDetailApi();
      }
    } else if (isFromFav.value) {
      selectedIndex.value = 2;
      apiFeatureProductListApi(isFeaturedProduct: true);
      if (productId.value.isNotEmpty && productId.value != "0") {
        print("Calling product detail API from fav flow, productId: ${productId.value}");
        apiGetShopProductDetailApi();
      }
    } else if (isFromHome.value) {
      selectedIndex.value = 0;
      print("Calling store offers and featured products APIs");
      apiGetStoreOffersApi();
      apiFeatureProductListApi(isFeaturedProduct: true);
      if (productId.value.isNotEmpty && productId.value != "0") {
        print("Calling product detail API from home flow, productId: ${productId.value}");
        apiGetShopProductDetailApi();
      }
    } else {
      print("No navigation flags set, calling onIndexChange(0)");
      onIndexChange(0);
    }

    apiGetUserWalletBalance();
  }



  // Loads product detail data then shows the AddToOrder screen by setting
  // invokedIndex to an ABSOLUTE target (never ++), and ignores re-entrant
  // taps while the network calls are in flight. Both prevent invokedIndex
  // from overshooting into build()'s default branch (StoreHomeScreen).
  Future<void> openProductDetail({
    required int targetInvokedIndex,
    required Future<void> Function() loadData,
  }) async {
    if (_isOpeningProduct) return;
    _isOpeningProduct = true;
    // Always reset quantity to 1 when opening a new product so the count
    // from a previously viewed product doesn't carry over.
    itemsCount.value = 1;
    try {
      await loadData();
      invokedIndex.value = targetInvokedIndex;
    } catch (e) {
      Utility.showToast(AlertStringConstants.somethingWentWrongText);
    } finally {
      _isOpeningProduct = false;
    }
  }

  void openProductFromFav(int index) async {
    final product = featureProductList[index];

    productId.value = product.productId.toString();
    Get.parameters['productId'] = productId.value;

    Get.parameters['isFromFav'] = "true";
    Get.parameters["isFromHome"] = "false";
    Get.parameters["isFromMenu"] = "false";
    Get.parameters["isFromOptions"] = "false";

    await openProductDetail(
      targetInvokedIndex: 1,
      // Run all independent calls in parallel (removed duplicate apiGetShopProductDetailApi)
      loadData: () => Future.wait([
        apiGetShopProductDetailApi(),
        apiGetCartListApi(),
        apiGetUserDetailsApi(),
        apiGetUserWalletBalance(),
      ]),
    );
  }



  // --- Params Setup ---
  void _initializeParams() {
    storeId.value = Get.parameters["storeId"] ?? "";
    productId.value = Get.parameters["productId"] ?? "";
    invokedIndex.value = int.tryParse(Get.parameters["invokedIndex"] ?? "0") ?? 0;
    isFromHome.value = Get.parameters["isFromHome"] == "true";
    isFromFav.value = Get.parameters["isFromFav"] == "true";
    isFromMenu.value = Get.parameters["isFromMenu"] == "true";
    isFromOptions.value = Get.parameters["isFromOptions"] == "true";
  }

  // --- Initial Data Load ---
  Future<void> _loadInitialData() async {
    print("=== LOAD INITIAL DATA DEBUG ===");
    print("isGuest: ${isGuest.value}");
    print("isFromMenu: ${isFromMenu.value}");
    print("isFromHome: ${isFromHome.value}");
    print("isFromFav: ${isFromFav.value}");
    print("productId: ${productId.value}");
    print("storeId: ${storeId.value}");
    print("_hasStore: $_hasStore");
    print("invokedIndex: ${invokedIndex.value}");
    print("=============================");

    // For guest users, load only public data (skip user-specific data)
    if (isGuest.value == true) {
      if (isFromAddProduct.value) {
        selectedIndex.value = 0;
        lastSelectedIndex.value = 0;
      }
      // Respect navigation flags for guests, same as handleInitialFlow
      try {
        if (isFromMenu.value) {
          selectedIndex.value = 1;
          if (_hasStore) {
            await getCurrentLocation();
            await apiGetStoreDetailsApi();
            await apiGetStoreCategoriesApi();
            if (productId.value.isNotEmpty && productId.value != "0") {
              print("Calling product detail API for guest from menu");
              await apiGetShopProductDetailApi();
            }
          }
        } else if (isFromFav.value) {
          selectedIndex.value = 2;
          if (_hasStore) {
            await getCurrentLocation();
            await apiGetStoreDetailsApi();
            await apiFeatureProductListApi(isFeaturedProduct: true);
          }
        } else if (isFromHome.value) {
          selectedIndex.value = 0;
          if (_hasStore) {
            await getCurrentLocation();
            await apiGetStoreDetailsApi();
            await apiGetStoreOffersApi();
            await apiFeatureProductListApi(isFeaturedProduct: true);
            if (productId.value.isNotEmpty && productId.value != "0") {
              print("Calling product detail API for guest from home");
              await apiGetShopProductDetailApi();
            }
          }
        } else {
          // Default: load store home tab
          selectedIndex.value = 0;
          if (_hasStore) {
            await getCurrentLocation();
            await apiGetStoreDetailsApi();
            await apiGetStoreOffersApi();
            await apiFeatureProductListApi(isFeaturedProduct: true);
          }
        }
      } catch (e) {
        // Log error for debugging but don't crash the app
        print('Error loading initial data for guest user: $e');
      }
      return;
    }
    if (isFromAddProduct.value) {
      selectedIndex.value = 0;
      lastSelectedIndex.value = 0;
    }
    showLoading.value = true;

    if (_hasStore) {
      await getCurrentLocation();
    }

    await apiGetUserDetailsApi();

    if (_hasStore) {
      print("Calling product detail API for authenticated user");
      await apiGetShopProductDetailApi();
    }

    // handle navigation cases
    if (isFromMenu.value) {
      _handleFromMenu();
    } else if (isFromFav.value) {
      await _handleFromFav();
    } else if (isFromHome.value) {
      await _handleFromHome();
    } else if (isFromOptions.value) {
      _handleFromOptions();
    }

    // apiGetUserWalletBalance internally calls apiActiveCartApi() on success,
    // which in turn calls apiGetCartListApi(). No need to call apiActiveCartApi separately.
    await apiGetUserWalletBalance();
  }

  // --- Location ---
  Future<void> getCurrentLocation() async {
    // Prevent concurrent duplicate location fetches (e.g. called from both
    // applyArgs() and handleInitialFlow() in the same frame).
    if (_isFetchingLocation) return;
    _isFetchingLocation = true;
    // Nashville default — used when GPS is unavailable (e.g. simulator, denied
    // service, or a timed-out fix) so store details still load instead of the
    // fetch throwing an unhandled TimeoutException and skipping the call.
    lat = 36.1627;
    lng = -86.7816;
    try {
      try {
        final currentLocation = await Utility.fetchCurrentLocation();
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      } catch (e) {
        print("DEBUG: getCurrentLocation fallback to Nashville: $e");
      }

      if (_hasStore) {
        await apiGetStoreDetailsApi(latitude: lat, longitude: lng);
      }
    } finally {
      _isFetchingLocation = false;
    }
  }

  // --- Index Change ---
  Future<void> onIndexChange(int i) async {
    selectedIndex.value = i;
    lastSelectedIndex.value = i;

    if (invokedIndex.value > 0) {
      invokedIndex.value = 0;
    }

    switch (i) {
      case 0:
        await apiGetStoreOffersApi();
        await apiFeatureProductListApi(isFeaturedProduct: true);
        break;
      case 1:
        await apiGetStoreCategoriesApi();
        if (categoryId.value.isNotEmpty) {
          await apiFeatureProductListApi(categoryId: categoryId.value);
        }
        break;
      case 2:
        await apiFeatureProductListApi(isFavouriteProducts: true);
        break;
      case 3:
        await apiGetPreviousOrders();
        break;
    }
  }

  // --- Popup Menu ---
  Future<void> popUpMenuChange(int i) async {
    popUpIndex.value = i;
    isFromOptions.value = false;

    switch (i) {
      case 0:
        await apiGetPreviousOrders();
        break;
      case 2:
        _checkStorePage("privacy", StringConstants.noPrivacyFoundText);
        break;
      case 3:
        _checkStorePage("terms", StringConstants.noTermsFoundText);
        break;
    }
  }

  // --- Navigation Cases ---
  void _handleFromMenu() {
    selectedIndex.value = 1;
    invokedIndex.value = 2;
    lastSelectedIndex.value = 1;
  }

  Future<void> _handleFromFav() async {
    selectedIndex.value = 2;
    lastSelectedIndex.value = 2;
    showLoading.value = false;
    if (_hasStore) {
      await apiFeatureProductListApi(isFavouriteProducts: true);
    }
  }

  Future<void> _handleFromHome() async {
    selectedIndex.value = 0;
    lastSelectedIndex.value = 0;
    invokedIndex.value = 0;
    showLoading.value = false;
    if (_hasStore) {
      await apiGetStoreOffersApi();
      await apiFeatureProductListApi(isFeaturedProduct: true);
    }
  }

  void _handleFromOptions() {
    selectedIndex.value = 3;
    lastSelectedIndex.value = 3;
    showLoading.value = false;
  }

  // --- Store Page Checks ---
  void _checkStorePage(String type, String noResultMessage) {
    final pages = storeDetailsResponse.value.data?.store?.storePages ?? [];

    final hasPage = pages.any((page) => page.storePageType == type);

    if (!hasPage) {
      Utility.showToast(noResultMessage);
    }
    // Note: Navigation to PDF view is handled reactively in build() based on popUpIndex
  }

  // --- Helpers ---
  bool get _hasStore => storeId.value.isNotEmpty && storeId.value != "0";

  StoreHomeMainController() {
    // Reload store details when user switches from guest to authenticated mode
    ever(isGuest, (bool guestStatus) async {
      if (!guestStatus && _hasStore) {
        // User just logged in from guest mode, reload store details
        await getCurrentLocation();
      }
    });

    // Reload store details when user switches role (e.g., store owner to customer)
    ever(roleApp, (String role) async {
      if (_hasStore) {
        // Role changed, reload store details
        await getCurrentLocation();
      }
    });
  }
/*
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // storeId.value = Get.parameters["storeId"] ?? "";
      // invokedIndex.value = int.parse(Get.parameters["invokedIndex"]??"0");
      // productId.value = Get.parameters["productId"] ?? "";
      // categoryName.value = Get.parameters["categoryName"] ?? "";
      // categoryId.value = Get.parameters["categoryId"] ?? "";
      // isFromHome.value = Get.parameters["isFromHome"] == "true";
      // isFromFav.value = Get.parameters["isFromFav"] == "true";
      // isFromMenu.value = Get.parameters["isFromMenu"] == "true";

      final bool hasStore = storeId.value != "0" && storeId.value != "";

      // Set UI state immediately (no async needed)
      if (isFromMenu.value) {
        selectedIndex.value = 1;
        invokedIndex.value = 2;
        lastSelectedIndex.value = 1;
      } else if (isFromFav.value) {
        selectedIndex.value = 2;
        lastSelectedIndex.value = 2;
        showLoading.value = false;
      } else if (isFromHome.value) {
        selectedIndex.value = 0;
        lastSelectedIndex.value = 0;
        showLoading.value = false;
        invokedIndex.value = 0;
      } else if (isFromOptions.value) {
        selectedIndex.value = 3;
        lastSelectedIndex.value = 3;
        showLoading.value = false;
      }

      // Build parallel API calls based on navigation context
      final List<Future> parallelCalls = [
        apiGetUserDetailsApi(),
        apiGetUserWalletBalance(),
        // NOTE: getCurrentLocation() is already called in updateArgs() when navigating to a store.
        // Calling it here again causes duplicate store/details API requests. Commented out (Fix 1).
        // if (hasStore) getCurrentLocation(),
        if (hasStore) apiGetShopProductDetailApi(),
        if (hasStore && isFromFav.value) apiFeatureProductListApi(isFavouriteProducts: true),
        if (hasStore && isFromHome.value) ...[
          apiGetStoreOffersApi(),
          apiFeatureProductListApi(isFeaturedProduct: true),
        ],
      ];

      await Future.wait(parallelCalls);
    });
  }

  getCurrentLocation() async {
    // Nashville default — used when GPS is unavailable (e.g. simulator, denied
    // service, or a timed-out fix) so store details still load instead of the
    // fetch throwing an unhandled TimeoutException and skipping the call.
    lat = 36.1627;
    lng = -86.7816;
    try {
      Position currentLocation = await Utility.fetchCurrentLocation();
      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
    } catch (e) {
      print("DEBUG: getCurrentLocation fallback to Nashville: $e");
    }

    if (storeId.value != "0" && storeId.value != "") {
     await  apiGetStoreDetailsApi(latitude: lat, longitude: lng);
    }
  }

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    lastSelectedIndex.value = i;
    if (invokedIndex.value > 0) {
      invokedIndex.value = 0;
      // invokedIndex.value--;
    }

    if (i == 0) {
      await   apiGetStoreOffersApi();
      await   apiFeatureProductListApi(isFeaturedProduct: true);
    } else if (i == 1) {
      await apiGetStoreCategoriesApi();
      if (categoryId.value.isNotEmpty) {
        await  apiFeatureProductListApi(categoryId: categoryId.value);
      }
    } else if (i == 2) {
      await apiFeatureProductListApi(isFavouriteProducts: true);
    } else if (i == 3) {
      await  apiGetPreviousOrders();
    }
  }

  void popUpMenuChange(int i) async {
    popUpIndex.value = i;
    Get.parameters["isFromOptions"] = "false";
    isFromOptions.value = false;
    if (i == 0) {
      apiGetPreviousOrders();
    } else if (i == 1) {
       apiGetStoreCategoriesApi();
      if (Get.parameters["categoryId"] != "") {
        apiFeatureProductListApi(
            categoryId: Get.parameters["categoryId"] ?? "0");
      }
    } else if (i == 2) {
      if (storeDetailsResponse.value.data!.store!.storePages!
          .any((element) => element.storePageType != "privacy")) {
        Utility.showToast(StringConstants.noPrivacyFoundText);
      } else {

        if (storeDetailsResponse
                    .value.data!.store!.storePages![0].storePageType ==
                "privacy" ||
            storeDetailsResponse
                    .value.data!.store!.storePages![1].storePageType ==
                "privacy") {}
      }
    } else if (i == 3) {
      if (storeDetailsResponse.value.data!.store!.storePages!
          .any((element) => element.storePageType != "terms")) {
        Utility.showToast(StringConstants.noTermsFoundText);
      } else {
        if (storeDetailsResponse
                    .value.data!.store!.storePages![0].storePageType ==
                "terms" ||
            storeDetailsResponse
                    .value.data!.store!.storePages![1].storePageType ==
                "terms") {}
      }
    }
  }*/

  void termsAndPrivacyDialog(BuildContext context,
      {String content = "", String contentType = ""}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              Center(
                child: Image.asset(
                  ImageConstants.info,
                  color: AppColors.green,
                  scale: 1.8,
                ),
              ),
              height12SizedBox,
              Text(
                contentType == "terms"
                    ? StringConstants.termsAndConditionsText
                    : StringConstants.privacyPolicyText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              height15SizedBox,
              Text(
                content,
                style: TextStyle(
                    color: AppColors.blackLight,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
              height25SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: AppColors.primary),
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

  void moneyDeductFromCartDialog(BuildContext ctx, {String amount = ""}) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                ImageConstants.info,
                color: AppColors.green,
                scale: 1.5,
              ),
            ),
            height12SizedBox,
            Text(
              StringConstants.paymentConfirmationText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              "\$$amount ${StringConstants.amountWillBeDeductedText}",
              style: TextStyle(
                  color: AppColors.blackLight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.cancelText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    if (isPlaceOrder.value == true) {

                      bool isDeliveryService2 = selectedDeliveryService.value.toString() == "2";
                      bool isDeliverable = cartData.value.isOrderDeliverable == true;

                      if (!isDeliveryService2 || (isDeliveryService2 && isDeliverable)) {
                        await apiPlaceOrder();
                      }
                    }

                   /* if (isPlaceOrder.value == true ) {
                      if(cartData.value.cartTotalPrice !=0 ){
                        await apiPlaceOrder();
                      }
                      else{
                        Utility.showAlertMessage("Please check pay amount.");
                      }
                      if(selectedDeliveryService.value.toString() == "2" && cartData.value.isOrderDeliverable == true){
                        await apiPlaceOrder();
                      }else if (selectedDeliveryService.value.toString() != "2"){
                        await apiPlaceOrder();
                      }
                    }*/
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
                        StringConstants.proceedText,
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
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  void discardCartItems(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.replaceCartItemsText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              StringConstants.cartItemReplaceText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.noText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                width20SizedBox,
                InkWell(
                  onTap: () {
                    if (itemsCount.value != 0) {
                      Get.back();

                      apiAddToCart(context);
                    } else {
                      Utility.showToast(
                          AlertStringConstants.pleaseAddAtLeastOneItemText);
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.yesText,
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
        actions: const <Widget>[],
      ),
    );
  }

  ///Get Active Cart Api
  Future apiActiveCartApi() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopCartActive}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
        final String activeStoreId = activeCartModel.data?.storeId.toString().trim() ?? "";
        final int parsedActiveStoreId = int.tryParse(activeStoreId) ?? 0;

        if (parsedActiveStoreId == 0 &&
            activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = 0;
          storeIdValue.value = activeCartModel.data?.storeId?.toString() ?? "0";
        } else {
          storeIdValue.value = activeCartModel.data?.storeId?.toString() ?? "0";
          isValidAddress.value = activeCartModel.data!.isValidAddress!;
          isOrderDeliverable.value = activeCartModel.data!.isOrderDeliverable!;
          await apiGetCartListApi(existingStoreId: activeCartModel.data!.storeId.toString());
          // The cart can be reached without walking through the store page
          // (tab switch, wallet round-trip), leaving storeDetailsResponse
          // empty. Store details power the cart's Order Type grid and the
          // default delivery selection, so without them the grid shows
          // "No Data" and Pay Now fails with "Please select order type".
          // Restore them from the active cart's store.
          if (storeDetailsResponse.value.data?.store == null &&
              parsedActiveStoreId != 0) {
            storeId.value = activeStoreId;
            await apiGetStoreDetailsApi();
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }).catchError((error, stackTrace) {
      isLoading.value = false;
    });
  }

  ///Api Contact store
  Future apiContactStore() async {
    // Check if user is guest - show modal for login
    if (isGuest.value == true) {
      GuestAccessModal.show(
        title: "Login Required",
        message: "Please login to contact stores",
        onContinueAsGuest: () {
          // Allow guest to continue - just close modal
        },
      );
      return;
    }

    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null") {
      return;
    }

    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.messageStore}?store_id=$finalStoreId",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Get.parameters["storeName"] = value?.body["data"]["store_name"] ?? "";
        Get.parameters["storeId"] = storeId.value;
        // Get.parameters["storeId"] = value?.body["data"]["store_id"] ?? "";
        Get.parameters["messageHeadId"] =
            value?.body["data"]["message_head_id"] ?? "";
        // SharedPreferenceStorage.setData("context", ctx);
        await Get.to(() =>  UserInboxDetailScreen(
          storeId: storeId.value,storeName: value?.body["data"]["store_name"] ?? "",
          // customerName:  " ${ownerInboxController.inboxList[index].user?.firstName} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}",
          messageHeadId: value?.body["data"]["message_head_id"] ?? "",

        ), id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Categories Api
  Future apiGetStoreCategoriesApi() async {
    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null") {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header for authenticated users (same pattern as apiGetNearByStores)
    if (!isGuest.value) {
      headers[StringConstants.authorizationText] = "${StringConstants.bearerText} ${authToken.value}";
    }

    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeCategoryList}?store_id=$finalStoreId",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        categoriesListResponse =
            StoreCategoriesListResponse.fromJson(value?.body);
        categoriesList.value = categoriesListResponse.data?.categories ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        // Guest users should never hit 401 — only clear session for logged-in users
        if (!isGuest.value) {
          Utility.showAlertMessage(value?.body['message']);
          storage.clearData();
          Get.parameters.clear();
          isLoading.value = false;
          Utility.handle401Error();
        }
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get User detail Api
  Future apiGetUserDetailsApi() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.userDetail,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;

              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        userAddress.value = getUserDetailModel.data!.user!.userAddresses!;
        if (userAddress.isNotEmpty) {
          selectedUserAddress.value = userAddress.first;
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Cart List Api
  Future apiGetCartListApi({bool isShowLoading = false,String? existingStoreId}) async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    // Ensure storeId is not empty
    String finalStoreId = (existingStoreId != null && existingStoreId.isNotEmpty && existingStoreId.toLowerCase() != "null" && existingStoreId != "0")
        ? existingStoreId
        : (storeId.value.isNotEmpty && storeId.value.toLowerCase() != "null" && storeId.value != "0" ? storeId.value : "0");
    if (finalStoreId == "0") {
      isLoading.value = false;
      return;
    }

    // Ensure storeDeliveryServiceId is not empty
    String finalDeliveryServiceId = storeDeliveryServiceId.value.isNotEmpty ? storeDeliveryServiceId.value : "0";
    // Ensure userAddressId is not empty
    String? finalUserAddressId = (selectedUserAddress.value.userAddressId != null && selectedUserAddress.value.userAddressId.toString().isNotEmpty)
        ? selectedUserAddress.value.userAddressId.toString()
        : null;

    // Build URL with conditional parameters
    String apiUrl = "${ServerCommunicator.baseUrl}${ServerCommunicator.cartList}?store_id=$finalStoreId";
    if (finalDeliveryServiceId != "0") {
      apiUrl += "&store_delivery_service_id=$finalDeliveryServiceId";
    }
    if (finalUserAddressId != null && finalUserAddressId.isNotEmpty) {
      apiUrl += "&user_address_id=$finalUserAddressId";
    }

     try{
    UserProvider()
        .getWithHeadersApi(
            apiUrl,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        cartListResponse = CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
        cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
        if (cartListResponse.data?.cartTotalPrice is int ||
            cartListResponse.data?.cartTotalPrice is String) {
          cartTotalPrice.value = double.parse(
              cartListResponse.data?.cartTotalPrice.toString() ?? "0.0");
        } else {
          cartTotalPrice.value = cartListResponse.data?.cartTotalPrice ?? 0.0;
        }
        cartData.value = cartListResponse.data ?? CartListData();
        if (selectedDeliveryService.value.toString() == "2" && cartData.value.isOrderDeliverable == false) {
          Utility.showAlertMessage(AlertStringConstants.orderNotDeliverable);
          isPlaceOrder.value = false;
        } else {
          // Re-arm checkout: without this the block above latches and the
          // payment dialog's Proceed silently no-ops even after the user
          // switches to a viable order type.
          isPlaceOrder.value = true;
        }
        if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == true) {
          isDeleteCartItem.value = false;
          Get.until((route) => route.isFirst, id: pageIdApp.value);
        } else if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == false) {
          Get.parameters["storeId"] = storeId.value;
          isDeleteCartItem.value = false;
          Get.parameters["isFromMenu"] = "false";
          Get.parameters['isFromFav'] = "false";
          Get.parameters["isFromHome"] = "true";
          Get.parameters["isFromOptions"] = "false";
          Get.back(id: pageIdApp.value);
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }).catchError((error, stackTrace) {
      isLoading.value = false;
    });
     }catch(e){
       Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
     }
  }

  ///Place Order Api
  Future apiPlaceOrder() async {
    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null") {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectStore);
      return;
    }

    final String finalStoreDeliveryServiceId = storeDeliveryServiceId.value.toString().trim();
    if (finalStoreDeliveryServiceId.isEmpty || finalStoreDeliveryServiceId == "0" || finalStoreDeliveryServiceId.toLowerCase() == "null") {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectOrderTypeText);
      return;
    }

    isPlaceOrder.value = false;
    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    List selectedItems = [];
    for (var element in cartItems) {
      selectedItems.add({
        "cart_item_id": element.cartItemId?.isNotEmpty == true ? int.parse(element.cartItemId.toString()) : 0,
        "items_count": element.itemsCount,
      });
    }

    Map<String, dynamic> data = {
      "store_id": int.parse(finalStoreId),
      "store_delivery_service_id": int.parse(finalStoreDeliveryServiceId),
      "user_address_id": selectedDeliveryService.value == "1" ||
              selectedDeliveryService.value == "3"
          ? (storeAddressId.value.isNotEmpty ? int.parse(storeAddressId.value) : 0)
          : selectedUserAddress.value.userAddressId != null &&
                  selectedUserAddress.value.userAddressId.toString().trim().isNotEmpty &&
                  selectedUserAddress.value.userAddressId.toString().toLowerCase() != "null"
              ? int.parse(selectedUserAddress.value.userAddressId.toString())
              : null,
      "cart_items": selectedItems
    };

    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.placeOrder}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        itemsCount.value = 1;
        orderStatus.value = value?.body["data"]["order_id"];
        isPlaceOrder.value = true;
                 // Get.parameters["storeId"] = storeId.value.toString();
        // Get.parameters["orderStatus"] = value?.body["data"]["order_id"] ?? "";
        // Get.parameters["isFromTransaction"] = "false";
        // Get.parameters["isFromNotification"] = "false";
        // Get.parameters["isHome"] = "true";
        isInsufficientBalance!.value = false;

        Get.to(() =>  OrderConfirmationScreen(
          storeId: storeId.value.toString(),
          orderStatus: value?.body["data"]["order_id"] ?? "",
          isFromNotification: false,
          isFromTransaction: false,
            isHome:true
        ),
            id: pageIdApp.value,
           );
        selectedDeliveryService.value= "0";
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isPlaceOrder.value = true;
        selectedDeliveryService.value= "0";

        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        selectedDeliveryService.value= "0";
        isPlaceOrder.value = true;
        if (value?.body["message"] == "Insufficient balance") {
          isInsufficientBalance!.value = true;
        } else {
          isInsufficientBalance!.value = false;

          Utility.showAlertMessage(value?.body['message']);
        }
      } else if (value?.body == null) {
        selectedDeliveryService.value= "0";
        isPlaceOrder.value = true;
        Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
      }
    });
  }

  /// Add To CartApi
  Future apiAddToCart(BuildContext context) async {
    if (isGuest.value == true) {
      Utility.showAlertMessage("Please login to add items to cart");
      Get.to(() => LoginScreen());
      return;
    }

    final productIdStr = productDetailResponse.value.data?.product?.productId ?? "";
    final parsedProductId = int.tryParse(productIdStr) ?? 0;
    if (parsedProductId == 0) {
      Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
      return;
    }

    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "product_id": parsedProductId,
      "items_count": itemsCount.value,
    };

    try {
      final value = await UserProvider().postWithHeadersApi(
          data,
          "${ServerCommunicator.baseUrl}${ServerCommunicator.createCart}",
          headers,
          showLoading: false);
      isLoading.value = false;

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        itemsCount.value = 1;
        // Use overlayContext so the dialog always has a valid context regardless
        // of widget rebuilds triggered by the isLoading toggle above.
        addToCartDialog(Get.overlayContext!);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    } catch (e) {
      isLoading.value = false;
      Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
    }
  }

  ///Update Cart Api
  Future apiUpdateCart({int cartItemId = 0, quantity = 0}) async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "cart_item_id": cartItemId,
      "items_count": quantity
    };

         UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.updateCart}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isDeleteCartItem.value = true;
        await apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Cart Api
  Future apiDeleteCart({int cartItemId = 0}) async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "cart_item_id": cartItemId,
    };

         UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.deleteItemFromCart}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isDeleteCartItem.value = true;
        await apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  void addToCartDialog(
    BuildContext ctx,
  ) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                ImageConstants.tick,
                scale: 3,
              ),
            ),
            height10SizedBox,
            Text(
              StringConstants.itemAddedInCart,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Center(
              child: Text(
                StringConstants.whatWouldLikeNowText,
                style: TextStyle(
                    color: AppColors.blackLight,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
            ),
            height25SizedBox,
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    Get.back();
                    // Get.parameters["storeId"] = storeId.value;
                    selectedIndex.value = 1;
                    invokedIndex.value = 0;
                    lastSelectedIndex.value = 1;
                    await apiGetStoreCategoriesApi();
                      apiFeatureProductListApi(
                          categoryId: categoryId.value);
                    await Get.to(() =>  StoreHomeMainScreen(
                        args:  StoreHomeMainArgs(
                          storeId: storeId.value,
                          // productId: homeController.featuredUserProductList[0].productId ?? "",
                          invokedIndex: 0,
                          isFromMenu: isFromMenu.value,isFromFav: isFromFav.value,
                          isFromHome: isFromHome.value, isFromOptions: isFromOptions.value,
                        )
                    ),
                        id: pageIdApp.value);
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.35,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.continueShoppingText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                width8SizedBox,
                InkWell(
                  onTap: () async {
                    Get.back();
                    await apiGetUserWalletBalance();
                   await Get.to(() =>  CartScreen(
                        storeId: storeId.value,
                        isFromAddProduct:true),
                        id: pageIdApp.value)?.then((value) =>  onInit());
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.goToCartText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Get Store Offers Api
  Future apiGetStoreOffersApi() async {
    offersList.clear();
    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null") {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    Map<String, String> headers = {};
    // Only include authorization header for authenticated users
    if (!isGuest.value) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeOffersList}?store_id=$finalStoreId",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        offersListResponse = StoreOffersListResponse.fromJson(value?.body);
        offersList.value = offersListResponse.data?.offers ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (!isGuest.value) {
          Utility.showAlertMessage(value?.body['message']);
          storage.clearData();
          Get.parameters.clear(); isLoading.value = false;
          Utility.handle401Error();
        }
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }).catchError((error, stackTrace) {
      isLoading.value = false;
      print('Error fetching offers: $error');
    });
  }

  ///Get User Wallet Balance Api
  Future apiGetUserWalletBalance() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        if (value?.body["data"]["balance"] is int ||
            value?.body["data"]["balance"] is String) {
          walletBalance.value =
              double.parse(value?.body["data"]["balance"].toString() ?? "");
                   } else if (value?.body["data"]["balance"] is double) {
          walletBalance.value = value?.body["data"]["balance"] ?? 0.0;
                   }
        // apiActiveCartApi() internally calls apiGetCartListApi() when cart has items.
        // No need to call apiGetCartListApi separately here — avoids duplicate cart fetch.
        await apiActiveCartApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }); 
  }

  ///Get Store Details Api
  Future apiGetStoreDetailsApi({dynamic latitude = 0.0, dynamic longitude = 0.0}) async {
    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0") {
      isLoading.value = false;
      showLoading.value = false;
      return;
    }

    isLoading.value = true;

    Map<String, String> headers = {};
    // Only include authorization header for authenticated users
    if (!isGuest.value) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreDetails}?store_id=$finalStoreId&latitude=$latitude&longitude=$longitude",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      showLoading.value = false;
                     if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value = StoreDetailsResponse.fromJson(value?.body);

        storeDeliveryServiceId.value = storeDetailsResponse
            .value
            .data
            ?.store
            ?.storeDeliveryServices
            ?.firstWhere(
              (e) => e.deliveryServiceId == "1",
          orElse: () => StoreDeliveryService(),
        )
            .storeDeliveryServiceId
            ?.toString() ?? "";
        storeLocation.value =
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.addressLine1 ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.city ?? ""},"
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.stateName ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.country?.countryName ?? ""}";


                 isVerifiedStore.value =
            storeDetailsResponse.value.data?.store?.isVerified ?? false;
        isFavouriteStore.value =
            storeDetailsResponse.value.data?.store?.isFavouriteStore ?? false;


               } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (!isGuest.value) {
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
          storage.clearData();
          Get.parameters.clear();
          Utility.handle401Error();
        }
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }).catchError((error, stackTrace) {
      isLoading.value = false;
      showLoading.value = false;
      print('Error fetching store details: $error');
    });
  }
  void _prepareImages() {
    productIm?.clear();

    final images =
        productDetailResponse.value.data?.product?.productImages ?? [];

    for (int i = 0; i < images.length && i < 5; i++) {
      productIm?.add(
        ProductImage(
          image: Images(dynamicUrl: images[i].image?.dynamicUrl ?? ""),
        ),
      );
    }
  }

  Future<void> apiGetShopProductDetailApi() async {
    final String finalStoreId = storeId.value.toString().trim();
    final String finalProductId = productId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null" || finalProductId.isEmpty || finalProductId.toLowerCase() == "null") {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    final Map<String, String> headers = {};
    if (!isGuest.value) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }

    try {
      final response = await UserProvider().getWithHeadersApi(
        "${ServerCommunicator.baseUrl}${ServerCommunicator.shopProductDetails}"
            "?store_id=$finalStoreId"
            "&product_id=$finalProductId"
            "&latitude=$lat"
            "&longitude=$lng",
        headers,
        showLoading: false,
      );

      isLoading.value = false;

      if (response == null || response.body == null) {
        Utility.showAlertMessage("Something went wrong");
        return;
      }

      final status = response.body["status"];
      final message = response.body["message"];

      switch (status) {
        case ApiConstants.statusCode200:
        case ApiConstants.statusCode201:
          _handleSuccess(response.body);
          break;

        case ApiConstants.statusCode401:
          _handleUnauthorized(message);
          break;

        case ApiConstants.statusCode409:
        // handle conflict if needed
          if (message != null) {
            Utility.showAlertMessage(message);
          }
          break;

        default:
          if (message != null) {
            Utility.showAlertMessage(message);
          }
          break;
      }
    } catch (e, s) {
      isLoading.value = false;
      Utility.showAlertMessage("Something went wrong");
    }
  }

  void _handleSuccess(Map<String, dynamic> body) {
    productDetailResponse.value =
        ShopProductDetailResponse.fromJson(body);

    _prepareImages();

    isFavouriteProduct.value =
        productDetailResponse.value.data?.product?.isFavouriteProduct ?? false;

    update(); // 🔥 single update
  }
   _handleUnauthorized(String? message) async {
    if (message != null) {
      Utility.showAlertMessage(message);
    }

    await storage.clearData();
    Get.parameters.clear();

    Utility.handle401Error();
  }


/*  ///Get Shop  Product Detail Api
  Future apiGetShopProductDetailApi() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopProductDetails}?store_id=${storeId.value}&product_id=${productId.value}&latitude=$lat&longitude=$lng",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        productDetailResponse.value =
            ShopProductDetailResponse.fromJson(value?.body);
        productIm!.clear();
        if (productDetailResponse
            .value.data!.product!.productImages!.isNotEmpty) {
          for (int i = 0;
              i <
                  productDetailResponse
                      .value.data!.product!.productImages!.length;
              i++) {
            if (i >= 5) {
              break;
            }

            productIm!.add(ProductImage(
                image: Images(
                    dynamicUrl: productDetailResponse.value.data!.product!
                        .productImages![i].image!.dynamicUrl!)));
          }
        }
        update();
        isFavouriteProduct.value =
            productDetailResponse.value.data?.product?.isFavouriteProduct ??
                false;
        if (productDetailResponse.value.data!.product!.cartItems!.isNotEmpty) {
          // itemsCount.value = productDetailResponse
          //     .value.data!.product!.cartItems!.first.itemsCount!;
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }*/

  ///Feature ProductList Store Api
  Future apiFeatureProductListApi(
      {bool isFavouriteProducts = false,
      isFeaturedProduct = false,
      String orderBy = "1",
      String orderType = "1",
      String categoryId = "0"}) async {
    final String finalStoreId = storeId.value.toString().trim();
    if (finalStoreId.isEmpty || finalStoreId == "0" || finalStoreId.toLowerCase() == "null") {
      isLoading.value = false;
      return;
    }

    featureProductList.clear();
    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header for authenticated users
    if (!isGuest.value) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }

    Map data = {
      "q": "",
      "store_id": int.parse(finalStoreId),
      "page": 1,
      "page_size": 100,
      "order_by": orderBy == "1" ? "product_id" : "selling_price",
      "order_type": orderType == "1" ? "DESC" : "ASC",
      "category_id": isFeaturedProduct == false && categoryId != "0"
          ? int.tryParse(categoryId) ?? 0
          : null,
      "is_favourite_products": isFavouriteProducts,
      "filters": isFeaturedProduct
          ? [
              {
                "filter_by": "is_featured_product",
                "filter_value": true,
                "operation": "eq"
              }
            ]
          : []
    };

              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeFeatureProductList,
            headers,
            showLoading: false /*showLoading.value*/)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        featureProductListResponse =
            FeatureProductListResponse.fromJson(value?.body);
        featureProductList.value =
            featureProductListResponse.data?.products ?? [];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        // Guest users should never hit 401 — only clear session for logged-in users
        if (!isGuest.value) {
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
          storage.clearData();
          Get.parameters.clear();
          Utility.handle401Error();
        }
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  bottomSheetChangePickupLocation(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              StringConstants.selectLocationText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                ImageConstants.cross,
                                scale: 3,
                              ))
                        ],
                      ),
                      height15SizedBox,
                      ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return height12SizedBox;
                          },
                          itemCount: userAddress.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                selectedUserAddress.value = userAddress[index];
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                    color: AppColors.greyLight,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    )),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "${userAddress[index].addressLine1},${userAddress[index].city},"
                                              "${userAddress[index].state?.stateName},${userAddress[index].state?.country?.countryName},",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      userAddress[index].userAddressId ==
                                              selectedUserAddress
                                                  .value.userAddressId
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  ImageConstants.circlefull,
                                                  scale: 4,
                                                ),
                                                Image.asset(
                                                  ImageConstants.whitetick,
                                                  color: AppColors.white,
                                                  scale: 3.5,
                                                ),
                                              ],
                                            )
                                          : Image.asset(
                                              ImageConstants.circleunfill,
                                              scale: 4,
                                            ),
                                    ],
                                  ),
                                ]),
                              ),
                            );
                          }),
                      height10SizedBox,
                    ],
                  ),
                ),
              ],
            );
          });
        }).then((value) => {});
  }

  ///Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    // Guests cannot favourite a store
    if (isGuest.value == true) return;

    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

         UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.createFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isFavouriteStore.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        isFavouriteStore.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    // Guests cannot remove a favourite store
    if (isGuest.value == true) return;

    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

              UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.removeFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        featureProductList.where((p0) => p0.storeId == id ).first.isFavouriteProduct?.value= true;
        if (value?.body['message'] != null) {
          isFavouriteStore.value = true;
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        featureProductList.where((p0) => p0.storeId == id ).first.isFavouriteProduct?.value= true;
        isFavouriteStore.value = true;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Favourite Product Api
  Future apiCreateFavouriteProduct(String? id) async {
    // Check if user is guest - show modal for login
    if (isGuest.value == true) {
      GuestAccessModal.show(
        title: "Login Required",
        message: "Please login to add products to favourites",
        onContinueAsGuest: () {
          // Allow guest to continue - just close modal
        },
      );
      return;
    }

    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"product_id": int.parse(id ?? "0")};

              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.createFavouriteProduct,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);

        // isFavouriteProduct.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isFavouriteProduct.value = false;
        final matchingProducts = featureProductList.where((p0) => p0.productId == id);
        if (matchingProducts.isNotEmpty) {
          matchingProducts.first.isFavouriteProduct?.value = false;
        }
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        // Server already has this favourite (unique-constraint conflict):
        // sync the UI to the server state instead of showing the raw error.
        isFavouriteProduct.value = true;
        final matchingProducts = featureProductList.where((p0) => p0.productId == id);
        if (matchingProducts.isNotEmpty) {
          matchingProducts.first.isFavouriteProduct?.value = true;
        }
      } else { isFavouriteProduct.value = false;
        final matchingProducts = featureProductList.where((p0) => p0.productId == id);
        if (matchingProducts.isNotEmpty) {
          matchingProducts.first.isFavouriteProduct?.value = false;
        }
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
  void toggleFavProduct(int index) {
    final product = featureProductList[index];
    final isFav = product.isFavouriteProduct?.value ?? false;

    product.isFavouriteProduct?.value = !isFav;

    if (isFav) {
      apiRemoveFavouriteProduct(product.productId, isFromFavS: true);
    }
  }

  ///Remove Favourite Product Api
  Future apiRemoveFavouriteProduct(String? id,{bool isFromFavS = false}) async {
    // Check if user is guest - show modal for login
    if (isGuest.value == true) {
      GuestAccessModal.show(
        title: "Login Required",
        message: "Please login to manage favourites",
        onContinueAsGuest: () {
          // Allow guest to continue - just close modal
        },
      );
      return;
    }

    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"product_id": int.parse(id ?? "0")};

              UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.removeFavouriteProduct,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFromFavS ? apiFeatureProductListApi(isFavouriteProducts: true) : null;
        // isFavouriteProduct.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isFavouriteProduct.value = true;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode404 ||
          value?.body["status"] == ApiConstants.statusCode409) {
        // Favourite no longer exists on the server: sync the UI to the
        // server state instead of showing the raw error.
        isFavouriteProduct.value = false;
        final matchingProducts = featureProductList.where((p0) => p0.productId == id);
        if (matchingProducts.isNotEmpty) {
          matchingProducts.first.isFavouriteProduct?.value = false;
        }
        isFromFavS ? apiFeatureProductListApi(isFavouriteProducts: true) : null;
      } else {
        isFavouriteProduct.value = true;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Previous orders ProductList Api
  Future apiGetPreviousOrders() async {
    // Check if user is guest - show modal for login
    if (isGuest.value == true) {
      GuestAccessModal.show(
        title: "Login Required",
        message: "Please login to view previous orders",
        onContinueAsGuest: () {
          // Allow guest to continue - just close modal
        },
      );
      return;
    }

    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 100,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": false,
      "is_previous_products": true,
      "filters": [
        // {
        //     "filter_by": "is_featured_product",
        //     "filter_value": true,
        //     "operation": "eq"
        // }
      ]
    };
              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.shopStoreProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        previousOrdersModel = PreviousOrdersModel.fromJson(value?.body);
        previousOrderList.value = previousOrdersModel.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api Get offers products
  Future apiGetOffersProducts(
      {String storeId = "", String offerId = ""}) async {
    featuredUserProductList.clear();
    isLoading.value = true;
         Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {
      "q": "",
      "store_id": storeId,
      "page": 1,
      "page_size": 1000,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": null,
      "is_previous_products": null,
      "offer_id": offerId,
      "filters": []
    };
              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeFeatureProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
