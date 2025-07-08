import '../../domain/entities/anxiety_entry.dart';
import '../../domain/repositories/anxiety_entry_repository.dart';
import '../datasources/anxiety_entry_local_data_source.dart';
import '../models/anxiety_entry_model.dart';

class AnxietyEntryRepositoryImpl implements AnxietyEntryRepository {
  final AnxietyEntryLocalDataSource localDataSource;

  AnxietyEntryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AnxietyEntry>> getAllEntries() async {
    final models = await localDataSource.getAllEntries();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AnxietyEntry?> getEntryById(String id) async {
    final model = await localDataSource.getEntryById(id);
    return model?.toEntity();
  }

  @override
  Future<AnxietyEntry> createEntry(AnxietyEntry entry) async {
    final model = AnxietyEntryModel.fromEntity(entry);
    final createdModel = await localDataSource.createEntry(model);
    return createdModel.toEntity();
  }

  @override
  Future<AnxietyEntry> updateEntry(AnxietyEntry entry) async {
    final model = AnxietyEntryModel.fromEntity(entry);
    final updatedModel = await localDataSource.updateEntry(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteEntry(String id) async {
    await localDataSource.deleteEntry(id);
  }

  @override
  Future<List<AnxietyEntry>> getEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final models = await localDataSource.getEntriesByDateRange(startDate, endDate);
    return models.map((model) => model.toEntity()).toList();
  }
}