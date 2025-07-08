/// 호흡법 타이머를 관리하는 리포지토리 인터페이스
abstract class BreathingTimerRepository {
  /// 타이머 시작
  void startTimer();
  
  /// 타이머 일시정지
  void pauseTimer();
  
  /// 타이머 재시작
  void resumeTimer();
  
  /// 타이머 정지
  void stopTimer();
  
  /// 타이머 tick 이벤트 스트림
  Stream<int> get timerStream;
} 