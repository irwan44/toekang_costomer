import 'package:egrocer/helper/utils/stringsRes.dart';

class Transaction {
  Transaction({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final List<TransactionData> data;

  Transaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = List.from(json['data'])
        .map((e) => TransactionData.fromJson(e))
        .toList();
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

class TransactionData {
  TransactionData({
    required this.id,
    required this.transactionType,
    required this.txnId,
    required this.type,
    required this.amount,
    required this.status,
    required this.message,
    required this.createdAt,
  });

  late final int id;
  late final String transactionType;
  late final String txnId;
  late final String type;
  late final String amount;
  late final String status;
  late final String message;
  late final String createdAt;

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    transactionType = json['transaction_type'].toString();
    txnId = json['txn_id'].toString();
    type = json['type'].toString();
    amount = json['amount'].toString();
    status = json['status'].toString();
    message = json['message'].toString();
    DateTime dateTime = DateTime.parse(json['created_at'].toString());
    createdAt =
        "${dateTime.day}-${StringsRes.lblMonthsNames[dateTime.month - 1]}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['transaction_type'] = transactionType;
    _data['txn_id'] = txnId;
    _data['type'] = type;
    _data['amount'] = amount;
    _data['status'] = status;
    _data['message'] = message;
    _data['created_at'] = createdAt;
    return _data;
  }
}
