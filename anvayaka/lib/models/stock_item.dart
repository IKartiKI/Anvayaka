// lib/models/stock_item.dart
class StockItem {
  final String name;
  final String category;
  final String threshold;
  final String quantity;
  final String trend; // 'up' or 'down'
  final bool isLowStock;
  final bool isCounterfeit;

  StockItem({
    required this.name,
    required this.category,
    required this.threshold,
    required this.quantity,
    required this.trend,
    this.isLowStock = false,
    this.isCounterfeit = false,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      name: json['name'],
      category: json['category'],
      threshold: json['threshold'],
      quantity: json['quantity'],
      trend: json['trend'],
      isLowStock: json['isLowStock'] ?? false,
      isCounterfeit: json['isCounterfeit'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'threshold': threshold,
      'quantity': quantity,
      'trend': trend,
      'isLowStock': isLowStock,
      'isCounterfeit': isCounterfeit,
    };
  }
}