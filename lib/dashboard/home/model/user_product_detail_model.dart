// To parse this JSON data, do
//
//     final shopProductDetailResponse = shopProductDetailResponseFromJson(jsonString);

import 'dart:convert';

ShopProductDetailResponse shopProductDetailResponseFromJson(String str) => ShopProductDetailResponse.fromJson(json.decode(str));

String shopProductDetailResponseToJson(ShopProductDetailResponse data) => json.encode(data.toJson());

class ShopProductDetailResponse {
  ShopProductDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  ShopProductDetailResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      ShopProductDetailResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ShopProductDetailResponse.fromJson(Map<String, dynamic> json) => ShopProductDetailResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.product,
  });

  Product? product;

  Data copyWith({
    Product? product,
  }) =>
      Data(
        product: product ?? this.product,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
  };
}

class Product {
  Product({
    this.productId,
    this.isFavouriteProduct,
    this.storeId,
    this.quantityTypeId,
    this.quantity,
    this.isFeaturedProduct,
    this.productName,
    this.description,
    this.productPrice,
    this.sellingPrice,
    this.discountType,
    this.discountValue,
    this.isProductReturnable,
    this.returnDaysCount,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.isEnabled,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.quantityType,
    this.productCategories,
    this.productImages,
    this.productContents,
    this.productLinks,
    this.cartItems,
  });

  String? productId;
  bool? isFavouriteProduct;
  String? storeId;
  String? quantityTypeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  double? sellingPrice;
  String? discountType;
  int? discountValue;
  bool? isProductReturnable;
  int? returnDaysCount;
  int? length;
  int? width;
  int? height;
  int? weight;
  bool? isEnabled;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  QuantityType? quantityType;
  List<ProductCategory>? productCategories;
  List<ProductImage>? productImages;
  List<ProductContent>? productContents;
  List<ProductLink>? productLinks;
  List<CartItem>? cartItems;

