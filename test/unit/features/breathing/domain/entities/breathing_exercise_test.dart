import 'package:flutter_test/flutter_test.dart';
import 'package:claudeapp/features/breathing/domain/entities/breathing_exercise.dart';

void main() {
  group('BreathingExercise', () {
    test('should create BreathingExercise with correct properties', () {
      // Arrange
      const type = BreathingType.fourSevenEight;
      const title = '4-7-8 호흡법';
      const description = '4초 들이쉬고, 7초 멈추고, 8초 내쉬기';
      const totalDurationMinutes = 5;

      // Act
      const exercise = BreathingExercise(
        type: type,
        title: title,
        description: description,
        totalDurationMinutes: totalDurationMinutes,
      );

      // Assert
      expect(exercise.type, type);
      expect(exercise.title, title);
      expect(exercise.description, description);
      expect(exercise.totalDurationMinutes, totalDurationMinutes);
    });

    test('should return correct cycle duration for 4-7-8 breathing', () {
      // Arrange
      const exercise = BreathingExercise(
        type: BreathingType.fourSevenEight,
        title: '4-7-8 호흡법',
        description: '4초 들이쉬고, 7초 멈추고, 8초 내쉬기',
        totalDurationMinutes: 5,
      );

      // Act
      final cycleDuration = exercise.getCycleDuration();

      // Assert
      expect(cycleDuration, 19); // 4 + 7 + 8 = 19초
    });

    test('should return correct cycle duration for box breathing', () {
      // Arrange
      const exercise = BreathingExercise(
        type: BreathingType.box,
        title: '박스 호흡법',
        description: '4초씩 들이쉬고, 멈추고, 내쉬고, 멈추기',
        totalDurationMinutes: 3,
      );

      // Act
      final cycleDuration = exercise.getCycleDuration();

      // Assert
      expect(cycleDuration, 16); // 4 + 4 + 4 + 4 = 16초
    });

    test('should return correct phases for 4-7-8 breathing', () {
      // Arrange
      const exercise = BreathingExercise(
        type: BreathingType.fourSevenEight,
        title: '4-7-8 호흡법',
        description: '4초 들이쉬고, 7초 멈추고, 8초 내쉬기',
        totalDurationMinutes: 5,
      );

      // Act
      final phases = exercise.getPhases();

      // Assert
      expect(phases.length, 3);
      expect(phases[0].type, BreathingPhaseType.inhale);
      expect(phases[0].duration, 4);
      expect(phases[1].type, BreathingPhaseType.hold);
      expect(phases[1].duration, 7);
      expect(phases[2].type, BreathingPhaseType.exhale);
      expect(phases[2].duration, 8);
    });

    test('should return correct phases for box breathing', () {
      // Arrange
      const exercise = BreathingExercise(
        type: BreathingType.box,
        title: '박스 호흡법',
        description: '4초씩 들이쉬고, 멈추고, 내쉬고, 멈추기',
        totalDurationMinutes: 3,
      );

      // Act
      final phases = exercise.getPhases();

      // Assert
      expect(phases.length, 4);
      expect(phases[0].type, BreathingPhaseType.inhale);
      expect(phases[0].duration, 4);
      expect(phases[1].type, BreathingPhaseType.hold);
      expect(phases[1].duration, 4);
      expect(phases[2].type, BreathingPhaseType.exhale);
      expect(phases[2].duration, 4);
      expect(phases[3].type, BreathingPhaseType.hold);
      expect(phases[3].duration, 4);
    });
  });
} 