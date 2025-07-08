import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/anxiety_entry_model.dart';

abstract class AnxietyEntryLocalDataSource {
  Future<List<AnxietyEntryModel>> getAllEntries();
  Future<AnxietyEntryModel?> getEntryById(String id);
  Future<AnxietyEntryModel> createEntry(AnxietyEntryModel entry);
  Future<AnxietyEntryModel> updateEntry(AnxietyEntryModel entry);
  Future<void> deleteEntry(String id);
  Future<List<AnxietyEntryModel>> getEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}

class AnxietyEntryLocalDataSourceImpl implements AnxietyEntryLocalDataSource {
  static const String _boxName = 'anxiety_entries';
  late Box<AnxietyEntryModel> _box;
  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    _box = await Hive.openBox<AnxietyEntryModel>(_boxName);
  }

  @override
  Future<List<AnxietyEntryModel>> getAllEntries() async {
    final entries = _box.values.toList();
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  @override
  Future<AnxietyEntryModel?> getEntryById(String id) async {
    return _box.get(id);
  }

  @override
  Future<AnxietyEntryModel> createEntry(AnxietyEntryModel entry) async {
    try {
      final id = _uuid.v4();
      final newEntry = entry.copyWith(id: id);
      await _box.put(id, newEntry);
      return newEntry;
    } catch (e) {
      throw Exception('데이터 저장 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<AnxietyEntryModel> updateEntry(AnxietyEntryModel entry) async {
    if (entry.id == null) {
      throw Exception('Entry ID cannot be null for update operation');
    }
    await _box.put(entry.id!, entry);
    return entry;
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<AnxietyEntryModel>> getEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = _box.values.where((entry) {
      return entry.timestamp.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entry.timestamp.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }
}