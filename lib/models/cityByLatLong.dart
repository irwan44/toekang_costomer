class CityByLatLong {
  int? id;
  String? name;
  String? formattedAddress;
  String? latitude;
  String? longitude;
  String? deliveryChargeMethod;
  int? fixedCharge;
  int? perKmCharge;
  int? timeToTravel;
  int? maxDeliverableDistance;

  CityByLatLong(
      {int? id,
      String? name,
      String? formattedAddress,
      String? latitude,
      String? longitude,
      String? deliveryChargeMethod,
      int? fixedCharge,
      int? perKmCharge,
      int? timeToTravel,
      int? maxDeliverableDistance}) {
    if (id != null) {
      id = id;
    }
    if (name != null) {
      name = name;
    }
    if (formattedAddress != null) {
      formattedAddress = formattedAddress;
    }
    if (latitude != null) {
      latitude = latitude;
    }
    if (longitude != null) {
      longitude = longitude;
    }
    if (deliveryChargeMethod != null) {
      deliveryChargeMethod = deliveryChargeMethod;
    }
    if (fixedCharge != null) {
      fixedCharge = fixedCharge;
    }
    if (perKmCharge != null) {
      perKmCharge = perKmCharge;
    }
    if (timeToTravel != null) {
      timeToTravel = timeToTravel;
    }
    if (maxDeliverableDistance != null) {
      maxDeliverableDistance = maxDeliverableDistance;
    }
  }

  CityByLatLong.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    formattedAddress = json['formatted_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryChargeMethod = json['deliverycharge_method'];
    fixedCharge = json['fixedcharge'];
    perKmCharge = json['per_km_charge'];
    timeToTravel = json['time_to_travel'];
    maxDeliverableDistance = json['max_deliverable_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['formatted_address'] = formattedAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['delivery_charge_method'] = deliveryChargeMethod;
    data['fixed_charge'] = fixedCharge;
    data['per_km_charge'] = perKmCharge;
    data['time_to_travel'] = timeToTravel;
    data['max_deliverable_distance'] = maxDeliverableDistance;
    return data;
  }
}
