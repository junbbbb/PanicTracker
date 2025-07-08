import 'package:flutter/material.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';

class SummaryCard extends StatelessWidget {
  final List<AnxietyEntry> entries;

  const SummaryCard({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final recentEntries = entries.where((e) => e.timestamp.isAfter(lastWeek)).toList();
    
    final averageDuration = recentEntries.isEmpty
        ? 0
        : recentEntries.fold(0, (sum, entry) => sum + entry.durationInMinutes) / recentEntries.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Episodes',
                  recentEntries.length.toString(),
                  Icons.event,
                ),
                _buildStatItem(
                  'Avg Duration',
                  '${averageDuration.round()} min',
                  Icons.timer,
                ),
                _buildStatItem(
                  'Total',
                  '${entries.length}',
                  Icons.analytics,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}