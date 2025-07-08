import '../entities/anxiety_entry.dart';

abstract class AnxietyEntryRepository {
  Future<List<AnxietyEntry>> getAllEntries();
  Future<AnxietyEntry?> getEntryById(String id);
  Future<AnxietyEntry> createEntry(AnxietyEntry entry);
  Future<AnxietyEntry> updateEntry(AnxietyEntry entry);
  Future<void> deleteEntry(String id);
  Future<List<AnxietyEntry>> getEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}