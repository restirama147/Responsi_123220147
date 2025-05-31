class PhoneModel {
  String? status;
  String? message;
  List<Phone>? data;

  PhoneModel({this.status, this.message, this.data});

  PhoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Phone>[];
      json['data'].forEach((v) {
        data!.add(Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phone {
  int? id;
  String? model;
  String? brand;
  double? price;
  String? imageUrl;
  int? ram;
  int? storage;
  String? websiteUrl;

  Phone(
      {this.id,
      this.model,
      this.brand,
      this.price,
      this.imageUrl,
      this.ram,
      this.storage,
      this.websiteUrl});

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    brand = json['brand'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    ram = json['ram'];
    storage = json['storage'];
    websiteUrl = json['websiteUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['ram'] = ram;
    data['storage'] = storage;
    data['websiteUrl'] = websiteUrl;
    return data;
  }
}

