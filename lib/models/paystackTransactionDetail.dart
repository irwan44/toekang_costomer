class PaystackTransactionDetail {
  PaystackTransactionDetail({
    required this.status,
    required this.message,
    required this.data,
  });

  late final bool status;
  late final String message;
  late final PaystackTransactionDetailData data;

  PaystackTransactionDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = PaystackTransactionDetailData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class PaystackTransactionDetailData {
  PaystackTransactionDetailData({
    required this.id,
  });

  late final int id;

  PaystackTransactionDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;

    return _data;
  }
}
