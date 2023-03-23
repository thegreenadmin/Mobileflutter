class GetStoreProductList {
  int? status;
  String? message;
  Data? data;

  GetStoreProductList({this.status, this.message, this.data});

  GetStoreProductList.fromJson(Map<String, dynamic> json) {
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
  List<Products>? products;

  Data({this.totalCount, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
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

class Products {
  bool? isSelected;
  String? productId;
  String? storeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  dynamic sellingPrice;
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
  List<ProductLinks>? productLinks;

  Products(
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
      this.productContents,
      this.productLinks});

  Products.fromJson(Map<String, dynamic> json) {
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
        ? QuantityType.fromJson(json['quantity_type'])
        : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(ProductCategories.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContents>[];
      json['product_contents'].forEach((v) {
        productContents!.add(ProductContents.fromJson(v));
      });
    }
    if (json['product_links'] != null) {
      productLinks = <ProductLinks>[];
      json['product_links'].forEach((v) {
        productLinks!.add(ProductLinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['store_id'] = storeId;
    data['quantity'] = quantity;
    data['is_featured_product'] = isFeaturedProduct;
    data['product_name'] = productName;
    data['description'] = description;
    data['product_price'] = productPrice;
    data['selling_price'] = sellingPrice;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['is_product_returnable'] = isProductReturnable;
    data['return_days_count'] = returnDaysCount;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (quantityType != null) {
      data['quantity_type'] = quantityType!.toJson();
    }
    if (productCategories != null) {
      data['product_categories'] =
          productCategories!.map((v) => v.toJson()).toList();
    }
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    if (productContents != null) {
      data['product_contents'] =
          productContents!.map((v) => v.toJson()).toList();
    }
    if (productLinks != null) {
      data['product_links'] = productLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuantityType {
  String? quantityTypeId;
  String? quantityTypeName;
  String? status;

  QuantityType({quantityTypeId, quantityTypeName, status});

  QuantityType.fromJson(Map<String, dynamic> json) {
    quantityTypeId = json['quantity_type_id'];
    quantityTypeName = json['quantity_type_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity_type_id'] = quantityTypeId;
    data['quantity_type_name'] = quantityTypeName;
    data['status'] = status;
    return data;
  }
}

class ProductCategories {
  String? productCategoryId;
  String? status;
  Category? category;

  ProductCategories({productCategoryId, status, category});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    productCategoryId = json['product_category_id'];
    status = json['status'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_category_id'] = productCategoryId;
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  String? categoryId;
  String? categoryName;

  Category({categoryId, categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    return data;
  }
}

class ProductImages {
  String? productImageId;
  String? imageUrl;
  int? order;
  String? status;

  ProductImages({productImageId, this.imageUrl, this.order, this.status});

  ProductImages.fromJson(Map<String, dynamic> json) {
    productImageId = json['product_image_id'];
    imageUrl = json['image_url'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_id'] = productImageId;
    data['image_url'] = imageUrl;
    data['order'] = order;
    data['status'] = status;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_content_id'] = productContentId;
    data['heading'] = heading;
    data['paragraph'] = paragraph;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}

class ProductLinks {
  String? productLinkId;
  String? name;
  String? link;
  int? order;
  String? status;

  ProductLinks(
      {this.productLinkId, this.name, this.link, this.order, this.status});

  ProductLinks.fromJson(Map<String, dynamic> json) {
    productLinkId = json['product_link_id'];
    name = json['name'];
    link = json['link'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_link_id'] = productLinkId;
    data['name'] = name;
    data['link'] = link;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}
