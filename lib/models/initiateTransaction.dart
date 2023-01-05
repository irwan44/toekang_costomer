class InitiateTransaction {
  InitiateTransaction({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final Data data;

  InitiateTransaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = Data.fromJson(json['data']);
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

class Data {
  Data({
    required this.paymentMethod,
    required this.transactionId,
  });

  late final String paymentMethod;
  late final String transactionId;

  Data.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['payment_method'] = paymentMethod;
    _data['transaction_id'] = transactionId;
    return _data;
  }
}
