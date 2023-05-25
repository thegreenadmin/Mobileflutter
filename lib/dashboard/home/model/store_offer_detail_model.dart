class StoreOfferDetailModel {
  int? status;
  String? message;
  Data? data;

  StoreOfferDetailModel({this.status, this.message, this.data});

  StoreOfferDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  List<Products>? products;

  Data({this.totalCount, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productId;
  bool? isFavouriteProduct;
  bool? isPreviousProduct;
  String? storeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  int? productPrice;
  int? sellingPrice;
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
  String? createdAt;
  String? updatedAt;
  QuantityType? quantityType;
  List<ProductCategories>? productCategories;
  List<ProductImages>? productImages;
  List<ProductContents>? productContents;
  dynamic offerPrice;
  Offer? offer;

  Products(
      {this.productId,
      this.isFavouriteProduct,
      this.isPreviousProduct,
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
      this.productContents,
      this.offerPrice,
      this.offer});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    isFavouriteProduct = json['is_favourite_product'];
    isPreviousProduct = json['is_previous_product'];
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
    offerPrice = json['offer_price'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['is_favourite_product'] = this.isFavouriteProduct;
    data['is_previous_product'] = this.isPreviousProduct;
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
    data['offer_price'] = this.offerPrice;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
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

class Offer {
  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  int? offerValue;

  Offer(
      {this.image,
      this.offerId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue});

  Offer.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['offer_id'] = this.offerId;
    data['is_offer_for_store'] = this.isOfferForStore;
    data['offer_name'] = this.offerName;
    data['offer_type'] = this.offerType;
    data['offer_value'] = this.offerValue;
    return data;
  }
}
