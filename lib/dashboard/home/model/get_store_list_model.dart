// class GetStoreListModel {
//   int? status;
//   String? message;
//   Data? data;

//   GetStoreListModel({this.status, this.message, this.data});

//   GetStoreListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   List<Stores>? stores;

//   Data({this.stores});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['stores'] != null) {
//       stores = <Stores>[];
//       json['stores'].forEach((v) {
//         stores!.add(new Stores.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.stores != null) {
//       data['stores'] = this.stores!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Stores {
//   String? storeId;
//   Image? image;
//   String? storeName;
//   String? storeEin;
//   List<StoreAddresses>? storeAddresses;

//   Stores(
//       {this.storeId,
//       this.image,
//       this.storeName,
//       this.storeEin,
//       this.storeAddresses});

//   Stores.fromJson(Map<String, dynamic> json) {
//     storeId = json['store_id'];
//     image = json['image'] != null ? new Image.fromJson(json['image']) : null;
//     storeName = json['store_name'];
//     storeEin = json['store_ein'];
//     if (json['store_addresses'] != null) {
//       storeAddresses = <StoreAddresses>[];
//       json['store_addresses'].forEach((v) {
//         storeAddresses!.add(new StoreAddresses.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['store_id'] = this.storeId;
//     if (this.image != null) {
//       data['image'] = this.image!.toJson();
//     }
//     data['store_name'] = this.storeName;
//     data['store_ein'] = this.storeEin;
//     if (this.storeAddresses != null) {
//       data['store_addresses'] =
//           this.storeAddresses!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Image {
//   String? orignalUrl;
//   String? dynamicUrl;

//   Image({this.orignalUrl, this.dynamicUrl});

//   Image.fromJson(Map<String, dynamic> json) {
//     orignalUrl = json['orignal_url'];
//     dynamicUrl = json['dynamic_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orignal_url'] = this.orignalUrl;
//     data['dynamic_url'] = this.dynamicUrl;
//     return data;
//   }
// }

// class StoreAddresses {
//   String? storeAddressId;
//   String? addressName;
//   double? longitude;
//   double? latitude;
//   String? addressLine1;
//   String? addressLine2;
//   String? landmark;
//   String? city;
//   State? state;

//   StoreAddresses(
//       {this.storeAddressId,
//       this.addressName,
//       this.longitude,
//       this.latitude,
//       this.addressLine1,
//       this.addressLine2,
//       this.landmark,
//       this.city,
//       this.state});

//   StoreAddresses.fromJson(Map<String, dynamic> json) {
//     storeAddressId = json['store_address_id'];
//     addressName = json['address_name'];
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//     addressLine1 = json['address_line_1'];
//     addressLine2 = json['address_line_2'];
//     landmark = json['landmark'];
//     city = json['city'];
//     state = json['state'] != null ? new State.fromJson(json['state']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['store_address_id'] = this.storeAddressId;
//     data['address_name'] = this.addressName;
//     data['longitude'] = this.longitude;
//     data['latitude'] = this.latitude;
//     data['address_line_1'] = this.addressLine1;
//     data['address_line_2'] = this.addressLine2;
//     data['landmark'] = this.landmark;
//     data['city'] = this.city;
//     if (this.state != null) {
//       data['state'] = this.state!.toJson();
//     }
//     return data;
//   }
// }

// class State {
//   String? stateId;
//   String? stateName;

//   State({this.stateId, this.stateName});

//   State.fromJson(Map<String, dynamic> json) {
//     stateId = json['state_id'];
//     stateName = json['state_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['state_id'] = this.stateId;
//     data['state_name'] = this.stateName;
//     return data;
//   }
// }

class GetStoreListModel {
  int? status;
  String? message;
  Data? data;

  GetStoreListModel({this.status, this.message, this.data});

  GetStoreListModel.fromJson(Map<String, dynamic> json) {
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
  List<Stores>? stores;

  Data({this.stores});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(new Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  String? storeId;
  Image? image;
  Image? logo;
  String? storeName;
  String? storeEin;
  List<StoreAddresses>? storeAddresses;

  Stores(
      {this.storeId,
      this.image,
      this.logo,
      this.storeName,
      this.storeEin,
      this.storeAddresses});

  Stores.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    logo = json['logo'] != null ? new Image.fromJson(json['logo']) : null;
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresses>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(new StoreAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['store_name'] = this.storeName;
    data['store_ein'] = this.storeEin;
    if (this.storeAddresses != null) {
      data['store_addresses'] =
          this.storeAddresses!.map((v) => v.toJson()).toList();
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

class StoreAddresses {
  String? storeAddressId;
  String? addressName;
  dynamic longitude;
  dynamic latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  State? state;

  StoreAddresses(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.state});

  StoreAddresses.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_address_id'] = this.storeAddressId;
    data['address_name'] = this.addressName;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    return data;
  }
}

class State {
  String? stateId;
  String? stateName;

  State({this.stateId, this.stateName});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    return data;
  }
}
