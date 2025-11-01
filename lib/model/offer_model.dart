import 'package:online_store/model/product_model.dart';

class OfferModel {
  final int id;
  final String name;
  final String type;
  final String value;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final List<ProductTarget> productTargets; // ⚠️ تم التغيير هنا
  final List<int> categoryTargets;

  OfferModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.startsAt,
    required this.endsAt,
    required this.isActive,
    required this.productTargets,
    required this.categoryTargets,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      value: json['value']?.toString() ?? '0',
      startsAt: json['startsAt'] != null
          ? DateTime.tryParse(json['startsAt'])
          : null,
      endsAt: json['endsAt'] != null ? DateTime.tryParse(json['endsAt']) : null,
      isActive: json['isActive'] ?? false,
    productTargets:
          (json['productTargets'] as List?)
              ?.map((e) => ProductTarget.fromJson(e))
              .toList() ??
          [],
      categoryTargets:
          (json['categoryTargets'] as List?)
              ?.map((e) => int.tryParse(e['categoryId'].toString()) ?? 0)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'value': value,
    'startsAt': startsAt?.toIso8601String(),
    'endsAt': endsAt?.toIso8601String(),
    'isActive': isActive,
    'productTargets': productTargets,
    'categoryTargets': categoryTargets,
  };

OfferModel copyWith({
    int? id,
    String? name,
    Object? value,
    String? type,
    bool? isActive,
    DateTime? startsAt,
    DateTime? endsAt,
    List<ProductTarget>? productTargets, // ⚠️ عدّل هنا
    List<int>? categoryTargets,
  }) {
    return OfferModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value?.toString() ?? this.value,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      productTargets: productTargets ?? this.productTargets,
      categoryTargets: categoryTargets ?? this.categoryTargets,
    );
  }


}



class ProductTarget {
  final int productId;
  final ProductModel? product;

  ProductTarget({required this.productId, this.product});

  factory ProductTarget.fromJson(Map<String, dynamic> json) => ProductTarget(
    productId: int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
    product: json['product'] != null
        ? ProductModel.fromJson(json['product'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'product': product?.toJson(),
  };
}

