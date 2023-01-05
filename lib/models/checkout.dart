class Checkout {
  Checkout({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final DeliveryChargeData data;

  Checkout.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = DeliveryChargeData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data.toJson();
    return _data;
  }
}

class DeliveryChargeData {
  DeliveryChargeData({
    required this.isCodAllowed,
    required this.productVariantId,
    required this.quantity,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.subTotal,
    required this.savedAmount,
  });

  late final int isCodAllowed;
  late final String productVariantId;
  late final String quantity;
  late final DeliveryCharge deliveryCharge;
  late final double totalAmount;
  late final double subTotal;
  late final double savedAmount;

  DeliveryChargeData.fromJson(Map<String, dynamic> json) {
    isCodAllowed = json['cod_allowed'];
    productVariantId = json['product_variant_id'];
    quantity = json['quantity'];
    deliveryCharge = DeliveryCharge.fromJson(json['delivery_charge']);
    totalAmount = double.parse(json['total_amount'].toString());
    subTotal = double.parse(json['sub_total'].toString());
    savedAmount = double.parse(json['saved_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cod_allowed'] = isCodAllowed;
    _data['product_variant_id'] = productVariantId;
    _data['quantity'] = quantity;
    _data['delivery_charge'] = deliveryCharge.toJson();
    _data['total_amount'] = totalAmount;
    _data['sub_total'] = subTotal;
    _data['saved_amount'] = savedAmount;
    return _data;
  }
}

class DeliveryCharge {
  DeliveryCharge({
    required this.totalDeliveryCharge,
    required this.sellersInfo,
  });

  late final double totalDeliveryCharge;
  late final List<SellersInfo> sellersInfo;

  DeliveryCharge.fromJson(Map<String, dynamic> json) {
    totalDeliveryCharge =
        double.parse(json['total_delivery_charge'].toString());
    sellersInfo = List.from(json['sellers_info'])
        .map((e) => SellersInfo.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_delivery_charge'] = totalDeliveryCharge;
    _data['sellers_info'] = sellersInfo.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SellersInfo {
  SellersInfo({
    required this.sellerName,
    required this.deliveryCharge,
    required this.distance,
    required this.duration,
  });

  late final String sellerName;
  late final double deliveryCharge;
  late final String distance;
  late final String duration;

  SellersInfo.fromJson(Map<String, dynamic> json) {
    sellerName = json['seller_name'];
    deliveryCharge = double.parse(json['delivery_charge'].toString());
    distance = json['distance'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['seller_name'] = sellerName;
    _data['delivery_charge'] = deliveryCharge;
    _data['distance'] = distance;
    _data['duration'] = duration;
    return _data;
  }
}
