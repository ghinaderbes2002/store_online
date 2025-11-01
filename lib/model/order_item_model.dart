class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final String nameSnapshot;
  final String skuSnapshot;
  final int unitPriceCents;
  final int qty;
  final int lineTotalCents;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.nameSnapshot,
    required this.skuSnapshot,
    required this.unitPriceCents,
    required this.qty,
    required this.lineTotalCents,
  });

factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: int.parse(json['id'].toString()),
      orderId: int.parse(json['orderId'].toString()),
      productId: int.parse(json['productId'].toString()),
      nameSnapshot: json['nameSnapshot'] ?? '',
      skuSnapshot: json['skuSnapshot'] ?? '',
      unitPriceCents:
          int.tryParse(json['unitPriceCents']?.toString() ?? '0') ?? 0,
      qty: int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      lineTotalCents:
          int.tryParse(json['lineTotalCents']?.toString() ?? '0') ?? 0,
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'productId': productId,
    'nameSnapshot': nameSnapshot,
    'skuSnapshot': skuSnapshot,
    'unitPriceCents': unitPriceCents,
    'qty': qty,
    'lineTotalCents': lineTotalCents,
  };
}
