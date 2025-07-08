import 'dart:async';
import '../entities/breathing_exercise.dart';
import '../repositories/breathing_timer_repository.dart';

/// 호흡법 타이머 상태 열거형
enum BreathingTimerState {
  idle,
  running,
  paused,
  completed,
}

/// 호흡법 타이머 유즈케이스
class BreathingTimer {
  final BreathingTimerRepository _repository;
  
  BreathingExercise? _exercise;
  BreathingTimerState _state = BreathingTimerState.idle;
  int _currentPhaseIndex = 0;
  int _remainingSeconds = 0;
  int _currentCycle = 1;
  StreamSubscription<int>? _timerSubscription;
  
  BreathingTimer(this._repository);
  
  // Getters
  BreathingTimerState get state => _state;
  BreathingExercise? get exercise => _exercise;
  int get currentPhaseIndex => _currentPhaseIndex;
  int get remainingSeconds => _remainingSeconds;
  int get currentCycle => _currentCycle;
  
  BreathingPhase? get currentPhase {
    if (_exercise == null) return null;
    final phases = _exercise!.getPhases();
    if (_currentPhaseIndex >= phases.length) return null;
    return phases[_currentPhaseIndex];
  }
  
  /// 현재 단계의 진행률 (0.0 ~ 1.0)
  double get progress {
    if (_exercise == null || currentPhase == null) return 0.0;
    final totalDuration = currentPhase!.duration;
    final elapsed = totalDuration - _remainingSeconds;
    return elapsed / totalDuration;
  }
  
  /// 전체 사이클의 진행률 (0.0 ~ 1.0)
  double get totalProgress {
    if (_exercise == null) return 0.0;
    
    final phases = _exercise!.getPhases();
    final totalCycleDuration = _exercise!.getCycleDuration();
    
    // 완료된 단계들의 시간 계산
    int completedTime = 0;
    for (int i = 0; i < _currentPhaseIndex; i++) {
      completedTime += phases[i].duration;
    }
    
    // 현재 단계의 진행된 시간 추가
    if (currentPhase != null) {
      completedTime += (currentPhase!.duration - _remainingSeconds);
    }
    
    return completedTime / totalCycleDuration;
  }
  
  /// 타이머 시작
  void start(BreathingExercise exercise) {
    _exercise = exercise;
    _state = BreathingTimerState.running;
    _currentPhaseIndex = 0;
    _currentCycle = 1;
    
    final phases = exercise.getPhases();
    if (phases.isNotEmpty) {
      _remainingSeconds = phases[0].duration;
    }
    
    _repository.startTimer();
    _listenToTimer();
  }
  
  /// 타이머 일시정지
  void pause() {
    if (_state == BreathingTimerState.running) {
      _state = BreathingTimerState.paused;
      _repository.pauseTimer();
    }
  }
  
  /// 타이머 재시작
  void resume() {
    if (_state == BreathingTimerState.paused) {
      _state = BreathingTimerState.running;
      _repository.resumeTimer();
    }
  }
  
  /// 타이머 정지
  void stop() {
    _state = BreathingTimerState.idle;
    _currentPhaseIndex = 0;
    _remainingSeconds = 0;
    _currentCycle = 1;
    _exercise = null;
    
    _repository.stopTimer();
    _timerSubscription?.cancel();
  }
  
  /// 타이머 tick 처리
  void onTick(int remainingSeconds) {
    if (_state != BreathingTimerState.running || _exercise == null) return;
    
    _remainingSeconds = remainingSeconds;
    
    // 현재 단계가 끝났을 때
    if (remainingSeconds <= 0) {
      _moveToNextPhase();
    }
  }
  
  /// 다음 단계로 이동
  void _moveToNextPhase() {
    if (_exercise == null) return;
    final phases = _exercise!.getPhases();
    _currentPhaseIndex++;

    // 모든 단계가 완료된 경우
    if (_currentPhaseIndex >= phases.length) {
      final totalMinutes = _exercise!.totalDurationMinutes;
      final cycleDuration = _exercise!.getCycleDuration();
      final totalCycles = (totalMinutes * 60) ~/ cycleDuration;

      if (_currentCycle >= totalCycles) {
        _state = BreathingTimerState.completed;
        _repository.stopTimer();
        _currentPhaseIndex = 0;
        return;
      }
      // 다음 사이클 시작
      _currentPhaseIndex = 0;
      _currentCycle++;
    }

    // completed 상태가 아니고, 다음 단계가 있으면 시간 갱신
    if (_state != BreathingTimerState.completed && _currentPhaseIndex < phases.length) {
      _remainingSeconds = phases[_currentPhaseIndex].duration;
    }
  }
  
  /// 타이머 스트림 구독
  void _listenToTimer() {
    _timerSubscription?.cancel();
    _timerSubscription = _repository.timerStream.listen((tick) {
      onTick(tick);
    });
  }
  
  /// 리소스 해제
  void dispose() {
    _timerSubscription?.cancel();
  }
} 