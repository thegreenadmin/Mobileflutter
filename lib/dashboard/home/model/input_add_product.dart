class InputAddProduct {
  List<ProductImagesList>? productImages;
  int? storeId;
  Product? product;
  List<ProductCategory>? productCategories;
  List<ProductLink>? productLinks;
  List<ProductContent>? productContents;

  InputAddProduct(
      {this.productImages,
      this.storeId,
      this.product,
      this.productCategories,
      this.productLinks,
      this.productContents});

  InputAddProduct.fromJson(Map<String, dynamic> json) {
    if (json['product_images'] != null) {
      productImages = <ProductImagesList>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImagesList.fromJson(v));
      });
    }
    storeId = json['store_id'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategory>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(ProductCategory.fromJson(v));
      });
    }
    if (json['product_links'] != null) {
      productLinks = <ProductLink>[];
      json['product_links'].forEach((v) {
        productLinks!.add(ProductLink.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContent>[];
      json['product_contents'].forEach((v) {
        productContents!.add(ProductContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    data['store_id'] = storeId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (productCategories != null) {
      data['product_categories'] = productCategories!.map((v) => v.toJson()).toList();
    }
    if (productLinks != null) {
      data['product_links'] = productLinks!.map((v) => v.toJson()).toList();
    }
    if (productContents != null) {
      data['product_contents'] = productContents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImagesList {
  String? imageUrl;
  String? dynamicImageUrl;
  String? productImageId;
  String? status;
  int? order;

  ProductImagesList({this.imageUrl, this.productImageId, this.status, this.dynamicImageUrl, this.order});

  ProductImagesList.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    productImageId = json['product_image_id'];
    order = json['order'];
    status = json['status'];
    dynamicImageUrl = json['dynamic_url'];
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

class Product {
  int? quantityTypeId;
  int? productId;
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

  Product(
      {this.quantityTypeId,
      this.productId,
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
      this.isEnabled});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantityTypeId = json['quantity_type_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity_type_id'] = quantityTypeId;
    data['product_id'] = productId;
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
    return data;
  }
}

class Categorys {
  int? categoryId;

  Categorys({this.categoryId});

  Categorys.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    return data;
  }
}

class ProductCategory {
  int? categoryId;
  String? productCategoryId;
  String? status;
  Categorys? category;

  ProductCategory({this.categoryId, this.productCategoryId, this.status, this.category});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    productCategoryId = json['product_category_id'];
    status = json['status'];
    category = json['category'] != null ? Categorys.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['product_category_id'] = productCategoryId;
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class ProductLink {
  String? name;
  String? link;
  String? productLinkId;
  String? status;
  int? order;

  ProductLink({this.name, this.link, this.order, this.status, this.productLinkId});

  ProductLink.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
    order = json['order'];
    productLinkId = json['product_link_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    data['order'] = order;
    data['product_link_id'] = productLinkId;
    data['status'] = status;
    return data;
  }
}

class ProductContent {
  String? heading;
  String? paragraph;
  String? productContentId;
  String? status;
  int? order;

  ProductContent({this.heading, this.paragraph, this.order, this.status, this.productContentId});

  ProductContent.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    paragraph = json['paragraph'];
    order = json['order'];
    productContentId = json['product_content_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['heading'] = heading;
    data['paragraph'] = paragraph;
    data['order'] = order;
    data['product_content_id'] = productContentId;
    data['status'] = status;
    return data;
  }
}
