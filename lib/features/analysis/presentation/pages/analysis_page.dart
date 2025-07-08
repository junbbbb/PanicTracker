import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '감정 분석',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '지난 ${entries.length}개의 기록을 바탕으로 한 분석',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Key insights cards
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildInsightCard(
                          title: '주요 통계',
                          children: [
                            _buildInsightRow(
                              icon: Icons.timeline,
                              label: '평균 강도',
                              value: _getAverageIntensity(entries),
                              color: const Color(0xFFFF5A5F),
                            ),
                            _buildInsightRow(
                              icon: Icons.schedule,
                              label: '평균 지속시간',
                              value: '${_getAverageDuration(entries)}분',
                              color: const Color(0xFF00C9A7),
                            ),
                            _buildInsightRow(
                              icon: Icons.trending_down,
                              label: '이번 주 개선도',
                              value: _getImprovementTrend(entries),
                              color: const Color(0xFFFFB400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '감정 강도 분포',
                          children: [
                            _buildIntensityDistribution(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '주요 트리거',
                          children: [
                            ..._buildTopTriggers(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '시간대별 패턴',
                          children: [
                            _buildTimePattern(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '대처 전략 효과',
                          children: [
                            ..._buildCopingStrategies(entries),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF5A5F),
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  '데이터를 불러올 수 없습니다',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A5F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.insights_outlined,
              size: 48,
              color: Color(0xFFFF5A5F),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '분석할 데이터가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '감정 기록을 추가하면\n분석 결과를 확인할 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('첫 기록 추가하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: const Color(0xFFFF5A5F).withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  String _getAverageIntensity(List<AnxietyEntry> entries) {
    if (entries.isEmpty) return '0';
    final total = entries.fold(0, (int sum, entry) => sum + entry.intensityLevel);
    return (total / entries.length).toStringAsFixed(1);
  }

  int _getAverageDuration(List<AnxietyEntry> entries) {
    if (entries.isEmpty) return 0;
    final total = entries.fold(0, (int sum, entry) => sum + entry.durationInMinutes);
    return (total / entries.length).round();
  }

  String _getImprovementTrend(List<AnxietyEntry> entries) {
    if (entries.length < 2) return '-';
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final thisWeek = entries.where((e) => e.timestamp.isAfter(weekAgo)).toList();
    final lastWeek = entries.where((e) => 
      e.timestamp.isBefore(weekAgo) && 
      e.timestamp.isAfter(weekAgo.subtract(const Duration(days: 7)))
    ).toList();
    
    if (thisWeek.isEmpty || lastWeek.isEmpty) return '-';
    
    final thisWeekAvg = thisWeek.fold(0, (int sum, e) => sum + e.intensityLevel) / thisWeek.length;
    final lastWeekAvg = lastWeek.fold(0, (int sum, e) => sum + e.intensityLevel) / lastWeek.length;
    
    final improvement = ((lastWeekAvg - thisWeekAvg) / lastWeekAvg * 100);
    return improvement > 0 ? '+${improvement.toStringAsFixed(0)}%' : '${improvement.toStringAsFixed(0)}%';
  }

  Widget _buildIntensityDistribution(List<AnxietyEntry> entries) {
    final distribution = <String, int>{
      '낮음 (1-3)': 0,
      '보통 (4-6)': 0,
      '높음 (7-10)': 0,
    };

    for (final entry in entries) {
      if (entry.intensityLevel <= 3) {
        distribution['낮음 (1-3)'] = distribution['낮음 (1-3)']! + 1;
      } else if (entry.intensityLevel <= 6) {
        distribution['보통 (4-6)'] = distribution['보통 (4-6)']! + 1;
      } else {
        distribution['높음 (7-10)'] = distribution['높음 (7-10)']! + 1;
      }
    }

    final colors = [
      const Color(0xFF00C9A7),
      const Color(0xFFFFB400),
      const Color(0xFFFF5A5F),
    ];

    return Column(
      children: distribution.entries.toList().asMap().entries.map((mapEntry) {
        final index = mapEntry.key;
        final entry = mapEntry.value;
        final percentage = entries.isEmpty ? 0.0 : (entry.value / entries.length * 100);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Text(
                '${entry.value}개 (${percentage.toStringAsFixed(0)}%)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildTopTriggers(List<AnxietyEntry> entries) {
    final triggerCounts = <String, int>{};
    for (final entry in entries) {
      triggerCounts[entry.trigger] = (triggerCounts[entry.trigger] ?? 0) + 1;
    }

    final sortedTriggers = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTriggers.take(3).map((trigger) {
      final percentage = entries.isEmpty ? 0.0 : (trigger.value / entries.length * 100);
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A5F),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                trigger.key,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Text(
              '${trigger.value}회 (${percentage.toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTimePattern(List<AnxietyEntry> entries) {
    final timePatterns = <String, int>{
      '새벽 (00-06)': 0,
      '오전 (06-12)': 0,
      '오후 (12-18)': 0,
      '저녁 (18-24)': 0,
    };

    for (final entry in entries) {
      final hour = entry.timestamp.hour;
      if (hour < 6) {
        timePatterns['새벽 (00-06)'] = timePatterns['새벽 (00-06)']! + 1;
      } else if (hour < 12) {
        timePatterns['오전 (06-12)'] = timePatterns['오전 (06-12)']! + 1;
      } else if (hour < 18) {
        timePatterns['오후 (12-18)'] = timePatterns['오후 (12-18)']! + 1;
      } else {
        timePatterns['저녁 (18-24)'] = timePatterns['저녁 (18-24)']! + 1;
      }
    }

    final maxCount = timePatterns.values.isEmpty ? 1 : timePatterns.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      children: timePatterns.entries.map((pattern) {
        final percentage = maxCount == 0 ? 0.0 : (pattern.value / maxCount);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pattern.key,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${pattern.value}회',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5A5F),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildCopingStrategies(List<AnxietyEntry> entries) {
    final strategies = <String, List<int>>{};
    
    for (final entry in entries) {
      if (!strategies.containsKey(entry.copingStrategy)) {
        strategies[entry.copingStrategy] = [];
      }
      strategies[entry.copingStrategy]!.add(entry.intensityLevel);
    }

    final strategyEffectiveness = strategies.entries.map((strategy) {
      final avgIntensity = strategy.value.fold(0, (int sum, intensity) => sum + intensity) / strategy.value.length;
      return MapEntry(strategy.key, avgIntensity);
    }).toList()..sort((a, b) => a.value.compareTo(b.value));

    return strategyEffectiveness.take(3).map((strategy) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF00C9A7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Color(0xFF00C9A7),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strategy.key,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    '평균 강도: ${strategy.value.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}