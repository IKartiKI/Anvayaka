import 'package:flutter/material.dart';
import '../models/stock_item.dart';

class CounterfeitStockCard extends StatelessWidget {
  final StockItem stockItem;

  const CounterfeitStockCard({super.key, required this.stockItem});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    // Responsive sizing
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
    final detailFontSize = isSmallScreen ? 10.0 : 12.0;
    final quantityFontSize = isSmallScreen ? 12.0 : 14.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;
    final iconSize = isSmallScreen ? 24.0 : 28.0;
    final smallIconSize = isSmallScreen ? 14.0 : 16.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    
    final bool isTrendUp = stockItem.trend.toLowerCase() == 'up';

    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Counterfeit Badge
            Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.red, size: iconSize),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8, 
                    vertical: isSmallScreen ? 2 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Counterfeit",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: badgeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),

            // Item Name
            Text(
              stockItem.name,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Category
            Text(
              stockItem.category,
              style: TextStyle(fontSize: detailFontSize, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            const Spacer(),

            // Quantity + Trend
            Row(
              children: [
                Expanded(
                  child: Text(
                    stockItem.quantity,
                    style: TextStyle(
                      fontSize: quantityFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Icon(
                  isTrendUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: smallIconSize,
                  color: isTrendUp ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
