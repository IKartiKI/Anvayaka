// lib/widgets/labour_card.dart
import 'package:flutter/material.dart';
import '../models/labour.dart';

class LabourCard extends StatelessWidget {
  final Labour labour;

  const LabourCard({super.key, required this.labour});

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    return 'NA';
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
                    _getInitials(labour.name),
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
                        labour.name,
                        style: TextStyle(
                          fontSize: nameFontSize, 
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Age: ${labour.age} years',
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
              'Expertise: ${labour.expertise}',
              style: TextStyle(fontSize: expertiseFontSize),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

          ],
        ),
      ),
    );
  }
}
