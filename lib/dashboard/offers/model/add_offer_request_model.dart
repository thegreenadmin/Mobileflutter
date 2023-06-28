import 'offers_model.dart';

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
