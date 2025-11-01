class AttributeModel {
  final int id;
  final String name;
  final String? unit;
  final int? categoryId;

  AttributeModel({
    required this.id,
    required this.name,
    this.unit,
    this.categoryId,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'unit': unit,
    'categoryId': categoryId,
  };
}
