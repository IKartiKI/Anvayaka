// lib/widgets/machine_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/machine.dart';

class MachineCard extends StatelessWidget {
  final Machine machine;

  const MachineCard({super.key, required this.machine});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'warning':
        return Colors.yellow;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _isOverdue(DateTime dueDate) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)); // IST adjustment
    return dueDate.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    // Responsive sizing
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
    final detailFontSize = isSmallScreen ? 10.0 : 12.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;
    final iconSize = isSmallScreen ? 14.0 : 16.0;
    final smallIconSize = isSmallScreen ? 10.0 : 12.0;
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Colors.grey, size: iconSize),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        machine.name,
                        style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Machine ID: ${machine.machineId}',
                        style: TextStyle(fontSize: detailFontSize, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Icon(Icons.circle, size: smallIconSize, color: Colors.grey),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    machine.status,
                    style: TextStyle(
                      fontSize: detailFontSize,
                      color: _getStatusColor(machine.status),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Icon(Icons.thermostat, size: iconSize, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '${machine.temperature}°C',
                  style: TextStyle(fontSize: detailFontSize),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Text(
              'Service Progress',
              style: TextStyle(fontSize: detailFontSize, color: Colors.grey),
            ),
            SizedBox(height: 4),
            LinearPercentIndicator(
              lineHeight: isSmallScreen ? 6.0 : 8.0,
              percent: (machine.serviceProgress / machine.serviceTotal).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200]!,
              progressColor: Colors.blue,
              barRadius: const Radius.circular(4),
              trailing: Text(
                '${((machine.serviceProgress / machine.serviceTotal * 100).clamp(0.0, 100.0)).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: detailFontSize),
              ),
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Icon(Icons.edit, size: iconSize, color: Colors.grey),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Service Due: ${DateFormat('dd/MM/yyyy').format(machine.serviceDue)}',
                    style: TextStyle(
                      fontSize: detailFontSize,
                      color: _isOverdue(machine.serviceDue) ? Colors.red : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (_isOverdue(machine.serviceDue))
                  Text(
                    ' (Overdue)',
                    style: TextStyle(fontSize: detailFontSize, color: Colors.red),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: iconSize, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '${machine.runningHours}h Hours',
                  style: TextStyle(fontSize: detailFontSize),
                ),
              ],
            ),
            if (_isOverdue(machine.serviceDue))
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Service overdue - immediate attention required',
                  style: TextStyle(fontSize: isSmallScreen ? 8 : 10, color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}