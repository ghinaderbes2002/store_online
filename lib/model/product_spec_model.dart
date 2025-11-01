class ProductSpecModel {
  final int id;
  final int productId;
  final int attributeId;
  final String value;

  ProductSpecModel({
    required this.id,
    required this.productId,
    required this.attributeId,
    required this.value,
  });

  factory ProductSpecModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecModel(
      id: json['id'],
      productId: json['productId'],
      attributeId: json['attributeId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'attributeId': attributeId,
    'value': value,
  };
}
