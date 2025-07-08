import 'package:hive/hive.dart';
import 'package:claudeapp/features/entry/domain/entities/anxiety_entry.dart';

part 'anxiety_entry_model.g.dart';

@HiveType(typeId: 0)
class AnxietyEntryModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime timestamp;

  @HiveField(2)
  String trigger;

  @HiveField(3)
  List<String> symptoms;

  @HiveField(4)
  String negativeThoughts;

  @HiveField(5)
  String copingStrategy;

  @HiveField(6)
  int durationInMinutes;

  @HiveField(7)
  int intensityLevel;

  AnxietyEntryModel({
    this.id,
    required this.timestamp,
    required this.trigger,
    required this.symptoms,
    required this.negativeThoughts,
    required this.copingStrategy,
    required this.durationInMinutes,
    required this.intensityLevel,
  });

  factory AnxietyEntryModel.fromEntity(AnxietyEntry entity) {
    return AnxietyEntryModel(
      id: entity.id,
      timestamp: entity.timestamp,
      trigger: entity.trigger,
      symptoms: entity.symptoms,
      negativeThoughts: entity.negativeThoughts,
      copingStrategy: entity.copingStrategy,
      durationInMinutes: entity.durationInMinutes,
      intensityLevel: entity.intensityLevel,
    );
  }

  AnxietyEntry toEntity() {
    return AnxietyEntry(
      id: id,
      timestamp: timestamp,
      trigger: trigger,
      symptoms: symptoms,
      negativeThoughts: negativeThoughts,
      copingStrategy: copingStrategy,
      durationInMinutes: durationInMinutes,
      intensityLevel: intensityLevel,
    );
  }

  AnxietyEntryModel copyWith({
    String? id,
    DateTime? timestamp,
    String? trigger,
    List<String>? symptoms,
    String? negativeThoughts,
    String? copingStrategy,
    int? durationInMinutes,
    int? intensityLevel,
  }) {
    return AnxietyEntryModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      trigger: trigger ?? this.trigger,
      symptoms: symptoms ?? this.symptoms,
      negativeThoughts: negativeThoughts ?? this.negativeThoughts,
      copingStrategy: copingStrategy ?? this.copingStrategy,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      intensityLevel: intensityLevel ?? this.intensityLevel,
    );
  }
}