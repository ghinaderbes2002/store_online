class CategoryModel {
  final int id;
  String name; // غير final عشان نقدر نعدل الاسم
  bool isActive; // غير final عشان نقدر نعدل الحالة
  final int? parentId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      parentId: json['parentId'] != null
          ? (json['parentId'] is int
                ? json['parentId']
                : int.tryParse(json['parentId'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isActive': isActive,
    'parentId': parentId,
  };
}
