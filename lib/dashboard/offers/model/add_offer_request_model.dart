class AddOfferRequestModel {
  String? storeId;
  Offer? offer;
  List<OfferProducts>? offerProducts;

  AddOfferRequestModel({this.storeId, this.offer, this.offerProducts});

  AddOfferRequestModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
    if (json['offer_products'] != null) {
      offerProducts = <OfferProducts>[];
      json['offer_products'].forEach((v) {
        offerProducts!.add(new OfferProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    if (this.offerProducts != null) {
      data['offer_products'] =
          this.offerProducts!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_offer_for_store'] = this.isOfferForStore;
    data['offer_name'] = this.offerName;
    data['image_url'] = this.imageUrl;
    data['offer_type'] = this.offerType;
    data['offer_value'] = this.offerValue;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    return data;
  }
}
