class DashboardSummary {
  final int totalProducts;
  final int totalOrders;
  final int totalCustomers;

  DashboardSummary({
    required this.totalProducts,
    required this.totalOrders,
    required this.totalCustomers,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalProducts: json['totalProducts'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
    );
  }
}
