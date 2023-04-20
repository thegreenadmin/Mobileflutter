class CardListModel {
  int? status;
  String? message;
  Data? data;

  CardListModel({this.status, this.message, this.data});

  CardListModel.fromJson(Map<String, dynamic> json) {
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
  List<Cards>? cards;

  Data({this.cards});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards!.add(new Cards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cards != null) {
      data['cards'] = this.cards!.map((v) => v.toJson()).toList();
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
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_stripe_id'] = this.userStripeId;
    data['stripe_card_id'] = this.stripeCardId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_stripe_card_id'] = this.userStripeCardId;
    if (this.card != null) {
      data['card'] = this.card!.toJson();
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

  Card({
    this.id,
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
  });

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;

    data['brand'] = this.brand;
    data['country'] = this.country;
    data['customer'] = this.customer;
    data['cvc_check'] = this.cvcCheck;

    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['funding'] = this.funding;
    data['last4'] = this.last4;

    return data;
  }
}
