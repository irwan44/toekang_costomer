class TimeSlotsSettings {
  TimeSlotsSettings({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final TimeSlotsData data;

  TimeSlotsSettings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = TimeSlotsData.fromJson(json['data']);
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

class TimeSlotsData {
  TimeSlotsData({
    required this.timeSlotsIsEnabled,
    required this.timeSlotsDeliveryStartsFrom,
    required this.timeSlotsAllowedDays,
    required this.timeSlots,
  });

  late final String timeSlotsIsEnabled;
  late final String timeSlotsDeliveryStartsFrom;
  late final String timeSlotsAllowedDays;
  late final List<TimeSlots> timeSlots;

  TimeSlotsData.fromJson(Map<String, dynamic> json) {
    timeSlotsIsEnabled = json['time_slots_is_enabled'];
    timeSlotsDeliveryStartsFrom = json['time_slots_delivery_starts_from'];
    timeSlotsAllowedDays = json['time_slots_allowed_days'];
    timeSlots = List.from(json['time_slots'])
        .map((e) => TimeSlots.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time_slots_is_enabled'] = timeSlotsIsEnabled;
    _data['time_slots_delivery_starts_from'] = timeSlotsDeliveryStartsFrom;
    _data['time_slots_allowed_days'] = timeSlotsAllowedDays;
    _data['time_slots'] = timeSlots.map((e) => e.toJson()).toList();
    return _data;
  }
}

class TimeSlots {
  TimeSlots({
    required this.id,
    required this.title,
    required this.fromTime,
    required this.toTime,
    required this.lastOrderTime,
    required this.status,
  });

  late final int id;
  late final String title;
  late final String fromTime;
  late final String toTime;
  late final String lastOrderTime;
  late final int status;

  TimeSlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    lastOrderTime = json['last_order_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['from_time'] = fromTime;
    _data['to_time'] = toTime;
    _data['last_order_time'] = lastOrderTime;
    _data['status'] = status;
    return _data;
  }
}
