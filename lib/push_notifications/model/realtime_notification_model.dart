class RealTimeNotification {
  String? storeId;
  String? type;
  String? orderId;
  String? messageHeadId;
  String? offerId;
  RealTimeNotification({this.storeId, this.type, this.orderId, this.offerId});

  RealTimeNotification.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    type = json['type'];
    orderId = json['order_id'];
    messageHeadId = json['message_head_id'];
    offerId = json['offer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['type'] = type;
    data['order_id'] = orderId;
    data['messageHeadId'] = messageHeadId;
    data['offerId'] = offerId;
    return data;
  }
}
