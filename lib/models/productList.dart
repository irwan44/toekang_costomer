import 'package:egrocer/models/productListItem.dart';

class ProductList {
  ProductList({
    required this.status,
    required this.message,
    required this.total,
    required this.minPrice,
    required this.maxPrice,
    required this.totalMinPrice,
    required this.totalMaxPrice,
    required this.brands,
    required this.sizes,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final double minPrice;
  late final double maxPrice;
  late final double totalMinPrice;
  late final double totalMaxPrice;
  late final List<Brands> brands;
  late final List<Sizes> sizes;
  late final List<ProductListItem> data;

  ProductList.fromJson(Map<String, dynamic> json) {
    if (List.from(json['data'])
            .map((e) => ProductListItem.fromJson(e))
            .toList() !=
        []) {
      status = json['status'];
      message = json['message'];
      total = json['total'];
      minPrice = double.parse(json['min_price'].toString());
      maxPrice = double.parse(json['max_price'].toString());
      totalMinPrice = double.parse(json['total_min_price'].toString());
      totalMaxPrice = double.parse(json['total_max_price'].toString());
      brands =
          List.from(json['brands']).map((e) => Brands.fromJson(e)).toList();
      sizes = List.from(json['sizes']).map((e) => Sizes.fromJson(e)).toList();
      data = List.from(json['data'])
          .map((e) => ProductListItem.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['min_price'] = minPrice;
    _data['max_price'] = maxPrice;
    _data['total_min_price'] = totalMinPrice;
    _data['total_max_price'] = totalMaxPrice;
    _data['brands'] = brands.map((e) => e.toJson()).toList();
    _data['sizes'] = sizes.map((e) => e.toJson()).toList();
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Brands {
  Brands({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  late final int id;
  late final String name;
  late final String imageUrl;

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image_url'] = imageUrl;
    return _data;
  }
}

class Sizes {
  Sizes({
    required this.size,
    required this.shortCode,
    required this.unitId,
  });

  late final double size;
  late final String shortCode;
  late final int unitId;

  Sizes.fromJson(Map<String, dynamic> json) {
    size = double.parse(json['size'].toString());
    shortCode = json['short_code'];
    unitId = json['unit_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['size'] = size;
    _data['short_code'] = shortCode;
    _data['unit_id'] = unitId;
    return _data;
  }
}
