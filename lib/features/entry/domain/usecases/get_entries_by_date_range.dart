import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/anxiety_entry.dart';
import '../repositories/anxiety_entry_repository.dart';

class GetEntriesByDateRange implements UseCase<List<AnxietyEntry>, DateRangeParams> {
  final AnxietyEntryRepository repository;

  GetEntriesByDateRange(this.repository);

  @override
  Future<List<AnxietyEntry>> call(DateRangeParams params) async {
    return await repository.getEntriesByDateRange(params.startDate, params.endDate);
  }
}

class DateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}