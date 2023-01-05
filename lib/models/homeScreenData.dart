import 'package:egrocer/models/productListItem.dart';

class HomeScreenData {
  HomeScreenData({
    required this.category,
    required this.sliders,
    required this.offers,
    required this.sections,
  });

  late final List<Category> category;
  late final List<Sliders> sliders;
  late final List<Offers> offers;
  late final List<Sections> sections;

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    sliders =
        List.from(json['sliders']).map((e) => Sliders.fromJson(e)).toList();
    offers = List.from(json['offers']).map((e) => Offers.fromJson(e)).toList();
    sections =
        List.from(json['sections']).map((e) => Sections.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category.map((e) => e.toJson()).toList();
    _data['sliders'] = sliders.map((e) => e.toJson()).toList();
    _data['offers'] = offers.map((e) => e.toJson()).toList();
    _data['sections'] = sections.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.hasChild,
    required this.imageUrl,
  });

  late final int id;
  late final String name;
    late final String subtitle;
    late final bool hasChild;
  late final String imageUrl;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subtitle = json['subtitle'];
    hasChild = json['has_child'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['subtitle'] = subtitle;
    _data['has_child'] = hasChild;
    _data['image_url'] = imageUrl;
    return _data;
  }
}

class Sliders {
  Sliders({
    required this.id,
    required this.type,
    required this.typeId,
    required this.sliderUrl,
    required this.typeName,
    required this.imageUrl,
  });

  late final int id;
  late final String type;
  late final int typeId;
  late final String sliderUrl;
  late final String typeName;
  late final String imageUrl;

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeId = json['type_id'];
    sliderUrl = json['slider_url'];
    typeName = json['type_name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['type_id'] = typeId;
    _data['slider_url'] = sliderUrl;
    _data['type_name'] = typeName;
    _data['image_url'] = imageUrl;
    return _data;
  }
}

class Offers {
  Offers({
    required this.id,
    required this.position,
    required this.sectionPosition,
    required this.imageUrl,
  });

  late final int id;
  late final String position;
  late final String sectionPosition;
  late final String imageUrl;

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    sectionPosition = json['section_position'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['position'] = position;
    _data['section_position'] = sectionPosition;
    _data['image_url'] = imageUrl;
    return _data;
  }
}

class Sections {
  Sections({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.productType,
    required this.products,
  });

  late final int id;
  late final String title;
  late final String shortDescription;
  late final String productType;
  late final List<ProductListItem> products;

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    productType = json['product_type'];
    products = List.from(json['products'])
        .map((e) => ProductListItem.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['short_description'] = shortDescription;
    _data['product_type'] = productType;
    _data['products'] = products;
    return _data;
  }
}
