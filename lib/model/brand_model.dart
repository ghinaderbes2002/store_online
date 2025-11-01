class BrandModel {
  final int id;
  String name; // خلي الاسم قابل للتعديل
  bool isActive; // قابل للتعديل

  BrandModel({required this.id, required this.name, required this.isActive});

factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: int.parse(json['id'].toString()), // تحويل لأي int
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isActive': isActive,
  };
}
