import '../../../../core/usecases/usecase.dart';
import '../entities/anxiety_entry.dart';
import '../repositories/anxiety_entry_repository.dart';

class GetAllEntries implements UseCase<List<AnxietyEntry>, NoParams> {
  final AnxietyEntryRepository repository;

  GetAllEntries(this.repository);

  @override
  Future<List<AnxietyEntry>> call(NoParams params) async {
    return await repository.getAllEntries();
  }
}