import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/anxiety_entry_local_data_source.dart';
import '../../data/models/anxiety_entry_model.dart';
import '../../data/repositories/anxiety_entry_repository_impl.dart';
import '../../domain/entities/anxiety_entry.dart';
import '../../domain/repositories/anxiety_entry_repository.dart';
import '../../domain/usecases/create_entry.dart';
import '../../domain/usecases/delete_entry.dart';
import '../../domain/usecases/get_all_entries.dart';
import '../../domain/usecases/get_entries_by_date_range.dart';
import '../../domain/usecases/get_entry_by_id.dart';
import '../../domain/usecases/update_entry.dart';
import '../../../../core/usecases/usecase.dart';

final hiveInitProvider = FutureProvider<void>((ref) async {
  await Hive.initFlutter();
  Hive.registerAdapter(AnxietyEntryModelAdapter());
  // Initialize the local data source
  final localDataSource = ref.read(localDataSourceProvider);
  if (localDataSource is AnxietyEntryLocalDataSourceImpl) {
    await localDataSource.init();
    
    // Add sample data if no entries exist
    final entries = await localDataSource.getAllEntries();
    if (entries.isEmpty) {
      await _addSampleData(localDataSource);
    }
  }
});

Future<void> _addSampleData(AnxietyEntryLocalDataSource dataSource) async {
  final sampleEntries = [
    AnxietyEntryModel(
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      trigger: '중요한 발표 준비',
      symptoms: ['심장 두근거림', '손떨림', '집중력 저하'],
      negativeThoughts: '실수할까봐 걱정된다. 모든 사람이 나를 판단할 것 같다.',
      copingStrategy: '심호흡을 하고 발표 내용을 여러 번 연습했다.',
      durationInMinutes: 45,
      intensityLevel: 7,
    ),
    AnxietyEntryModel(
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      trigger: '새로운 사람들과의 모임',
      symptoms: ['긴장감', '말더듬', '얼굴 빨개짐'],
      negativeThoughts: '내가 어색해 보일까? 대화에 끼지 못할 것 같다.',
      copingStrategy: '미리 대화 주제를 생각해보고 일찍 도착해서 적응 시간을 가졌다.',
      durationInMinutes: 30,
      intensityLevel: 5,
    ),
    AnxietyEntryModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      trigger: '업무 마감일 임박',
      symptoms: ['불면증', '식욕 저하', '초조함'],
      negativeThoughts: '시간이 부족하다. 완벽하게 할 수 없을 것 같다.',
      copingStrategy: '할 일을 세분화하고 우선순위를 정해서 차근차근 진행했다.',
      durationInMinutes: 60,
      intensityLevel: 8,
    ),
  ];

  for (final entry in sampleEntries) {
    await dataSource.createEntry(entry);
  }
}

final localDataSourceProvider = Provider<AnxietyEntryLocalDataSource>((ref) {
  return AnxietyEntryLocalDataSourceImpl();
});

final anxietyEntryRepositoryProvider = Provider<AnxietyEntryRepository>((ref) {
  return AnxietyEntryRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final createEntryUseCaseProvider = Provider<CreateEntry>((ref) {
  return CreateEntry(ref.watch(anxietyEntryRepositoryProvider));
});

final getAllEntriesUseCaseProvider = Provider<GetAllEntries>((ref) {
  return GetAllEntries(ref.watch(anxietyEntryRepositoryProvider));
});

final getEntryByIdUseCaseProvider = Provider<GetEntryById>((ref) {
  return GetEntryById(ref.watch(anxietyEntryRepositoryProvider));
});

final updateEntryUseCaseProvider = Provider<UpdateEntry>((ref) {
  return UpdateEntry(ref.watch(anxietyEntryRepositoryProvider));
});

final deleteEntryUseCaseProvider = Provider<DeleteEntry>((ref) {
  return DeleteEntry(ref.watch(anxietyEntryRepositoryProvider));
});

final getEntriesByDateRangeUseCaseProvider = Provider<GetEntriesByDateRange>((ref) {
  return GetEntriesByDateRange(ref.watch(anxietyEntryRepositoryProvider));
});

final entriesProvider = FutureProvider<List<AnxietyEntry>>((ref) async {
  final getAllEntries = ref.watch(getAllEntriesUseCaseProvider);
  return await getAllEntries(NoParams());
});

final entryFormProvider = StateNotifierProvider<EntryFormNotifier, EntryFormState>((ref) {
  return EntryFormNotifier(
    ref.watch(createEntryUseCaseProvider),
    ref.watch(updateEntryUseCaseProvider),
  );
});

class EntryFormState {
  final String trigger;
  final List<String> symptoms;
  final String negativeThoughts;
  final String copingStrategy;
  final int durationInMinutes;
  final int intensityLevel;
  final bool isLoading;
  final String? error;

  EntryFormState({
    this.trigger = '',
    this.symptoms = const [],
    this.negativeThoughts = '',
    this.copingStrategy = '',
    this.durationInMinutes = 0,
    this.intensityLevel = 5,
    this.isLoading = false,
    this.error,
  });

  EntryFormState copyWith({
    String? trigger,
    List<String>? symptoms,
    String? negativeThoughts,
    String? copingStrategy,
    int? durationInMinutes,
    int? intensityLevel,
    bool? isLoading,
    String? error,
  }) {
    return EntryFormState(
      trigger: trigger ?? this.trigger,
      symptoms: symptoms ?? this.symptoms,
      negativeThoughts: negativeThoughts ?? this.negativeThoughts,
      copingStrategy: copingStrategy ?? this.copingStrategy,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class EntryFormNotifier extends StateNotifier<EntryFormState> {
  final CreateEntry _createEntry;
  final UpdateEntry _updateEntry;

  EntryFormNotifier(this._createEntry, this._updateEntry) : super(EntryFormState());

  void updateTrigger(String trigger) {
    state = state.copyWith(trigger: trigger);
  }

  void updateSymptoms(List<String> symptoms) {
    state = state.copyWith(symptoms: symptoms);
  }

  void updateNegativeThoughts(String negativeThoughts) {
    state = state.copyWith(negativeThoughts: negativeThoughts);
  }

  void updateCopingStrategy(String copingStrategy) {
    state = state.copyWith(copingStrategy: copingStrategy);
  }

  void updateDuration(int durationInMinutes) {
    state = state.copyWith(durationInMinutes: durationInMinutes);
  }

  void updateIntensityLevel(int intensityLevel) {
    state = state.copyWith(intensityLevel: intensityLevel);
  }

  Future<bool> saveEntry({String? entryId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate input
      if (state.trigger.isEmpty) {
        throw Exception('유발 요인을 입력해주세요');
      }
      if (state.negativeThoughts.isEmpty) {
        throw Exception('부정적인 생각을 입력해주세요');
      }
      if (state.copingStrategy.isEmpty) {
        throw Exception('대처 방법을 입력해주세요');
      }
      if (state.durationInMinutes <= 0) {
        throw Exception('지속 시간을 올바르게 입력해주세요');
      }

      final entry = AnxietyEntry(
        id: entryId,
        timestamp: DateTime.now(),
        trigger: state.trigger,
        symptoms: state.symptoms,
        negativeThoughts: state.negativeThoughts,
        copingStrategy: state.copingStrategy,
        durationInMinutes: state.durationInMinutes,
        intensityLevel: state.intensityLevel,
      );

      if (entryId == null) {
        await _createEntry(entry);
      } else {
        await _updateEntry(entry);
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = EntryFormState();
  }
}