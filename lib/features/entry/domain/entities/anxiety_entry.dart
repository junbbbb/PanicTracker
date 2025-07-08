import 'package:equatable/equatable.dart';

class AnxietyEntry extends Equatable {
  const AnxietyEntry({
    this.id,
    required this.timestamp,
    required this.trigger,
    required this.symptoms,
    required this.negativeThoughts,
    required this.copingStrategy,
    required this.durationInMinutes,
    required this.intensityLevel,
  });

  final String? id;
  final DateTime timestamp;
  final String trigger;
  final List<String> symptoms;
  final String negativeThoughts;
  final String copingStrategy;
  final int durationInMinutes;
  final int intensityLevel;

  AnxietyEntry copyWith({
    String? id,
    DateTime? timestamp,
    String? trigger,
    List<String>? symptoms,
    String? negativeThoughts,
    String? copingStrategy,
    int? durationInMinutes,
    int? intensityLevel,
  }) {
    return AnxietyEntry(
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

  @override
  List<Object?> get props => [
        id,
        timestamp,
        trigger,
        symptoms,
        negativeThoughts,
        copingStrategy,
        durationInMinutes,
        intensityLevel,
      ];
}