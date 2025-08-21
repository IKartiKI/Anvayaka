import 'package:flutter/material.dart';
import '../models/stock_item.dart';
import '../widgets/counterfeit_stock_card.dart';

class CounterfeitStockScreen extends StatelessWidget {
  const CounterfeitStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive grid configuration - always 2 columns but with better aspect ratio
    final crossAxisCount = 2;
    final childAspectRatio = screenWidth < 600 ? 1.2 : 1.5;
    
    final List<StockItem> counterfeitItems = [
      StockItem(
        name: 'Counterfeit Bolts',
        category: 'Hardware',
        threshold: 'N/A',
        quantity: '15 sets',
        trend: 'up',
        isLowStock: false,
      ),
      StockItem(
        name: 'Defective Paint',
        category: 'Finishing',
        threshold: 'N/A',
        quantity: '8 liters',
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
            'Counterfeit Stock',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Defective and counterfeit inventory',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red[400], size: 18),
              const SizedBox(width: 4),
              const Text(
                '2 Issues Found',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
              itemCount: counterfeitItems.length,
              itemBuilder: (context, index) {
                return CounterfeitStockCard(stockItem: counterfeitItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
