import 'dart:convert';

class GeoAddress {
  int? id;
  double? lattitud;
  double? longitude;
  String? zipcode;
  String? name;
  String? mobile;
  String? type;
  String? address;
  String? landmark;
  String? area;
  String? city;
  String? state;
  String? district;
  String? country;
  String? alternateMobile;
  String? placeId;
  int? isDefault;

  GeoAddress({
    this.id,
    this.lattitud,
    this.longitude,
    this.zipcode,
    this.name,
    this.mobile,
    this.type,
    this.address,
    this.landmark,
    this.area,
    this.city,
    this.state,
    this.country,
    this.alternateMobile,
    this.isDefault,
    this.district,
    this.placeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lattitud': lattitud,
      'longitude': longitude,
      'zipcode': zipcode,
      'name': name,
      'mobile': mobile,
      'type': type,
      'address': address,
      'landmark': landmark,
      'area': area,
      'city': city,
      'state': state,
      'district': district,
      'country': country,
      'alternateMobile': alternateMobile,
      'placeId': placeId,
      'isDefault': isDefault,
    };
  }

  factory GeoAddress.fromMap(Map<String, dynamic> map) {
    return GeoAddress(
      id: map['id']?.toInt(),
      lattitud: map['lattitud']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      zipcode: map['zipcode'],
      name: map['name'],
      mobile: map['mobile'],
      type: map['type'],
      address: map['address'],
      landmark: map['landmark'],
      area: map['area'],
      city: map['city'],
      state: map['state'],
      district: map['district'],
      country: map['country'],
      alternateMobile: map['alternateMobile'],
      placeId: map['placeId'],
      isDefault: map['isDefault']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoAddress.fromJson(String source) =>
      GeoAddress.fromMap(json.decode(source));
}