  Product copyWith({
    String? productId,
    bool? isFavouriteProduct,
    String? storeId,
    String? quantityTypeId,
    int? quantity,
    bool? isFeaturedProduct,
    String? productName,
    String? description,
    double? productPrice,
    double? sellingPrice,
    String? discountType,
    int? discountValue,
    bool? isProductReturnable,
    int? returnDaysCount,
    int? length,
    int? width,
    int? height,
    int? weight,
    bool? isEnabled,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    QuantityType? quantityType,
    List<ProductCategory>? productCategories,
    List<ProductImage>? productImages,
    List<ProductContent>? productContents,
    List<ProductLink>? productLinks,
    List<CartItem>? cartItems,
  }) =>
      Product(
        productId: productId ?? this.productId,
        isFavouriteProduct: isFavouriteProduct ?? this.isFavouriteProduct,
        storeId: storeId ?? this.storeId,
        quantityTypeId: quantityTypeId ?? this.quantityTypeId,
        quantity: quantity ?? this.quantity,
        isFeaturedProduct: isFeaturedProduct ?? this.isFeaturedProduct,
        productName: productName ?? this.productName,
        description: description ?? this.description,
        productPrice: productPrice ?? this.productPrice,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        isProductReturnable: isProductReturnable ?? this.isProductReturnable,
        returnDaysCount: returnDaysCount ?? this.returnDaysCount,
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        quantityType: quantityType ?? this.quantityType,
        productCategories: productCategories ?? this.productCategories,
        productImages: productImages ?? this.productImages,
        productContents: productContents ?? this.productContents,
        productLinks: productLinks ?? this.productLinks,
        cartItems: cartItems ?? this.cartItems,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    isFavouriteProduct: json["is_favourite_product"],
    storeId: json["store_id"],
    quantityTypeId: json["quantity_type_id"],
    quantity: json["quantity"],
    isFeaturedProduct: json["is_featured_product"],
    productName: json["product_name"],
    description: json["description"],
    productPrice: json["product_price"]?.toDouble(),
    sellingPrice: json["selling_price"]?.toDouble(),
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    isProductReturnable: json["is_product_returnable"],
    returnDaysCount: json["return_days_count"],
    length: json["length"],
    width: json["width"],
    height: json["height"],
    weight: json["weight"],
    isEnabled: json["is_enabled"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    quantityType: json["quantity_type"] == null ? null : QuantityType.fromJson(json["quantity_type"]),
    productCategories: json["product_categories"] == null ? [] : List<ProductCategory>.from(json["product_categories"]!.map((x) => ProductCategory.fromJson(x))),
    productImages: json["product_images"] == null ? [] : List<ProductImage>.from(json["product_images"]!.map((x) => ProductImage.fromJson(x))),
    productContents: json["product_contents"] == null ? [] : List<ProductContent>.from(json["product_contents"]!.map((x) => ProductContent.fromJson(x))),
    productLinks: json["product_links"] == null ? [] : List<ProductLink>.from(json["product_links"]!.map((x) => ProductLink.fromJson(x))),
    cartItems: json["cart_items"] == null ? [] : List<CartItem>.from(json["cart_items"]!.map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "is_favourite_product": isFavouriteProduct,
    "store_id": storeId,
    "quantity_type_id": quantityTypeId,
    "quantity": quantity,
    "is_featured_product": isFeaturedProduct,
    "product_name": productName,
    "description": description,
    "product_price": productPrice,
    "selling_price": sellingPrice,
    "discount_type": discountType,
    "discount_value": discountValue,
    "is_product_returnable": isProductReturnable,
    "return_days_count": returnDaysCount,
    "length": length,
    "width": width,
    "height": height,
    "weight": weight,
    "is_enabled": isEnabled,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "quantity_type": quantityType?.toJson(),
    "product_categories": productCategories == null ? [] : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
    "product_images": productImages == null ? [] : List<dynamic>.from(productImages!.map((x) => x.toJson())),
    "product_contents": productContents == null ? [] : List<dynamic>.from(productContents!.map((x) => x.toJson())),
    "product_links": productLinks == null ? [] : List<dynamic>.from(productLinks!.map((x) => x.toJson())),
    "cart_items": cartItems == null ? [] : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
  };
}

class CartItem {
  CartItem({
    this.cartItemId,
    this.quantity,
  });

  String? cartItemId;
  int? quantity;

  CartItem copyWith({
    String? cartItemId,
    int? quantity,
  }) =>
      CartItem(
        cartItemId: cartItemId ?? this.cartItemId,
        quantity: quantity ?? this.quantity,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartItemId: json["cart_item_id"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "cart_item_id": cartItemId,
    "quantity": quantity,
  };
}

class ProductCategory {
  ProductCategory({
    this.productCategoryId,
    this.status,
    this.category,
  });

  String? productCategoryId;
  String? status;
  Category? category;

  ProductCategory copyWith({
    String? productCategoryId,
    String? status,
    Category? category,
  }) =>
      ProductCategory(
        productCategoryId: productCategoryId ?? this.productCategoryId,
        status: status ?? this.status,
        category: category ?? this.category,
      );

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    productCategoryId: json["product_category_id"],
    status: json["status"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "product_category_id": productCategoryId,
    "status": status,
    "category": category?.toJson(),
  };
}

class Category {
  Category({
    this.categoryId,
    this.categoryName,
  });

  String? categoryId;
  String? categoryName;

  Category copyWith({
    String? categoryId,
    String? categoryName,
  }) =>
      Category(
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
  };
}

class ProductContent {
  ProductContent({
    this.productContentId,
    this.heading,
    this.paragraph,
    this.order,
    this.status,
  });

  String? productContentId;
  String? heading;
  String? paragraph;
  int? order;
  String? status;

  ProductContent copyWith({
    String? productContentId,
    String? heading,
    String? paragraph,
    int? order,
    String? status,
  }) =>
      ProductContent(
        productContentId: productContentId ?? this.productContentId,
        heading: heading ?? this.heading,
        paragraph: paragraph ?? this.paragraph,
        order: order ?? this.order,
        status: status ?? this.status,
      );

  factory ProductContent.fromJson(Map<String, dynamic> json) => ProductContent(
    productContentId: json["product_content_id"],
    heading: json["heading"],
    paragraph: json["paragraph"],
    order: json["order"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "product_content_id": productContentId,
    "heading": heading,
    "paragraph": paragraph,
    "order": order,
    "status": status,
  };
}

class ProductImage {
  ProductImage({
    this.productImageId,
    this.order,
    this.status,
    this.image,
  });

  String? productImageId;
  int? order;
  String? status;
  Image? image;

  ProductImage copyWith({
    String? productImageId,
    int? order,
    String? status,
    Image? image,
  }) =>
      ProductImage(
        productImageId: productImageId ?? this.productImageId,
        order: order ?? this.order,
        status: status ?? this.status,
        image: image ?? this.image,
      );

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    productImageId: json["product_image_id"],
    order: json["order"],
    status: json["status"],
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "product_image_id": productImageId,
    "order": order,
    "status": status,
    "image": image?.toJson(),
  };
}

class Image {
  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

  String? orignalUrl;
  String? dynamicUrl;

  Image copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Image(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    orignalUrl: json["orignal_url"],
    dynamicUrl: json["dynamic_url"],
  );

  Map<String, dynamic> toJson() => {
    "orignal_url": orignalUrl,
    "dynamic_url": dynamicUrl,
  };
}

class ProductLink {
  ProductLink({
    this.productLinkId,
    this.name,
    this.link,
    this.order,
    this.status,
  });

  String? productLinkId;
  String? name;
  String? link;
  int? order;
  String? status;

  ProductLink copyWith({
    String? productLinkId,
    String? name,
    String? link,
    int? order,
    String? status,
  }) =>
      ProductLink(
        productLinkId: productLinkId ?? this.productLinkId,
        name: name ?? this.name,
        link: link ?? this.link,
        order: order ?? this.order,
        status: status ?? this.status,
      );

  factory ProductLink.fromJson(Map<String, dynamic> json) => ProductLink(
    productLinkId: json["product_link_id"],
    name: json["name"],
    link: json["link"],
    order: json["order"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "product_link_id": productLinkId,
    "name": name,
    "link": link,
    "order": order,
    "status": status,
  };
}

class QuantityType {
  QuantityType({
    this.quantityTypeId,
    this.quantityTypeName,
    this.status,
  });

  String? quantityTypeId;
  String? quantityTypeName;
  String? status;

  QuantityType copyWith({
    String? quantityTypeId,
    String? quantityTypeName,
    String? status,
  }) =>
      QuantityType(
        quantityTypeId: quantityTypeId ?? this.quantityTypeId,
        quantityTypeName: quantityTypeName ?? this.quantityTypeName,
        status: status ?? this.status,
      );

  factory QuantityType.fromJson(Map<String, dynamic> json) => QuantityType(
    quantityTypeId: json["quantity_type_id"],
    quantityTypeName: json["quantity_type_name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "quantity_type_id": quantityTypeId,
    "quantity_type_name": quantityTypeName,
    "status": status,
  };
}
