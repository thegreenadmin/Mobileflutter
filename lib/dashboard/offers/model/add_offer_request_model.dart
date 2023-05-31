class AddOfferRequestModel {
  String? storeId;
  Offer? offer;
  List<OfferProducts>? offerProducts;

  AddOfferRequestModel({this.storeId, this.offer, this.offerProducts});

  AddOfferRequestModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    offer = json['offer'] != null ? Offer.fromJson(json['offer']) : null;
    if (json['offer_products'] != null) {
      offerProducts = <OfferProducts>[];
      json['offer_products'].forEach((v) {
        offerProducts!.add(OfferProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    if (offer != null) {
      data['offer'] = offer!.toJson();
    }
    if (offerProducts != null) {
      data['offer_products'] = offerProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offer {
  bool? isOfferForStore;
  String? offerName;
  String? imageUrl;
  String? offerType;
  dynamic offerValue;

  Offer(
      {this.isOfferForStore,
      this.offerName,
      this.imageUrl,
      this.offerType,
      this.offerValue});

  Offer.fromJson(Map<String, dynamic> json) {
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    imageUrl = json['image_url'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_offer_for_store'] = isOfferForStore;
    data['offer_name'] = offerName;
    data['image_url'] = imageUrl;
    data['offer_type'] = offerType;
    data['offer_value'] = offerValue;
    return data;
  }
}

class OfferProducts {
  int? productId;

  OfferProducts({this.productId});

  OfferProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    return data;
  }
}
