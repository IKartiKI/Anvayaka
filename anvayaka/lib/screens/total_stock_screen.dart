// lib/screens/total_stock_screen.dart
import 'package:flutter/material.dart';
import '../models/stock_item.dart';
import '../widgets/stock_card.dart';

class TotalStockScreen extends StatelessWidget {
  const TotalStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive grid configuration - always 2 columns but with better aspect ratio
    final crossAxisCount = 2;
    final childAspectRatio = screenWidth < 600 ? 1.2 : 1.5;
    
    final List<StockItem> stockItems = [
      StockItem(
        name: 'Steel Sheets',
        category: 'Raw Materials',
        threshold: '50 pieces',
        quantity: '150 pieces',
        trend: 'down',
        isLowStock: false,
      ),
      StockItem(
        name: 'Welding Rods',
        category: 'Consumables',
        threshold: '30 boxes',
        quantity: '25 boxes',
        trend: 'down',
        isLowStock: true,
      ),
      StockItem(
        name: 'Paint Cans',
        category: 'Finishing',
        threshold: '20 liters',
        quantity: '45 liters',
        trend: 'up',
        isLowStock: false,
      ),
      StockItem(
        name: 'Bolts & Nuts',
        category: 'Hardware',
        threshold: '100 sets',
        quantity: '500 sets',
        trend: 'up',
        isLowStock: false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Stock',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Current inventory levels',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '4 Product Types',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: stockItems.length,
              itemBuilder: (context, index) {
                return StockCard(stockItem: stockItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}