import 'package:flutter/material.dart';
import '../../../entry/presentation/pages/add_entry_page.dart';
import '../../../../shared/widgets/breathing_animation_widget.dart';

class PanicResponsePage extends StatefulWidget {
  const PanicResponsePage({super.key});

  @override
  State<PanicResponsePage> createState() => _PanicResponsePageState();
}

class _PanicResponsePageState extends State<PanicResponsePage> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': '1단계: 호흡 운동',
      'subtitle': '깊게 호흡하며 마음을 진정시켜보세요',
      'description': '원이 커질 때 들이쉬고, 작아질 때 내쉬세요.',
      'buttonText': '다음 단계로',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.air_rounded,
    },
    {
      'title': '2단계: 그라운딩',
      'subtitle': '지금 이 순간에 집중해보세요',
      'description': '주변의 것들을 관찰하며 현실감각을 되찾아보세요.',
      'buttonText': '그라운딩 시작',
      'color': const Color(0xFF2196F3),
      'icon': Icons.psychology_rounded,
    },
    {
      'title': '3단계: 기록하기',
      'subtitle': '경험을 기록해보세요',
      'description': '방금 경험한 것을 기록하여 패턴을 파악해보세요.',
      'buttonText': '기록 작성',
      'color': const Color(0xFFFF9800),
      'icon': Icons.edit_note_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '공황 대응 가이드',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF222222)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFDDDDDD),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: List.generate(3, (index) {
                final isCompleted = index < _currentStep;
                final isCurrent = index == _currentStep;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent 
                          ? const Color(0xFFFF8F00)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Main content
          Expanded(
            child: _currentStep < 3 ? _buildStepContent() : _buildCompletionScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    final step = _steps[_currentStep];
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Step icon or breathing animation
            if (_currentStep == 0)
              const BreathingAnimationWidget(
                exerciseType: '심호흡',
                showControls: true,
                initialTimeMinutes: 3,
              )
            else if (_currentStep == 1)
              _buildGroundingContent()
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: (step['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step['icon'],
                  size: 40,
                  color: step['color'],
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Step title
            Text(
              step['title'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Step subtitle
            Text(
              step['subtitle'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Step description
            Text(
              step['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // Action buttons
            Column(
              children: [
                // Main action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleStepAction(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: step['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      step['buttonText'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Skip button
                if (_currentStep < 2)
                  TextButton(
                    onPressed: () => _nextStep(),
                    child: Text(
                      '건너뛰기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 40,
              color: Color(0xFF4CAF50),
            ),
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            '잘하셨습니다!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          Text(
            '공황 대응 과정을 완료하셨습니다.\n기분이 나아지셨기를 바랍니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 48),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8F00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '홈으로 돌아가기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroundingContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.psychology_rounded,
            size: 48,
            color: Color(0xFF2196F3),
          ),
          const SizedBox(height: 16),
          const Text(
            '5-4-3-2-1 그라운딩',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '주변을 둘러보며 다음을 찾아보세요:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildGroundingItem('👀', '볼 수 있는 것', '5가지'),
              const SizedBox(height: 8),
              _buildGroundingItem('✋', '만질 수 있는 것', '4가지'),
              const SizedBox(height: 8),
              _buildGroundingItem('👂', '들을 수 있는 것', '3가지'),
              const SizedBox(height: 8),
              _buildGroundingItem('👃', '냄새 맡을 수 있는 것', '2가지'),
              const SizedBox(height: 8),
              _buildGroundingItem('👅', '맛볼 수 있는 것', '1가지'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '이 방법은 현재 순간에 집중하는데 도움이 됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroundingItem(String emoji, String text, String count) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF444444),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _handleStepAction() {
    switch (_currentStep) {
      case 0:
        // 호흡 운동 - 다음 단계로
        _nextStep();
        break;
      case 1:
        // 그라운딩 - 다음 단계로
        _nextStep();
        break;
      case 2:
        // 기록하기
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEntryPage(),
          ),
        ).then((_) => _nextStep());
        break;
    }
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }
}