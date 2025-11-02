import 'package:online_store/model/brand_model.dart';
import 'package:online_store/model/category_model.dart';

class ProductModel {
  final int id;
  String name;
  String sku;
  String? description; // إضافة الوصف
  String? imageUrl; // إضافة رابط الصورة
  int priceCents;
  int stockQty;
  bool isActive;
  int? categoryId;
  int? brandId;
  Map<String, String>? features; // تعديل نوع القيم إلى String

  BrandModel? brand;
  CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    this.imageUrl,
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
      name: json['name']?.toString() ?? '-',
      sku: json['sku']?.toString() ?? '-',
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
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
          ? Map<String, String>.from(json['features'])
          : {},
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
    'description': description,
    'imageUrl': imageUrl,
    'priceCents': priceCents,
    'stockQty': stockQty,
    'isActive': isActive,
    'categoryId': categoryId,
    'brandId': brandId,
    'features': features,
    'brand': brand?.toJson(),
    'category': category?.toJson(),
  };

  ProductModel copyWith({
    int? id,
    String? name,
    String? sku,
    String? description,
    String? imageUrl,
    int? priceCents,
    int? stockQty,
    bool? isActive,
    int? categoryId,
    int? brandId,
    Map<String, String>? features,
    BrandModel? brand,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      priceCents: priceCents ?? this.priceCents,
      stockQty: stockQty ?? this.stockQty,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      features: features ?? Map<String, String>.from(this.features ?? {}),
      brand: brand ?? this.brand,
      category: category ?? this.category,
    );
  }
}
