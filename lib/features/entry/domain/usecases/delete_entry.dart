import '../../../../core/usecases/usecase.dart';
import '../repositories/anxiety_entry_repository.dart';

class DeleteEntry implements UseCase<void, String> {
  final AnxietyEntryRepository repository;

  DeleteEntry(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteEntry(id);
  }
}