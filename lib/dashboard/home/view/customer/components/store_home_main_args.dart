class StoreHomeMainArgs {
  final String? storeId;
  final int? invokedIndex;
  final String? productId;
  final String? categoryName;
  final String? categoryId;
  final bool? isFromHome;
  final bool? isFromFav;
  final bool? isFromMenu;
  final bool? isFromOptions;

  StoreHomeMainArgs({
    this.storeId,
    this.invokedIndex,
    this.productId,
    this.categoryName,
    this.categoryId,
    this.isFromHome,
    this.isFromFav,
    this.isFromMenu,
    this.isFromOptions,
  });

  factory StoreHomeMainArgs.fromParams(Map<String, String?>? params) {
    return StoreHomeMainArgs(
      storeId: params?["storeId"],
      invokedIndex: int.tryParse(params?["invokedIndex"] ?? ""),
      productId: params?["productId"],
      categoryName: params?["categoryName"],
      categoryId: params?["categoryId"],
      isFromHome: params?["isFromHome"] == "true",
      isFromFav: params?["isFromFav"] == "true",
      isFromMenu: params?["isFromMenu"] == "true",
      isFromOptions: params?["isFromOptions"] == "true",
    );
  }

  factory StoreHomeMainArgs.fromArguments(dynamic arguments) {
    if (arguments is StoreHomeMainArgs) {
      return arguments;
    }
    return StoreHomeMainArgs();
  }
}
