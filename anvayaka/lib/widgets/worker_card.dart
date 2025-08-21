// lib/widgets/worker_card.dart
import 'package:flutter/material.dart';
import '../models/worker.dart';

class WorkerCard extends StatelessWidget {
  final Worker worker;

  const WorkerCard({super.key, required this.worker});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'idle':
        return Colors.yellow;
      case 'on-break':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive values
    final isSmallScreen = screenWidth < 600;
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final avatarRadius = isSmallScreen ? 16.0 : 20.0;
    final nameFontSize = isSmallScreen ? 14.0 : 16.0;
    final detailFontSize = isSmallScreen ? 11.0 : 12.0;
    final expertiseFontSize = isSmallScreen ? 12.0 : 14.0;
    final statusFontSize = isSmallScreen ? 10.0 : 12.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;
    final horizontalSpacing = isSmallScreen ? 8.0 : 12.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: avatarRadius,
                  child: Text(
                    worker.initials,
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: TextStyle(
                          fontSize: nameFontSize, 
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Age: ${worker.age} years',
                        style: TextStyle(
                          fontSize: detailFontSize, 
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Text(
              'Expertise: ${worker.expertise}',
              style: TextStyle(fontSize: expertiseFontSize),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Icon(
                  Icons.circle, 
                  size: isSmallScreen ? 10 : 12, 
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    worker.status,
                    style: TextStyle(
                      fontSize: statusFontSize,
                      color: _getStatusColor(worker.status),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}