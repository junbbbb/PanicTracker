import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/anxiety_entry_providers.dart';
import '../../domain/entities/anxiety_entry.dart';

class AddEntryPage extends ConsumerStatefulWidget {
  final AnxietyEntry? entryToEdit;
  
  const AddEntryPage({super.key, this.entryToEdit});

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
  late bool _isEditMode;
  String? _entryId;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.entryToEdit != null;
    if (widget.entryToEdit != null) {
      _entryId = widget.entryToEdit!.id;
      _loadEntryData(widget.entryToEdit!);
    }
  }

  void _loadEntryData(AnxietyEntry entry) {
    _triggerController.text = entry.trigger;
    _negativeThoughtsController.text = entry.negativeThoughts;
    _copingStrategyController.text = entry.copingStrategy;
    _durationController.text = entry.durationInMinutes.toString();
    _intensityLevel = entry.intensityLevel;
    _selectedSymptoms.clear();
    _selectedSymptoms.addAll(entry.symptoms);
  }

  @override
  void dispose() {
    _triggerController.dispose();
    _negativeThoughtsController.dispose();
    _copingStrategyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 1:
        return '매우 약함';
      case 2:
        return '약함';
      case 3:
        return '약간 약함';
      case 4:
        return '보통 이하';
      case 5:
        return '보통';
      case 6:
        return '보통 이상';
      case 7:
        return '강함';
      case 8:
        return '매우 강함';
      case 9:
        return '극도로 강함';
      case 10:
        return '최고 강도';
      default:
        return '보통';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(entryFormProvider);
    final formNotifier = ref.watch(entryFormProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: AppBar(
        title: const Text(
          '새로운 기록',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '지금 느끼는 감정을\n기록해보세요',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '솔직한 기록이 더 나은 분석으로 이어집니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF717171),
                        height: 1.4,
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
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                        ),
                        decoration: InputDecoration(
                          hintText: '예: 중요한 발표, 새로운 사람들과의 만남...',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF717171),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFDDDDDD),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFDDDDDD),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF222222),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '유발 요인을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Intensity level section
                    _buildFormSection(
                      title: '불안감의 강도는 어느 정도였나요?',
                      subtitle: '1: 매우 약함 ~ 10: 매우 강함',
                      child: Column(
                        children: [
                          Text(
                            '$_intensityLevel',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF5A5F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getIntensityLabel(_intensityLevel),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF717171),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFFF5A5F),
                              inactiveTrackColor: const Color(0xFFDDDDDD),
                              thumbColor: const Color(0xFFFF5A5F),
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                            ),
                            child: Slider(
                              value: _intensityLevel.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              onChanged: (value) {
                                setState(() {
                                  _intensityLevel = value.round();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '매우 약함',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF717171),
                                ),
                              ),
                              const Text(
                                '매우 강함',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF717171),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 40),

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

                            final success = await formNotifier.saveEntry(entryId: _entryId);
                            if (success) {
                              if (!_isEditMode) {
                                formNotifier.reset();
                                _triggerController.clear();
                                _negativeThoughtsController.clear();
                                _copingStrategyController.clear();
                                _durationController.clear();
                                _selectedSymptoms.clear();
                                _intensityLevel = 5;
                                setState(() {});
                              }
                              
                              ref.invalidate(entriesProvider);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          '기록이 성공적으로 저장되었습니다!',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: const Color(0xFF34D399),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  elevation: 8,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              
                              // Always pop back to previous screen
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.error_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '오류: ${formState.error}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  elevation: 8,
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A5F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
                                '기록 저장',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF717171),
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}