class ProductListItem {
  ProductListItem({
    required this.id,
    required this.name,
    required this.taxId,
    required this.brandId,
    required this.slug,
    required this.categoryId,
    required this.indicator,
    required this.manufacturer,
    required this.madeIn,
    required this.isUnlimitedStock,
    required this.totalAllowedQuantity,
    required this.taxIncludedInPrice,
    required this.isFavorite,
    required this.variants,
    required this.imageUrl,
  });

  late final int id;
  late final String name;
  late final int taxId;
  late final int brandId;
  late final String slug;
  late final int categoryId;
  late final int indicator;
  late final String manufacturer;
  late final String madeIn;
  late final int isUnlimitedStock;
  late final int totalAllowedQuantity;
  late final int taxIncludedInPrice;
  late final bool isFavorite;
  late final List<Variants> variants;
  late final String imageUrl;

  ProductListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    taxId = json['tax_id'] ?? 0;
    brandId = json['brand_id'] ?? 0;
    slug = json['slug'] ?? "";
    categoryId = json['category_id'] ?? 0;
    indicator = json['indicator'] ?? 0;
    manufacturer = json['manufacturer'] ?? "";
    madeIn = json['made_in'] ?? "";
    isUnlimitedStock = json['is_unlimited_stock'] ?? 0;
    totalAllowedQuantity = json['total_allowed_quantity'] ?? 0;
    taxIncludedInPrice = json['tax_included_in_price'] ?? 0;
    isFavorite = json['is_favorite'] ?? false;
    variants =
        List.from(json['variants']).map((e) => Variants.fromJson(e)).toList();
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_id'] = taxId;
    data['brand_id'] = brandId;
    data['slug'] = slug;
    data['category_id'] = categoryId;
    data['indicator'] = indicator;
    data['manufacturer'] = manufacturer;
    data['made_in'] = madeIn;
    data['is_unlimited_stock'] = isUnlimitedStock;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['tax_included_in_price'] = taxIncludedInPrice;
    data['is_favorite'] = isFavorite;
    data['variants'] = variants.map((e) => e.toJson()).toList();
    data['image_url'] = imageUrl;
    return data;
  }
}

class Variants {
  Variants({
    required this.id,
    required this.type,
    required this.measurement,
    required this.price,
    required this.discountedPrice,
    required this.stock,
    required this.stockUnitName,
    required this.cartCount,
    required this.status,
    required this.taxableAmount,
  });

  late final int id;
  late final String type;
  late final double measurement;
  late final double price;
  late final double discountedPrice;
  late final double stock;
  late final String stockUnitName;
  late final int cartCount;
  late final int status;
  late final double taxableAmount;

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    type = json['type'] ?? "";
    measurement = double.parse(json['measurement'].toString());
    price = double.parse(json['price'].toString());
    discountedPrice = double.parse(json['discounted_price'].toString());
    stock = double.parse(json['stock'].toString());
    stockUnitName = json['stock_unit_name'] ?? "";
    cartCount = json['cart_count'] ?? 0;
    status = json['status'] ?? 0;
    taxableAmount = double.parse(json['taxable_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['measurement'] = measurement;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['stock'] = stock;
    data['stock_unit_name'] = stockUnitName;
    data['cart_count'] = cartCount;
    data['status'] = status;
    data['taxable_amount'] = taxableAmount;
    return data;
  }
}
