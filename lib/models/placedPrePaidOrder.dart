class PlacedPrePaidOrder {
  PlacedPrePaidOrder({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final PlacedPrePaidOrderData data;

  PlacedPrePaidOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = PlacedPrePaidOrderData.fromJson(json['data']);
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

class PlacedPrePaidOrderData {
  PlacedPrePaidOrderData({
    required this.orderId,
  });

  late final int orderId;

  PlacedPrePaidOrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_id'] = orderId;
    return _data;
  }
}
