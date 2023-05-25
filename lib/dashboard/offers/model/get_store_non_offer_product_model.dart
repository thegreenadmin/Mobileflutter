class GetStoreNonOfferProductList {
  int? status;
  String? message;
  Data? data;

  GetStoreNonOfferProductList({this.status, this.message, this.data});

  GetStoreNonOfferProductList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  List<ProductsList>? products;

  Data({this.totalCount, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <ProductsList>[];
      json['products'].forEach((v) {
        products!.add(ProductsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsList {
  bool? isSelected = false;
  String? productId;
  String? storeId;
  dynamic quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  dynamic sellingPrice;
  String? discountType;
  dynamic discountValue;
  bool? isProductReturnable;
  dynamic returnDaysCount;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic weight;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  QuantityType? quantityType;
  List<ProductCategories>? productCategories;
  List<ProductImages>? productImages;
  List<ProductContents>? productContents;

  ProductsList(
      {this.isSelected,
      this.productId,
      this.storeId,
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
      this.productContents});

  ProductsList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    storeId = json['store_id'];
    quantity = json['quantity'];
    isFeaturedProduct = json['is_featured_product'];
    productName = json['product_name'];
    description = json['description'];
    productPrice = json['product_price'];
    sellingPrice = json['selling_price'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    isProductReturnable = json['is_product_returnable'];
    returnDaysCount = json['return_days_count'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    quantityType = json['quantity_type'] != null
        ? new QuantityType.fromJson(json['quantity_type'])
        : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContents>[];
      json['product_contents'].forEach((v) {
        productContents!.add(new ProductContents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['store_id'] = this.storeId;
    data['quantity'] = this.quantity;
    data['is_featured_product'] = this.isFeaturedProduct;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['product_price'] = this.productPrice;
    data['selling_price'] = this.sellingPrice;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['is_product_returnable'] = this.isProductReturnable;
    data['return_days_count'] = this.returnDaysCount;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.quantityType != null) {
      data['quantity_type'] = this.quantityType!.toJson();
    }
    if (this.productCategories != null) {
      data['product_categories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.productContents != null) {
      data['product_contents'] =
          this.productContents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuantityType {
  String? quantityTypeId;
  String? quantityTypeName;
  String? status;

  QuantityType({this.quantityTypeId, this.quantityTypeName, this.status});

  QuantityType.fromJson(Map<String, dynamic> json) {
    quantityTypeId = json['quantity_type_id'];
    quantityTypeName = json['quantity_type_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity_type_id'] = this.quantityTypeId;
    data['quantity_type_name'] = this.quantityTypeName;
    data['status'] = this.status;
    return data;
  }
}

class ProductCategories {
  String? productCategoryId;
  String? categoryId;
  String? status;
  Category? category;

  ProductCategories(
      {this.productCategoryId, this.categoryId, this.status, this.category});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    productCategoryId = json['product_category_id'];
    categoryId = json['category_id'];
    status = json['status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_category_id'] = this.productCategoryId;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? categoryId;
  String? categoryName;

  Category({this.categoryId, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class ProductImages {
  String? productImageId;
  int? order;
  String? status;
  Image? image;

  ProductImages({this.productImageId, this.order, this.status, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    productImageId = json['product_image_id'];
    order = json['order'];
    status = json['status'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_id'] = this.productImageId;
    data['order'] = this.order;
    data['status'] = this.status;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  String? orignalUrl;
  String? dynamicUrl;

  Image({this.orignalUrl, this.dynamicUrl});

  Image.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
    return data;
  }
}

class ProductContents {
  String? productContentId;
  String? heading;
  String? paragraph;
  int? order;
  String? status;

  ProductContents(
      {this.productContentId,
      this.heading,
      this.paragraph,
      this.order,
      this.status});

  ProductContents.fromJson(Map<String, dynamic> json) {
    productContentId = json['product_content_id'];
    heading = json['heading'];
    paragraph = json['paragraph'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_content_id'] = this.productContentId;
    data['heading'] = this.heading;
    data['paragraph'] = this.paragraph;
    data['order'] = this.order;
    data['status'] = this.status;
    return data;
  }
}
