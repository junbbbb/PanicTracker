import '../../../../core/usecases/usecase.dart';
import '../entities/anxiety_entry.dart';
import '../repositories/anxiety_entry_repository.dart';

class CreateEntry implements UseCase<AnxietyEntry, AnxietyEntry> {
  final AnxietyEntryRepository repository;

  CreateEntry(this.repository);

  @override
  Future<AnxietyEntry> call(AnxietyEntry entry) async {
    return await repository.createEntry(entry);
  }
}