import '../../../../core/usecases/usecase.dart';
import '../entities/anxiety_entry.dart';
import '../repositories/anxiety_entry_repository.dart';

class UpdateEntry implements UseCase<AnxietyEntry, AnxietyEntry> {
  final AnxietyEntryRepository repository;

  UpdateEntry(this.repository);

  @override
  Future<AnxietyEntry> call(AnxietyEntry entry) async {
    return await repository.updateEntry(entry);
  }
}