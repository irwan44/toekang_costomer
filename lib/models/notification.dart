class NotificationList {
  NotificationList({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final List<NotificationListData> data;

  NotificationList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = List.from(json['data'])
        .map((e) => NotificationListData.fromJson(e))
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

class NotificationListData {
  NotificationListData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.typeId,
    required this.imageUrl,
  });

  late final int id;
  late final String title;
  late final String message;
  late final String type;
  late final int typeId;
  late final String imageUrl;

  NotificationListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    typeId = json['type_id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['message'] = message;
    _data['type'] = type;
    _data['type_id'] = typeId;
    _data['image_url'] = imageUrl;
    return _data;
  }
}
