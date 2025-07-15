import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BreathingAnimationWidget extends StatefulWidget {
  final String exerciseType;
  final bool showControls;
  final bool autoStart;
  final int initialTimeMinutes;
  final VoidCallback? onComplete;

  const BreathingAnimationWidget({
    super.key,
    this.exerciseType = '심호흡',
    this.showControls = true,
    this.autoStart = false,
    this.initialTimeMinutes = 3,
    this.onComplete,
  });

  @override
  State<BreathingAnimationWidget> createState() => _BreathingAnimationWidgetState();
}

class _BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _circleController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _circleAnimation;
  
  Timer? _exerciseTimer;
  Timer? _phaseTimer;
  Timer? _phaseCountdownTimer;
  
  bool _isRunning = false;
  bool _isPaused = false;
  String _currentPhase = '';
  int _currentCycle = 0;
  int _remainingTime = 0;
  int _phaseTime = 0;
  int _phaseRemainingTime = 0;
  
  // 호흡법 패턴
  final Map<String, List<Map<String, dynamic>>> _breathingPatterns = {
    '4-7-8': [
      {'phase': '들이쉬기', 'duration': 4, 'instruction': '코로 천천히 들이쉬세요'},
      {'phase': '멈추기', 'duration': 7, 'instruction': '숨을 멈춰주세요'},
      {'phase': '내쉬기', 'duration': 8, 'instruction': '입으로 천천히 내쉬세요'},
    ],
    '박스': [
      {'phase': '들이쉬기', 'duration': 4, 'instruction': '코로 천천히 들이쉬세요'},
      {'phase': '멈추기', 'duration': 4, 'instruction': '숨을 멈춰주세요'},
      {'phase': '내쉬기', 'duration': 4, 'instruction': '입으로 천천히 내쉬세요'},
      {'phase': '멈추기', 'duration': 4, 'instruction': '잠시 멈춰주세요'},
    ],
    '심호흡': [
      {'phase': '들이쉬기', 'duration': 4, 'instruction': '깊게 들이쉬세요'},
      {'phase': '내쉬기', 'duration': 6, 'instruction': '천천히 내쉬세요'},
    ],
    '4-4-6': [
      {'phase': '들이쉬기', 'duration': 4, 'instruction': '코로 천천히 들이쉬세요'},
      {'phase': '멈추기', 'duration': 4, 'instruction': '숨을 멈춰주세요'},
      {'phase': '내쉬기', 'duration': 6, 'instruction': '입으로 천천히 내쉬세요'},
    ],
    '삼각': [
      {'phase': '들이쉬기', 'duration': 3, 'instruction': '코로 천천히 들이쉬세요'},
      {'phase': '멈추기', 'duration': 3, 'instruction': '숨을 멈춰주세요'},
      {'phase': '내쉬기', 'duration': 3, 'instruction': '입으로 천천히 내쉬세요'},
    ],
    '7-11': [
      {'phase': '들이쉬기', 'duration': 7, 'instruction': '코로 천천히 들이쉬세요'},
      {'phase': '내쉬기', 'duration': 11, 'instruction': '입으로 천천히 내쉬세요'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeExercise();
    
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startExercise();
      });
    }
  }

  void _setupAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _circleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_circleController);
  }

  void _initializeExercise() {
    final pattern = _breathingPatterns[widget.exerciseType]!;
    _currentPhase = pattern[0]['phase'];
    _remainingTime = widget.initialTimeMinutes * 60; // 분을 초로 변환
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _circleController.dispose();
    _exerciseTimer?.cancel();
    _phaseTimer?.cancel();
    _phaseCountdownTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    if (_isPaused) {
      _resumeExercise();
      return;
    }
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _currentCycle = 1;
    });
    
    _startExerciseTimer();
    _startPhaseTimer();
  }

  void _pauseExercise() {
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
    
    _phaseTimer?.cancel();
    _exerciseTimer?.cancel();
    _phaseCountdownTimer?.cancel();
    _breathingController.stop();
  }

  void _resumeExercise() {
    setState(() {
      _isPaused = false;
      _isRunning = true;
    });
    
    _startExerciseTimer();
    _startPhaseTimer();
  }

  void _stopExercise() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentCycle = 0;
      _remainingTime = widget.initialTimeMinutes * 60;
      _phaseRemainingTime = 0;
    });
    
    _phaseTimer?.cancel();
    _exerciseTimer?.cancel();
    _phaseCountdownTimer?.cancel();
    _breathingController.reset();
  }

  void _startExerciseTimer() {
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
        if (_remainingTime <= 0) {
          _stopExercise();
          widget.onComplete?.call();
        }
      });
    });
  }

  void _startPhaseTimer() {
    final pattern = _breathingPatterns[widget.exerciseType]!;
    int currentPhaseIndex = 0;
    
    void nextPhase() {
      final currentPhaseData = pattern[currentPhaseIndex];
      setState(() {
        _currentPhase = currentPhaseData['phase'];
        _phaseTime = currentPhaseData['duration'];
        _phaseRemainingTime = currentPhaseData['duration'];
      });
      
      // 애니메이션 설정
      _breathingController.duration = Duration(seconds: currentPhaseData['duration']);
      
      if (currentPhaseData['phase'] == '들이쉬기') {
        _breathingController.forward();
      } else if (currentPhaseData['phase'] == '내쉬기') {
        _breathingController.reverse();
      }
      
      // 단계별 카운트다운 타이머
      _phaseCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _phaseRemainingTime--;
          if (_phaseRemainingTime <= 0) {
            timer.cancel();
            currentPhaseIndex = (currentPhaseIndex + 1) % pattern.length;
            if (currentPhaseIndex == 0) {
              _currentCycle++;
            }
            nextPhase();
          }
        });
      });
    }
    
    nextPhase();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case '들이쉬기':
        return const Color(0xFF4CAF50);
      case '내쉬기':
        return const Color(0xFF2196F3);
      case '멈추기':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _getCurrentInstruction() {
    final pattern = _breathingPatterns[widget.exerciseType]!;
    for (var phase in pattern) {
      if (phase['phase'] == _currentPhase) {
        return phase['instruction'];
      }
    }
    return '편안히 호흡하세요';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 시간 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _formatTime(_remainingTime),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // 호흡 애니메이션 원
        SizedBox(
          height: 200,
          child: Center(
            child: AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _circleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 150 * _breathingAnimation.value,
                      height: 150 * _breathingAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _getPhaseColor().withOpacity(0.3),
                            _getPhaseColor().withOpacity(0.1),
                            _getPhaseColor().withOpacity(0.05),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getPhaseColor().withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getPhaseColor(),
                            boxShadow: [
                              BoxShadow(
                                color: _getPhaseColor().withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _currentPhase == '들이쉬기' ? Icons.keyboard_arrow_up_rounded :
                                _currentPhase == '내쉬기' ? Icons.keyboard_arrow_down_rounded :
                                Icons.pause_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              if (_isRunning && _phaseRemainingTime > 0)
                                Text(
                                  '$_phaseRemainingTime',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // 현재 단계 및 지시사항
        Text(
          _currentPhase,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: _getPhaseColor(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getCurrentInstruction(),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (_isRunning)
          Text(
            '사이클: $_currentCycle',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        
        if (widget.showControls) ...[
          const SizedBox(height: 32),
          
          // 컨트롤 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 시작/일시정지 버튼
              GestureDetector(
                onTap: _isRunning ? _pauseExercise : _startExercise,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRunning ? const Color(0xFFFB7185) : const Color(0xFF4CAF50),
                    boxShadow: [
                      BoxShadow(
                        color: (_isRunning ? const Color(0xFFFB7185) : const Color(0xFF4CAF50)).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              
              const SizedBox(width: 24),
              
              // 정지 버튼
              GestureDetector(
                onTap: _stopExercise,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF64748B),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64748B).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.stop_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}