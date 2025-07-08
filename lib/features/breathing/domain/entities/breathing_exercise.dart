/// 호흡법 타입 열거형
enum BreathingType {
  fourSevenEight,
  box,
  deep,
  fourFourSix,
  triangle,
  sevenEleven,
}

/// 호흡 단계 타입 열거형
enum BreathingPhaseType {
  inhale,
  hold,
  exhale,
}

/// 호흡 단계 클래스
class BreathingPhase {
  final BreathingPhaseType type;
  final int duration;
  final String instruction;

  const BreathingPhase({
    required this.type,
    required this.duration,
    required this.instruction,
  });
}

/// 호흡법 운동 엔티티
class BreathingExercise {
  final BreathingType type;
  final String title;
  final String description;
  final int totalDurationMinutes;

  const BreathingExercise({
    required this.type,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
  });

  /// 한 사이클의 총 지속시간(초)을 반환
  int getCycleDuration() {
    switch (type) {
      case BreathingType.fourSevenEight:
        return 4 + 7 + 8; // 19초
      case BreathingType.box:
        return 4 + 4 + 4 + 4; // 16초
      case BreathingType.deep:
        return 4 + 2 + 6; // 12초
      case BreathingType.fourFourSix:
        return 4 + 4 + 6; // 14초
      case BreathingType.triangle:
        return 4 + 4 + 4; // 12초
      case BreathingType.sevenEleven:
        return 7 + 11; // 18초
    }
  }

  /// 호흡 단계들을 반환
  List<BreathingPhase> getPhases() {
    switch (type) {
      case BreathingType.fourSevenEight:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 4,
            instruction: '4초간 코로 숨을 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 7,
            instruction: '7초간 숨을 참으세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 8,
            instruction: '8초간 입으로 숨을 내쉬세요',
          ),
        ];
      case BreathingType.box:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 4,
            instruction: '4초간 숨을 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 4,
            instruction: '4초간 숨을 참으세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 4,
            instruction: '4초간 숨을 내쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 4,
            instruction: '4초간 숨을 참으세요',
          ),
        ];
      case BreathingType.deep:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 4,
            instruction: '4초간 깊게 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 2,
            instruction: '2초간 잠시 멈추세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 6,
            instruction: '6초간 천천히 내쉬세요',
          ),
        ];
      case BreathingType.fourFourSix:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 4,
            instruction: '4초간 숨을 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 4,
            instruction: '4초간 숨을 참으세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 6,
            instruction: '6초간 숨을 내쉬세요',
          ),
        ];
      case BreathingType.triangle:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 4,
            instruction: '4초간 숨을 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.hold,
            duration: 4,
            instruction: '4초간 숨을 참으세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 4,
            instruction: '4초간 숨을 내쉬세요',
          ),
        ];
      case BreathingType.sevenEleven:
        return [
          const BreathingPhase(
            type: BreathingPhaseType.inhale,
            duration: 7,
            instruction: '7초간 숨을 들이쉬세요',
          ),
          const BreathingPhase(
            type: BreathingPhaseType.exhale,
            duration: 11,
            instruction: '11초간 숨을 내쉬세요',
          ),
        ];
    }
  }
} 