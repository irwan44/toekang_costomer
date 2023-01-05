class CartData {
  CartData({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final Data data;

  CartData.fromJson(Map<String, dynamic> json) {
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
    required this.subTotal,
    required this.cart,
  });

  late final double subTotal;
  late final List<Cart> cart;

  Data.fromJson(Map<String, dynamic> json) {
    subTotal = double.parse(json['sub_total'].toString());
    cart = List.from(json['cart']).map((e) => Cart.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sub_total'] = subTotal;
    _data['cart'] = cart.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Cart {
  Cart({
    required this.productId,
    required this.productVariantId,
    required this.qty,
    required this.isDeliverable,
    required this.measurement,
    required this.discountedPrice,
    required this.price,
    required this.stock,
    required this.totalAllowedQuantity,
    required this.name,
    required this.unit,
    required this.status,
    required this.imageUrl,
  });

  late final int productId;
  late final int productVariantId;
  late final int qty;
  late final int isDeliverable;
  late final int isUnlimitedStock;
  late final double measurement;
  late final double discountedPrice;
  late final double price;
  late final double stock;
  late final double totalAllowedQuantity;
  late final String name;
  late final String unit;
  late final int status;
  late final String imageUrl;

  Cart.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    qty = json['qty'];
    isDeliverable = json['is_deliverable'];
    isUnlimitedStock = json['is_unlimited_stock'];
    measurement = double.parse(json['measurement'].toString());
    discountedPrice = double.parse(json['discounted_price'].toString());
    price = double.parse(json['price'].toString());
    stock = double.parse(json['stock'].toString());
    totalAllowedQuantity =
        double.parse(json['total_allowed_quantity'].toString());
    name = json['name'];
    unit = json['unit'];
    status = json['status'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_variant_id'] = productVariantId;
    data['qty'] = qty;
    data['is_deliverable'] = isDeliverable;
    data['is_deliverable'] = isUnlimitedStock;
    data['measurement'] = measurement;
    data['discounted_price'] = discountedPrice;
    data['price'] = price;
    data['stock'] = stock;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['name'] = name;
    data['unit'] = unit;
    data['status'] = status;
    data['image_url'] = imageUrl;
    return data;
  }
}
