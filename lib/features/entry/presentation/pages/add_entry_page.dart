import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/anxiety_entry_providers.dart';

class AddEntryPage extends ConsumerStatefulWidget {
  const AddEntryPage({super.key});

  @override
  ConsumerState<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends ConsumerState<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _triggerController = TextEditingController();
  final _negativeThoughtsController = TextEditingController();
  final _copingStrategyController = TextEditingController();
  final _durationController = TextEditingController();
  int _intensityLevel = 5;

  final List<String> _commonSymptoms = [
    '심장 두근거림',
    '손떨림',
    '식은땀',
    '호흡 곤란',
    '메스꺼움',
    '어지러움',
    '가슴 답답함',
    '얼굴 빨개짐',
    '몸의 긴장',
    '집중력 저하',
  ];

  final List<String> _selectedSymptoms = [];

  @override
  void dispose() {
    _triggerController.dispose();
    _negativeThoughtsController.dispose();
    _copingStrategyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(entryFormProvider);
    final formNotifier = ref.watch(entryFormProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: AppBar(
        title: const Text(
          '감정 기록 추가',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘의 감정을 기록해보세요',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '솔직하게 작성하시면 더 나은 분석을 받을 수 있어요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Form sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Trigger section
                    _buildFormSection(
                      title: '무엇이 불안감을 유발했나요?',
                      child: TextFormField(
                        controller: _triggerController,
                        decoration: const InputDecoration(
                          hintText: '예: 중요한 발표, 새로운 사람들과의 만남...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '유발 요인을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Intensity level section
                    _buildFormSection(
                      title: '불안감의 강도는 어느 정도였나요?',
                      subtitle: '1: 매우 약함 ~ 10: 매우 강함',
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE6E6E6)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$_intensityLevel',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF5A5F),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Slider(
                                  value: _intensityLevel.toDouble(),
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  activeColor: const Color(0xFFFF5A5F),
                                  inactiveColor: const Color(0xFFE6E6E6),
                                  onChanged: (value) {
                                    setState(() {
                                      _intensityLevel = value.round();
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '1',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      '10',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Symptoms section
                    _buildFormSection(
                      title: '어떤 증상을 경험하셨나요?',
                      subtitle: '해당하는 증상을 모두 선택해주세요',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _commonSymptoms.map((symptom) {
                          final isSelected = _selectedSymptoms.contains(symptom);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSymptoms.remove(symptom);
                                } else {
                                  _selectedSymptoms.add(symptom);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF5A5F).withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFF5A5F)
                                      : const Color(0xFFE6E6E6),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Text(
                                symptom,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFFFF5A5F)
                                      : const Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Negative thoughts section
                    _buildFormSection(
                      title: '어떤 부정적인 생각이 들었나요?',
                      child: TextFormField(
                        controller: _negativeThoughtsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: '그때의 생각과 감정을 자세히 적어보세요...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '부정적인 생각을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Coping strategy section
                    _buildFormSection(
                      title: '어떤 대처 방법을 사용하셨나요?',
                      child: TextFormField(
                        controller: _copingStrategyController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: '예: 심호흡, 명상, 친구와 대화하기...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '대처 방법을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Duration section
                    _buildFormSection(
                      title: '얼마나 오래 지속되었나요?',
                      subtitle: '분 단위로 입력해주세요',
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '예: 30',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          suffixText: '분',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '지속 시간을 입력해주세요';
                          }
                          final duration = int.tryParse(value);
                          if (duration == null || duration < 0) {
                            return '올바른 숫자를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: formState.isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            formNotifier.updateTrigger(_triggerController.text);
                            formNotifier.updateSymptoms(_selectedSymptoms);
                            formNotifier.updateNegativeThoughts(_negativeThoughtsController.text);
                            formNotifier.updateCopingStrategy(_copingStrategyController.text);
                            formNotifier.updateDuration(int.parse(_durationController.text));
                            formNotifier.updateIntensityLevel(_intensityLevel);

                            final success = await formNotifier.saveEntry();
                            if (success) {
                              formNotifier.reset();
                              _triggerController.clear();
                              _negativeThoughtsController.clear();
                              _copingStrategyController.clear();
                              _durationController.clear();
                              _selectedSymptoms.clear();
                              _intensityLevel = 5;
                              setState(() {});
                              
                              ref.invalidate(entriesProvider);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('기록이 성공적으로 저장되었습니다!'),
                                  backgroundColor: Color(0xFF00D924),
                                ),
                              );
                              
                              // Always pop back to previous screen
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('오류: ${formState.error}'),
                                  backgroundColor: const Color(0xFFEF4444),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A5F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFFFF5A5F).withOpacity(0.4),
                        ),
                        child: formState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                '기록 저장하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}