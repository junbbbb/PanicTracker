import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:claudeapp/features/breathing/domain/entities/breathing_exercise.dart';
import 'package:claudeapp/features/breathing/domain/usecases/breathing_timer.dart';
import 'package:claudeapp/features/breathing/domain/repositories/breathing_timer_repository.dart';

class MockBreathingTimerRepository extends Mock implements BreathingTimerRepository {}

void main() {
  group('BreathingTimer', () {
    late BreathingTimer breathingTimer;
    late MockBreathingTimerRepository mockRepository;
    late BreathingExercise testExercise;

    setUp(() {
      mockRepository = MockBreathingTimerRepository();
      breathingTimer = BreathingTimer(mockRepository);
      testExercise = const BreathingExercise(
        type: BreathingType.fourSevenEight,
        title: '4-7-8 호흡법',
        description: '4초 들이쉬고, 7초 멈추고, 8초 내쉬기',
        totalDurationMinutes: 1,
      );
      
      // Mock 설정
      when(() => mockRepository.timerStream).thenAnswer(
        (_) => Stream.periodic(
          const Duration(seconds: 1),
          (i) => 4 - i,
        ).take(5),
      );
    });

    test('should initialize with idle state', () {
      // Assert
      expect(breathingTimer.state, BreathingTimerState.idle);
      expect(breathingTimer.currentPhaseIndex, 0);
      expect(breathingTimer.remainingSeconds, 0);
      expect(breathingTimer.progress, 0.0);
    });

    test('should start timer with exercise', () {
      // Act
      breathingTimer.start(testExercise);

      // Assert
      expect(breathingTimer.state, BreathingTimerState.running);
      expect(breathingTimer.exercise, testExercise);
      expect(breathingTimer.currentPhase, testExercise.getPhases()[0]);
      expect(breathingTimer.remainingSeconds, 4); // 첫 번째 단계는 4초
      verify(() => mockRepository.startTimer()).called(1);
    });

    test('should pause timer when running', () {
      // Arrange
      breathingTimer.start(testExercise);

      // Act
      breathingTimer.pause();

      // Assert
      expect(breathingTimer.state, BreathingTimerState.paused);
      verify(() => mockRepository.pauseTimer()).called(1);
    });

    test('should resume timer when paused', () {
      // Arrange
      breathingTimer.start(testExercise);
      breathingTimer.pause();

      // Act
      breathingTimer.resume();

      // Assert
      expect(breathingTimer.state, BreathingTimerState.running);
      verify(() => mockRepository.resumeTimer()).called(1);
    });

    test('should stop timer and reset state', () {
      // Arrange
      breathingTimer.start(testExercise);

      // Act
      breathingTimer.stop();

      // Assert
      expect(breathingTimer.state, BreathingTimerState.idle);
      expect(breathingTimer.currentPhaseIndex, 0);
      expect(breathingTimer.remainingSeconds, 0);
      expect(breathingTimer.progress, 0.0);
      verify(() => mockRepository.stopTimer()).called(1);
    });

    test('should update timer tick correctly', () {
      // Arrange
      breathingTimer.start(testExercise);
      const initialRemaining = 4;

      // Act
      breathingTimer.onTick(initialRemaining - 1);

      // Assert
      expect(breathingTimer.remainingSeconds, 3);
      expect(breathingTimer.progress, 0.25); // 1초 / 4초 = 0.25
    });

    test('should move to next phase when current phase ends', () {
      // Arrange
      breathingTimer.start(testExercise);

      // Act
      breathingTimer.onTick(0); // 현재 단계 종료

      // Assert
      expect(breathingTimer.currentPhaseIndex, 1);
      expect(breathingTimer.currentPhase, testExercise.getPhases()[1]);
      expect(breathingTimer.remainingSeconds, 7); // 두 번째 단계는 7초
    });

    test('should complete exercise when all phases are done', () {
      // Arrange
      breathingTimer.start(testExercise);
      final phases = testExercise.getPhases();

      // Act - 모든 단계를 완료
      for (int i = 0; i < phases.length; i++) {
        breathingTimer.onTick(0);
      }

      // Assert
      expect(breathingTimer.state, BreathingTimerState.completed);
      expect(breathingTimer.progress, 1.0);
      verify(() => mockRepository.stopTimer()).called(1);
    });

    test('should calculate correct total progress', () {
      // Arrange
      breathingTimer.start(testExercise);
      const totalCycleDuration = 19; // 4 + 7 + 8
      
      // Act - 첫 번째 단계에서 1초 진행
      breathingTimer.onTick(3); // 4초 중 1초 진행

      // Assert
      const expectedProgress = 1.0 / totalCycleDuration;
      expect(breathingTimer.totalProgress, closeTo(expectedProgress, 0.01));
    });

    test('should handle multiple cycles correctly', () {
      // Arrange
      breathingTimer.start(testExercise);
      final phases = testExercise.getPhases();

      // Act - 첫 번째 사이클 완료
      for (int i = 0; i < phases.length; i++) {
        breathingTimer.onTick(0);
      }
      
      // 두 번째 사이클 시작
      breathingTimer.onTick(0);

      // Assert - 첫 번째 단계로 돌아감
      expect(breathingTimer.currentPhaseIndex, 0);
      expect(breathingTimer.currentCycle, 2);
      expect(breathingTimer.state, BreathingTimerState.running);
    });
  });
} 