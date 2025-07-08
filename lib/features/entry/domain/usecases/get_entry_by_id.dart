import '../../../../core/usecases/usecase.dart';
import '../entities/anxiety_entry.dart';
import '../repositories/anxiety_entry_repository.dart';

class GetEntryById implements UseCase<AnxietyEntry?, String> {
  final AnxietyEntryRepository repository;

  GetEntryById(this.repository);

  @override
  Future<AnxietyEntry?> call(String id) async {
    return await repository.getEntryById(id);
  }
}