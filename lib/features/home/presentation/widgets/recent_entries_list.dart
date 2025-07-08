import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';

class RecentEntriesList extends StatelessWidget {
  final List<AnxietyEntry> entries;

  const RecentEntriesList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final recentEntries = entries.take(5).toList();

    if (recentEntries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No entries yet. Tap the + button to add your first entry.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentEntries.map((entry) => _buildEntryCard(entry)).toList(),
    );
  }

  Widget _buildEntryCard(AnxietyEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.psychology, color: Colors.white),
        ),
        title: Text(
          entry.trigger,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy • HH:mm').format(entry.timestamp),
        ),
        trailing: Text(
          '${entry.durationInMinutes} min',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}