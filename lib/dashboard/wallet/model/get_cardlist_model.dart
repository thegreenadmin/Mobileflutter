class CardListModel {
  int? status;
  String? message;
  CardListData? data;

  CardListModel({this.status, this.message, this.data});

  CardListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CardListData.fromJson(json['data']) : null;
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

class CardListData {
  List<Cards>? cards;

  CardListData({this.cards});

  CardListData.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards!.add(Cards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cards != null) {
      data['cards'] = cards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  String? userStripeId;
  String? stripeCardId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userStripeCardId;
  Card? card;

  Cards(
      {this.userStripeId,
      this.stripeCardId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userStripeCardId,
      this.card});

  Cards.fromJson(Map<String, dynamic> json) {
    userStripeId = json['user_stripe_id'];
    stripeCardId = json['stripe_card_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userStripeCardId = json['user_stripe_card_id'];
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_stripe_id'] = userStripeId;
    data['stripe_card_id'] = stripeCardId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user_stripe_card_id'] = userStripeCardId;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    return data;
  }
}

class Card {
  String? id;
  String? object;

  String? brand;
  String? country;
  String? customer;
  String? cvcCheck;

  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  String? last4;
  bool? isSelected = false;

  Card(
      {this.id,
      this.object,
      this.brand,
      this.country,
      this.customer,
      this.cvcCheck,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.funding,
      this.last4,
      this.isSelected});

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];

    brand = json['brand'];
    country = json['country'];
    customer = json['customer'];
    cvcCheck = json['cvc_check'];

    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;

    data['brand'] = brand;
    data['country'] = country;
    data['customer'] = customer;
    data['cvc_check'] = cvcCheck;

    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['fingerprint'] = fingerprint;
    data['funding'] = funding;
    data['last4'] = last4;

    return data;
  }
}
