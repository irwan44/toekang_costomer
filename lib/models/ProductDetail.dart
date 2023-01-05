class ProductDetail {
  ProductDetail({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final Data data;

  ProductDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? "";
    total = json['total'] ?? 0;
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
    required this.id,
    required this.name,
    required this.taxId,
    required this.brandId,
    required this.slug,
    required this.categoryId,
    required this.indicator,
    required this.manufacturer,
    required this.madeIn,
    required this.returnStatus,
    required this.cancelableStatus,
    required this.tillStatus,
    required this.description,
    required this.status,
    required this.isApproved,
    required this.returnDays,
    required this.type,
    required this.isUnlimitedStock,
    required this.codAllowed,
    required this.totalAllowedQuantity,
    required this.taxIncludedInPrice,
    required this.dType,
    required this.sellerName,
    required this.images,
    required this.isFavorite,
    required this.variants,
    required this.imageUrl,
    this.selectedVariantIndex,
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
  late final int returnStatus;
  late final int cancelableStatus;
  late final String tillStatus;
  late final String description;
  late final int status;
  late final int isApproved;
  late final int returnDays;
  late final String type;
  late final int isUnlimitedStock;
  late final int codAllowed;
  late final int totalAllowedQuantity;
  late final int taxIncludedInPrice;
  late final String dType;
  late final String sellerName;
  late final List<String> images;
  late final bool isFavorite;
  late final List<ProductDetailVariants> variants;
  late final String imageUrl;
  late final int? selectedVariantIndex;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    taxId = json['tax_id'] ?? 0;
    brandId = json['brand_id'] ?? 0;
    slug = json['slug'] ?? "";
    categoryId = json['category_id'] ?? 0;
    indicator = json['indicator'] ?? 0;
    manufacturer = json['manufacturer'] ?? "";
    madeIn = json['made_in'] ?? "";
    returnStatus = json['return_status'] ?? 0;
    cancelableStatus = json['cancelable_status'] ?? 0;
    tillStatus = json['till_status'] ?? "";
    description = json['description'] ?? "";
    status = json['status'] ?? 0;
    isApproved = json['is_approved'] ?? 0;
    returnDays = json['return_days'] ?? 0;
    type = json['type'] ?? "";
    isUnlimitedStock = json['is_unlimited_stock'] ?? 0;
    codAllowed = json['cod_allowed'] ?? 0;
    totalAllowedQuantity = json['total_allowed_quantity'] ?? 0;
    taxIncludedInPrice = json['tax_included_in_price'] ?? 0;
    dType = json['d_type'] ?? "";
    sellerName = json['seller_name'] ?? "";
    images = List.castFrom<dynamic, String>(json['images']);
    isFavorite = json['is_favorite'] ?? false;
    variants = List.from(json['variants'])
        .map((e) => ProductDetailVariants.fromJson(e))
        .toList();
    imageUrl = json['image_url'] ?? "";
    selectedVariantIndex = json['selectedVariantIndex'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['tax_id'] = taxId;
    _data['brand_id'] = brandId;
    _data['slug'] = slug;
    _data['category_id'] = categoryId;
    _data['indicator'] = indicator;
    _data['manufacturer'] = manufacturer;
    _data['made_in'] = madeIn;
    _data['return_status'] = returnStatus;
    _data['cancelable_status'] = cancelableStatus;
    _data['till_status'] = tillStatus;
    _data['description'] = description;
    _data['status'] = status;
    _data['is_approved'] = isApproved;
    _data['return_days'] = returnDays;
    _data['type'] = type;
    _data['is_unlimited_stock'] = isUnlimitedStock;
    _data['cod_allowed'] = codAllowed;
    _data['total_allowed_quantity'] = totalAllowedQuantity;
    _data['tax_included_in_price'] = taxIncludedInPrice;
    _data['d_type'] = dType;
    _data['seller_name'] = sellerName;
    _data['images'] = images;
    _data['is_favorite'] = isFavorite;
    _data['variants'] = variants.map((e) => e.toJson()).toList();
    _data['image_url'] = imageUrl;
    return _data;
  }
}

class ProductDetailVariants {
  ProductDetailVariants({
    required this.id,
    required this.type,
    required this.measurement,
    required this.price,
    required this.discountedPrice,
    required this.stock,
    required this.stockUnitName,
    required this.cartCount,
    required this.status,
    required this.images,
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
  late final List<String> images;

  ProductDetailVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    measurement = double.parse(json['measurement'].toString());
    price = double.parse(json['price'].toString());
    discountedPrice = double.parse(json['discounted_price'].toString());
    stock = double.parse(json['stock'].toString());
    stockUnitName = json['stock_unit_name'];
    cartCount = int.parse(json['cart_count'].toString());
    status = int.parse(json['status'].toString());
    images = List.castFrom<dynamic, String>(json['images']);
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
    data['images'] = images;
    return data;
  }
}
