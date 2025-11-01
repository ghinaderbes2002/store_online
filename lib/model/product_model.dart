
import 'package:online_store/model/brand_model.dart';
import 'package:online_store/model/category_model.dart';

class ProductModel {
  final int id;
  String name;
  String sku;
  int priceCents;
  int stockQty;
  bool isActive;
  int? categoryId;
  int? brandId;
  Map<String, dynamic>? features;

  BrandModel? brand; // ⚡ جديد
  CategoryModel? category; // ⚡ جديد

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.priceCents,
    required this.stockQty,
    required this.isActive,
    this.categoryId,
    this.brandId,
    this.features,
    this.brand,
    this.category,
  });

 factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '-', // ⚡ إذا الاسم null
      sku: json['sku']?.toString() ?? '-', // ⚡ إذا SKU null
      priceCents: json['priceCents'] != null
          ? int.parse(json['priceCents'].toString())
          : 0,
      stockQty: json['stockQty'] != null
          ? int.parse(json['stockQty'].toString())
          : 0,
      isActive: json['isActive'] ?? true,
      categoryId: json['categoryId'] != null
          ? int.parse(json['categoryId'].toString())
          : null,
      brandId: json['brandId'] != null
          ? int.parse(json['brandId'].toString())
          : null,
      features: json['features'] != null
          ? Map<String, dynamic>.from(json['features'])
          : {}, // ⚡ بدل null خليها خريطة فارغة
      brand: json['brand'] != null ? BrandModel.fromJson(json['brand']) : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sku': sku,
    'priceCents': priceCents,
    'stockQty': stockQty,
    'isActive': isActive,
    'categoryId': categoryId,
    'brandId': brandId,
    'features': features,
    'brand': brand?.toJson(), // ⚡
    'category': category?.toJson(), // ⚡
  };
}
