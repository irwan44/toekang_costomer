class Address {
  Address({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final List<AddressData> data;

  Address.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = List.from(json['data']).map((e) => AddressData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AddressData {
  AddressData({
    required this.id,
    required this.type,
    required this.name,
    required this.mobile,
    required this.alternateMobile,
    required this.address,
    required this.landmark,
    required this.area,
    required this.pincode,
    required this.cityId,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  late final int id;
  late final String type;
  late final String name;
  late final String mobile;
  late final String alternateMobile;
  late final String address;
  late final String landmark;
  late final String area;
  late final String pincode;
  late final int cityId;
  late final String city;
  late final String state;
  late final String country;
  late final String latitude;
  late final String longitude;
  late final int isDefault;

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    mobile = json['mobile'];
    alternateMobile = json['alternate_mobile'];
    address = json['address'];
    landmark = json['landmark'];
    area = json['area'];
    pincode = json['pincode'];
    cityId = json['city_id'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['name'] = name;
    _data['mobile'] = mobile;
    _data['alternate_mobile'] = alternateMobile;
    _data['address'] = address;
    _data['landmark'] = landmark;
    _data['area'] = area;
    _data['pincode'] = pincode;
    _data['city_id'] = cityId;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['is_default'] = isDefault;
    return _data;
  }
}
