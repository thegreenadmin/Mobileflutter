class DeleteOfferRequestModel {
  int? storeId;
  int? offerId;

  DeleteOfferRequestModel({this.storeId, this.offerId});

  DeleteOfferRequestModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    offerId = json['offer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['offer_id'] = offerId;
    return data;
  }
}
