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
                          title: '주간 개선도 트렌드',
                          children: [
                            _buildWeeklyComparisonChart(entries),
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
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '주간 비교 분석',
                          children: [
                            _buildWeeklyComparisonTable(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '환경적 요인 분석',
                          children: [
                            _buildEnvironmentalAnalysis(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '위험도 예측 및 조기 경고',
                          children: [
                            _buildRiskPredictionAnalysis(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInsightCard(
                          title: '장기 회복 여정 시각화',
                          children: [
                            _buildRecoveryJourneyVisualization(entries),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildMedicalStandardsCard(entries),
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

  Widget _buildWeeklyComparisonChart(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final weeklyData = _getWeeklyData(entries, now);
    
    return Column(
      children: [
        // 주요 지표 카드들
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: '발작 빈도',
                thisWeek: weeklyData['thisWeekCount']!,
                lastWeek: weeklyData['lastWeekCount']!,
                unit: '회',
                icon: Icons.trending_down,
                reverse: true, // 낮을수록 좋음
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                label: '평균 강도',
                thisWeek: weeklyData['thisWeekIntensity']!,
                lastWeek: weeklyData['lastWeekIntensity']!,
                unit: '',
                icon: Icons.psychology,
                reverse: true, // 낮을수록 좋음
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: '평균 지속시간',
                thisWeek: weeklyData['thisWeekDuration']!,
                lastWeek: weeklyData['lastWeekDuration']!,
                unit: '분',
                icon: Icons.timer,
                reverse: true, // 짧을수록 좋음
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                label: '관리 점수',
                thisWeek: weeklyData['managementScore']!,
                lastWeek: weeklyData['lastManagementScore']!,
                unit: '/10',
                icon: Icons.psychology_rounded,
                reverse: false, // 높을수록 좋음
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // 주간 트렌드 차트
        _buildWeeklyTrendChart(entries),
        
        const SizedBox(height: 16),
        
        // 의학적 인사이트 + 개선 상태 표시
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    color: const Color(0xFFFF5A5F),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '치료 효과 분석',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // 개선 상태 시각화
              _buildImprovementIndicators(weeklyData),
              
              const SizedBox(height: 12),
              Text(
                _getMedicalInsight(weeklyData),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMetricCard({
    required String label,
    required double thisWeek,
    required double lastWeek,
    required String unit,
    required IconData icon,
    required bool reverse, // true면 감소가 좋음, false면 증가가 좋음
  }) {
    final difference = thisWeek - lastWeek;
    final percentChange = lastWeek == 0 ? 0.0 : (difference / lastWeek * 100);
    final isImprovement = reverse ? difference < 0 : difference > 0;
    final changeColor = isImprovement ? const Color(0xFF00C9A7) : const Color(0xFFFF5A5F);
    final changeIcon = isImprovement ? Icons.trending_up : Icons.trending_down;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${thisWeek.toStringAsFixed(thisWeek == thisWeek.roundToDouble() ? 0 : 1)}$unit',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          if (lastWeek > 0) ...[
            Row(
              children: [
                Icon(
                  changeIcon,
                  color: changeColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '${percentChange.abs().toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              '첫 주',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildWeeklyTrendChart(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final weeklyTrends = <String, double>{};
    
    // 최근 6주간의 주간 발작 횟수 계산
    for (int i = 5; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      final weekEntries = entries.where((entry) {
        return entry.timestamp.isAfter(weekStart.subtract(const Duration(days: 1))) &&
               entry.timestamp.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();
      
      final weekLabel = i == 0 ? '이번주' : '${i}주전';
      weeklyTrends[weekLabel] = weekEntries.length.toDouble();
    }
    
    final maxCount = weeklyTrends.values.isEmpty ? 1.0 : weeklyTrends.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6주간 발작 빈도 트렌드',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100, // 높이를 80에서 100으로 증가
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weeklyTrends.entries.map((entry) {
              final barHeight = maxCount == 0 ? 0.0 : (entry.value / maxCount) * 50; // 최대 높이를 60에서 50으로 조정
              final isThisWeek = entry.key == '이번주';
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 숫자 표시 영역
                      SizedBox(
                        height: 18, // 고정 높이로 변경
                        child: Center(
                          child: entry.value > 0 
                              ? Text(
                                  '${entry.value.toInt()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isThisWeek ? const Color(0xFFFF5A5F) : const Color(0xFF1A1A1A),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // 막대 그래프
                      Container(
                        width: double.infinity,
                        height: barHeight.clamp(3.0, 50.0), // 최소 높이를 2에서 3으로 증가
                        decoration: BoxDecoration(
                          color: isThisWeek ? const Color(0xFFFF5A5F) : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 라벨 영역
                      SizedBox(
                        height: 22, // 고정 높이로 변경
                        child: Center(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 9,
                              color: isThisWeek ? const Color(0xFFFF5A5F) : Colors.grey.shade600,
                              fontWeight: isThisWeek ? FontWeight.w600 : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Map<String, double> _getWeeklyData(List<AnxietyEntry> entries, DateTime now) {
    // 이번 주 월요일과 지난 주 월요일 계산
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    
    // 이번 주 데이터
    final thisWeekEntries = entries.where((entry) {
      return entry.timestamp.isAfter(thisMonday.subtract(const Duration(days: 1))) &&
             entry.timestamp.isBefore(thisMonday.add(const Duration(days: 7)));
    }).toList();
    
    // 지난 주 데이터
    final lastWeekEntries = entries.where((entry) {
      return entry.timestamp.isAfter(lastMonday.subtract(const Duration(days: 1))) &&
             entry.timestamp.isBefore(lastMonday.add(const Duration(days: 7)));
    }).toList();
    
    // 계산
    final thisWeekCount = thisWeekEntries.length.toDouble();
    final lastWeekCount = lastWeekEntries.length.toDouble();
    
    final thisWeekIntensity = thisWeekEntries.isEmpty ? 0.0 : 
        thisWeekEntries.fold(0, (sum, e) => sum + e.intensityLevel) / thisWeekEntries.length;
    final lastWeekIntensity = lastWeekEntries.isEmpty ? 0.0 : 
        lastWeekEntries.fold(0, (sum, e) => sum + e.intensityLevel) / lastWeekEntries.length;
    
    final thisWeekDuration = thisWeekEntries.isEmpty ? 0.0 : 
        thisWeekEntries.fold(0, (sum, e) => sum + e.durationInMinutes) / thisWeekEntries.length;
    final lastWeekDuration = lastWeekEntries.isEmpty ? 0.0 : 
        lastWeekEntries.fold(0, (sum, e) => sum + e.durationInMinutes) / lastWeekEntries.length;
    
    // 관리 점수 계산 (10 - 평균강도 + 보너스점수)
    final thisWeekScore = _calculateManagementScore(thisWeekEntries);
    final lastWeekScore = _calculateManagementScore(lastWeekEntries);
    
    return {
      'thisWeekCount': thisWeekCount,
      'lastWeekCount': lastWeekCount,
      'thisWeekIntensity': thisWeekIntensity,
      'lastWeekIntensity': lastWeekIntensity,
      'thisWeekDuration': thisWeekDuration,
      'lastWeekDuration': lastWeekDuration,
      'managementScore': thisWeekScore,
      'lastManagementScore': lastWeekScore,
    };
  }
  
  double _calculateManagementScore(List<AnxietyEntry> entries) {
    if (entries.isEmpty) return 8.0; // 발작이 없으면 좋은 점수
    
    final avgIntensity = entries.fold(0, (sum, e) => sum + e.intensityLevel) / entries.length;
    final avgDuration = entries.fold(0, (sum, e) => sum + e.durationInMinutes) / entries.length;
    final frequency = entries.length.toDouble();
    
    // 기본 점수 (10점 만점)
    double score = 10.0;
    
    // 강도에 따른 감점 (1-10 → 0-4.5점 감점)
    score -= (avgIntensity - 1) * 0.5;
    
    // 빈도에 따른 감점 (주 3회 이상부터 감점)
    if (frequency > 2) {
      score -= (frequency - 2) * 0.5;
    }
    
    // 지속시간에 따른 감점 (30분 이상부터 감점)
    if (avgDuration > 30) {
      score -= (avgDuration - 30) / 30;
    }
    
    return score.clamp(0.0, 10.0);
  }
  
  String _getMedicalInsight(Map<String, double> data) {
    final frequencyChange = data['thisWeekCount']! - data['lastWeekCount']!;
    final intensityChange = data['thisWeekIntensity']! - data['lastWeekIntensity']!;
    final managementScore = data['managementScore']!;
    
    if (data['thisWeekCount']! == 0) {
      return '✅ 이번 주 발작이 없었습니다. 현재 관리 전략을 유지하세요. 의학적으로 매우 긍정적인 신호입니다.';
    }
    
    if (frequencyChange <= -1 && intensityChange <= -1) {
      return '📈 발작 빈도와 강도가 모두 개선되었습니다. 치료 반응이 우수합니다. 현재 방법을 지속하세요.';
    } else if (frequencyChange <= 0) {
      return '🎯 발작 빈도가 안정적입니다. 추가 개선을 위해 스트레스 관리와 규칙적인 호흡법 연습을 권장합니다.';
    } else if (managementScore >= 7.0) {
      return '💪 전반적인 관리 점수가 우수합니다. 증상이 잘 조절되고 있는 상태로 판단됩니다.';
    } else {
      return '⚠️ 이번 주 증상이 증가했습니다. 스트레스 요인을 점검하고, 필요시 전문의 상담을 고려해보세요.';
    }
  }
  
  Widget _buildImprovementIndicators(Map<String, double> data) {
    final frequencyChange = data['thisWeekCount']! - data['lastWeekCount']!;
    final intensityChange = data['thisWeekIntensity']! - data['lastWeekIntensity']!;
    
    return Row(
      children: [
        Expanded(
          child: _buildIndicatorItem(
            label: '빈도',
            change: frequencyChange,
            isFrequency: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildIndicatorItem(
            label: '강도',
            change: intensityChange,
            isFrequency: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverallIndicator(frequencyChange, intensityChange),
        ),
      ],
    );
  }
  
  Widget _buildIndicatorItem({
    required String label,
    required double change,
    required bool isFrequency,
  }) {
    IconData icon;
    Color color;
    String status;
    
    if (change < -0.5) {
      icon = Icons.trending_up;
      color = const Color(0xFF00C9A7);
      status = '개선중';
    } else if (change > 0.5) {
      icon = Icons.trending_down;
      color = const Color(0xFFFF5A5F);
      status = '주의';
    } else {
      icon = Icons.trending_flat;
      color = Colors.grey.shade600;
      status = '안정';
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverallIndicator(double frequencyChange, double intensityChange) {
    IconData icon;
    Color color;
    String status;
    
    if (frequencyChange <= 0 && intensityChange <= 0) {
      icon = Icons.check_circle;
      color = const Color(0xFF00C9A7);
      status = '우수';
    } else if (frequencyChange > 1 || intensityChange > 1) {
      icon = Icons.warning;
      color = const Color(0xFFFF5A5F);
      status = '주의';
    } else {
      icon = Icons.remove_circle_outline;
      color = Colors.grey.shade600;
      status = '보통';
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(height: 4),
          const Text(
            '종합',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF717171),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMedicalStandardsCard(List<AnxietyEntry> entries) {
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
        border: Border.all(
          color: const Color(0xFFE8F4FD),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066CC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Color(0xFF0066CC),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '의학적 기준 및 지표 설명',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // FDA 승인 기준
          _buildStandardSection(
            title: '🏛️ FDA 승인 1차 지표',
            items: [
              '발작 빈도: 주간/월간 공황 발작 횟수 (가장 중요한 지표)',
              '발작 강도: 1-10 척도의 평균 심각도',
              '치료 반응률: 50% 이상 증상 개선 시 치료 성공으로 판단',
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 임상 기준
          _buildStandardSection(
            title: '📊 임상 평가 기준',
            items: [
              '주간 모니터링: 의학계 표준 추적 기간',
              '6주 이상 트렌드: 장기 패턴 인식에 필요한 최소 기간',
              '관리 점수: 빈도+강도+지속시간을 종합한 10점 척도',
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 개선 판단 기준
          _buildStandardSection(
            title: '✅ 개선 판단 기준',
            items: [
              '우수한 치료 반응: 빈도 50%↓ + 강도 2점↓',
              '안정적 상태: 빈도 변화 ±1회 이내 유지',
              '전문의 상담 권장: 빈도 증가 + 강도 악화가 2주 지속',
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 주의사항
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFC107),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFF57C00),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '의학적 면책조항',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF57C00),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '이 앱은 추적 및 모니터링 목적으로만 사용됩니다. 의학적 진단이나 치료를 대체하지 않으며, 응급상황에서는 즉시 의료진의 도움을 받으세요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFF57C00),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStandardSection({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF0066CC),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
  
  Widget _buildWeeklyComparisonTable(List<AnxietyEntry> entries) {
    final weeklyStats = _getWeeklyStats(entries, 6); // 최근 6주
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 6주간 주별 통계',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        
        // 테이블 헤더
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  '기간',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  '빈도',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  '평균강도',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  '관리점수',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  '상태',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 테이블 바디
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: weeklyStats.asMap().entries.map((entry) {
              final index = entry.key;
              final weekData = entry.value;
              final isLast = index == weeklyStats.length - 1;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: isLast ? null : Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // 기간
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weekData['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: weekData['isCurrent'] ? const Color(0xFFFF5A5F) : const Color(0xFF1A1A1A),
                            ),
                          ),
                          if (weekData['dateRange'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              weekData['dateRange'],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // 빈도
                    Expanded(
                      child: _buildTableCell(
                        value: '${weekData['frequency']}회',
                        trend: weekData['frequencyTrend'],
                        isGoodTrend: weekData['frequencyTrend'] <= 0,
                      ),
                    ),
                    
                    // 평균 강도
                    Expanded(
                      child: _buildTableCell(
                        value: weekData['intensity'] == 0 ? '-' : weekData['intensity'].toStringAsFixed(1),
                        trend: weekData['intensityTrend'],
                        isGoodTrend: weekData['intensityTrend'] <= 0,
                      ),
                    ),
                    
                    // 관리 점수
                    Expanded(
                      child: _buildTableCell(
                        value: weekData['managementScore'].toStringAsFixed(1),
                        trend: weekData['scoreTrend'],
                        isGoodTrend: weekData['scoreTrend'] >= 0,
                      ),
                    ),
                    
                    // 상태
                    Expanded(
                      child: _buildStatusIndicator(weekData['status']),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 범례
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '상태 범례',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _buildLegendItem('우수', const Color(0xFF00C9A7), '개선'),
                  _buildLegendItem('안정', Colors.grey.shade600, '유지'),
                  _buildLegendItem('주의', const Color(0xFFFF5A5F), '악화'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTableCell({
    required String value,
    required double trend,
    required bool isGoodTrend,
  }) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (trend != 0) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                trend > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: (trend > 0 && isGoodTrend) || (trend < 0 && !isGoodTrend)
                    ? const Color(0xFF00C9A7)
                    : const Color(0xFFFF5A5F),
              ),
              Text(
                trend.abs().toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 9,
                  color: (trend > 0 && isGoodTrend) || (trend < 0 && !isGoodTrend)
                      ? const Color(0xFF00C9A7)
                      : const Color(0xFFFF5A5F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
  
  Widget _buildStatusIndicator(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case '우수':
        color = const Color(0xFF00C9A7);
        icon = Icons.check_circle;
        break;
      case '주의':
        color = const Color(0xFFFF5A5F);
        icon = Icons.warning;
        break;
      default:
        color = Colors.grey.shade600;
        icon = Icons.remove_circle_outline;
        break;
    }
    
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(height: 2),
        Text(
          status,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '$label ($description)',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  List<Map<String, dynamic>> _getWeeklyStats(List<AnxietyEntry> entries, int weekCount) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weeklyStats = [];
    
    for (int i = weekCount - 1; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      // 해당 주의 엔트리들
      final weekEntries = entries.where((entry) {
        return entry.timestamp.isAfter(weekStart.subtract(const Duration(days: 1))) &&
               entry.timestamp.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();
      
      // 이전 주 데이터 (트렌드 계산용)
      final prevWeekStart = weekStart.subtract(const Duration(days: 7));
      final prevWeekEnd = prevWeekStart.add(const Duration(days: 6));
      final prevWeekEntries = entries.where((entry) {
        return entry.timestamp.isAfter(prevWeekStart.subtract(const Duration(days: 1))) &&
               entry.timestamp.isBefore(prevWeekEnd.add(const Duration(days: 1)));
      }).toList();
      
      // 통계 계산
      final frequency = weekEntries.length;
      final intensity = weekEntries.isEmpty ? 0.0 : 
          weekEntries.fold(0, (sum, e) => sum + e.intensityLevel) / weekEntries.length;
      final managementScore = _calculateManagementScore(weekEntries);
      
      // 이전 주 통계
      final prevFrequency = prevWeekEntries.length;
      final prevIntensity = prevWeekEntries.isEmpty ? 0.0 : 
          prevWeekEntries.fold(0, (sum, e) => sum + e.intensityLevel) / prevWeekEntries.length;
      final prevManagementScore = _calculateManagementScore(prevWeekEntries);
      
      // 트렌드 계산
      final frequencyTrend = frequency - prevFrequency.toDouble();
      final intensityTrend = intensity - prevIntensity;
      final scoreTrend = managementScore - prevManagementScore;
      
      // 상태 판단
      String status;
      if (frequency == 0) {
        status = '우수';
      } else if (frequencyTrend <= 0 && intensityTrend <= 0) {
        status = '우수';
      } else if (frequencyTrend > 1 || intensityTrend > 1) {
        status = '주의';
      } else {
        status = '안정';
      }
      
      // 라벨 생성
      String label;
      String? dateRange;
      if (i == 0) {
        label = '이번주';
        dateRange = '${weekStart.month}/${weekStart.day} - ${weekEnd.month}/${weekEnd.day}';
      } else {
        label = '${i}주전';
        dateRange = '${weekStart.month}/${weekStart.day} - ${weekEnd.month}/${weekEnd.day}';
      }
      
      weeklyStats.add({
        'label': label,
        'dateRange': dateRange,
        'frequency': frequency,
        'intensity': intensity,
        'managementScore': managementScore,
        'frequencyTrend': frequencyTrend,
        'intensityTrend': intensityTrend,
        'scoreTrend': scoreTrend,
        'status': status,
        'isCurrent': i == 0,
      });
    }
    
    return weeklyStats.reversed.toList(); // 오래된 주부터 최신 주 순서로
  }
  
  Widget _buildEnvironmentalAnalysis(List<AnxietyEntry> entries) {
    if (entries.isEmpty) {
      return const Text(
        '충분한 데이터가 없습니다. 더 많은 기록을 추가해주세요.',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF717171),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 계절별 패턴 분석
        _buildSeasonalPattern(entries),
        const SizedBox(height: 20),
        
        // 요일별 패턴 분석
        _buildWeekdayPattern(entries),
        const SizedBox(height: 20),
        
        // 월별 트렌드 분석
        _buildMonthlyTrend(entries),
        const SizedBox(height: 16),
        
        // 환경적 인사이트
        _buildEnvironmentalInsights(entries),
      ],
    );
  }
  
  Widget _buildSeasonalPattern(List<AnxietyEntry> entries) {
    final seasonalData = <String, List<AnxietyEntry>>{
      '봄 (3-5월)': [],
      '여름 (6-8월)': [],
      '가을 (9-11월)': [],
      '겨울 (12-2월)': [],
    };
    
    for (final entry in entries) {
      final month = entry.timestamp.month;
      if (month >= 3 && month <= 5) {
        seasonalData['봄 (3-5월)']!.add(entry);
      } else if (month >= 6 && month <= 8) {
        seasonalData['여름 (6-8월)']!.add(entry);
      } else if (month >= 9 && month <= 11) {
        seasonalData['가을 (9-11월)']!.add(entry);
      } else {
        seasonalData['겨울 (12-2월)']!.add(entry);
      }
    }
    
    final maxCount = seasonalData.values.map((e) => e.length).reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              size: 16,
              color: Color(0xFFFF5A5F),
            ),
            const SizedBox(width: 8),
            const Text(
              '계절별 발작 패턴',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...seasonalData.entries.map((season) {
          final count = season.value.length;
          final avgIntensity = season.value.isEmpty ? 0.0 : 
              season.value.fold(0, (sum, e) => sum + e.intensityLevel) / season.value.length;
          final percentage = maxCount == 0 ? 0.0 : (count / maxCount);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      season.key,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      '$count회 ${avgIntensity > 0 ? '(평균 ${avgIntensity.toStringAsFixed(1)})' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getSeasonColor(season.key),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  Color _getSeasonColor(String season) {
    if (season.contains('봄')) return const Color(0xFF4CAF50);
    if (season.contains('여름')) return const Color(0xFFFF9800);
    if (season.contains('가을')) return const Color(0xFF795548);
    return const Color(0xFF2196F3);
  }
  
  Widget _buildWeekdayPattern(List<AnxietyEntry> entries) {
    final weekdayData = <String, int>{
      '월': 0, '화': 0, '수': 0, '목': 0, '금': 0, '토': 0, '일': 0,
    };
    
    final weekdayNames = ['일', '월', '화', '수', '목', '금', '토'];
    
    for (final entry in entries) {
      final weekday = weekdayNames[entry.timestamp.weekday % 7];
      weekdayData[weekday] = weekdayData[weekday]! + 1;
    }
    
    final maxCount = weekdayData.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color(0xFFFF5A5F),
            ),
            const SizedBox(width: 8),
            const Text(
              '요일별 발작 패턴',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weekdayData.entries.map((day) {
              final barHeight = maxCount == 0 ? 0.0 : (day.value / maxCount) * 40;
              final isWeekend = day.key == '토' || day.key == '일';
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (day.value > 0)
                        Text(
                          '${day.value}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isWeekend ? const Color(0xFFFF5A5F) : const Color(0xFF1A1A1A),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: barHeight.clamp(2.0, 40.0),
                        decoration: BoxDecoration(
                          color: isWeekend ? const Color(0xFFFF5A5F) : const Color(0xFF00C9A7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day.key,
                        style: TextStyle(
                          fontSize: 11,
                          color: isWeekend ? const Color(0xFFFF5A5F) : Colors.grey.shade600,
                          fontWeight: isWeekend ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMonthlyTrend(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final monthlyData = <String, int>{};
    
    // 최근 6개월 데이터
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = '${month.month}월';
      monthlyData[monthKey] = 0;
    }
    
    for (final entry in entries) {
      final entryMonth = '${entry.timestamp.month}월';
      if (monthlyData.containsKey(entryMonth)) {
        monthlyData[entryMonth] = monthlyData[entryMonth]! + 1;
      }
    }
    
    final maxCount = monthlyData.values.isEmpty ? 1 : monthlyData.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.show_chart,
              size: 16,
              color: Color(0xFFFF5A5F),
            ),
            const SizedBox(width: 8),
            const Text(
              '최근 6개월 트렌드',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: monthlyData.entries.map((month) {
              final barHeight = maxCount == 0 ? 0.0 : (month.value / maxCount) * 30;
              final isCurrentMonth = month.key == '${now.month}월';
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (month.value > 0)
                        Text(
                          '${month.value}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isCurrentMonth ? const Color(0xFFFF5A5F) : const Color(0xFF1A1A1A),
                          ),
                        ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        height: barHeight.clamp(2.0, 30.0),
                        decoration: BoxDecoration(
                          color: isCurrentMonth ? const Color(0xFFFF5A5F) : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        month.key,
                        style: TextStyle(
                          fontSize: 9,
                          color: isCurrentMonth ? const Color(0xFFFF5A5F) : Colors.grey.shade600,
                          fontWeight: isCurrentMonth ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEnvironmentalInsights(List<AnxietyEntry> entries) {
    final insights = _generateEnvironmentalInsights(entries);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0EA5E9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF0EA5E9),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                '환경 패턴 인사이트',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0EA5E9),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    insight,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
  
  List<String> _generateEnvironmentalInsights(List<AnxietyEntry> entries) {
    if (entries.isEmpty) return ['충분한 데이터가 없습니다.'];
    
    final insights = <String>[];
    final now = DateTime.now();
    
    // 계절별 분석
    final seasonalCounts = <String, int>{'봄': 0, '여름': 0, '가을': 0, '겨울': 0};
    for (final entry in entries) {
      final month = entry.timestamp.month;
      if (month >= 3 && month <= 5) seasonalCounts['봄'] = seasonalCounts['봄']! + 1;
      else if (month >= 6 && month <= 8) seasonalCounts['여름'] = seasonalCounts['여름']! + 1;
      else if (month >= 9 && month <= 11) seasonalCounts['가을'] = seasonalCounts['가을']! + 1;
      else seasonalCounts['겨울'] = seasonalCounts['겨울']! + 1;
    }
    
    final maxSeasonCount = seasonalCounts.values.reduce((a, b) => a > b ? a : b);
    final maxSeason = seasonalCounts.entries.firstWhere((e) => e.value == maxSeasonCount).key;
    
    if (maxSeasonCount > entries.length * 0.4) {
      insights.add('$maxSeason철에 공황 발작이 가장 빈번합니다. 계절적 요인(일조량, 온도 변화 등)이 영향을 줄 수 있습니다.');
    }
    
    // 요일별 분석
    final weekdayNames = ['일', '월', '화', '수', '목', '금', '토'];
    final weekdayCounts = <String, int>{for (var day in weekdayNames) day: 0};
    
    for (final entry in entries) {
      final weekday = weekdayNames[entry.timestamp.weekday % 7];
      weekdayCounts[weekday] = weekdayCounts[weekday]! + 1;
    }
    
    final weekendCount = (weekdayCounts['토'] ?? 0) + (weekdayCounts['일'] ?? 0);
    final weekdayCount = entries.length - weekendCount;
    
    if (weekendCount > weekdayCount && entries.length > 10) {
      insights.add('주말에 공황 발작이 더 빈번합니다. 일상 패턴의 변화나 사회적 활동이 영향을 줄 수 있습니다.');
    } else if (weekdayCount > weekendCount * 1.5 && entries.length > 10) {
      insights.add('평일에 공황 발작이 더 빈번합니다. 업무 스트레스나 일상의 압박이 주요 요인일 수 있습니다.');
    }
    
    // 시간대별 패턴
    final morningCount = entries.where((e) => e.timestamp.hour >= 6 && e.timestamp.hour < 12).length;
    final afternoonCount = entries.where((e) => e.timestamp.hour >= 12 && e.timestamp.hour < 18).length;
    final eveningCount = entries.where((e) => e.timestamp.hour >= 18 || e.timestamp.hour < 6).length;
    
    if (morningCount > afternoonCount && morningCount > eveningCount) {
      insights.add('오전 시간대에 발작이 가장 많습니다. 기상 후 코르티솔 상승이나 하루 시작에 대한 불안이 원인일 수 있습니다.');
    }
    
    // 월별 트렌드
    final recentMonths = entries.where((e) => 
      now.difference(e.timestamp).inDays <= 90
    ).toList();
    
    if (recentMonths.length > entries.length * 0.6 && entries.length > 10) {
      insights.add('최근 3개월간 발작이 집중되고 있습니다. 스트레스 증가나 환경 변화를 점검해보세요.');
    }
    
    if (insights.isEmpty) {
      insights.add('현재까지의 패턴이 비교적 고르게 분포되어 있습니다. 지속적인 기록으로 더 명확한 패턴을 파악할 수 있습니다.');
    }
    
    return insights;
  }
  
  Widget _buildRiskPredictionAnalysis(List<AnxietyEntry> entries) {
    if (entries.length < 5) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 32,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                const Text(
                  '위험도 예측을 위한 데이터 수집 중',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '정확한 예측을 위해 최소 5개 이상의 기록이 필요합니다.\n현재 ${entries.length}개 기록됨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    final riskAnalysis = _calculateRiskFactors(entries);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 현재 위험도 수준
        _buildCurrentRiskLevel(riskAnalysis),
        const SizedBox(height: 20),
        
        // 위험 요인 분석
        _buildRiskFactors(riskAnalysis),
        const SizedBox(height: 20),
        
        // 조기 경고 시스템
        _buildEarlyWarningSystem(riskAnalysis),
        const SizedBox(height: 16),
        
        // 예방 조치 권장사항
        _buildPreventiveRecommendations(riskAnalysis),
      ],
    );
  }
  
  Map<String, dynamic> _calculateRiskFactors(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final last7Days = entries.where((e) => 
        now.difference(e.timestamp).inDays <= 7
    ).toList();
    final last14Days = entries.where((e) => 
        now.difference(e.timestamp).inDays <= 14
    ).toList();
    final last30Days = entries.where((e) => 
        now.difference(e.timestamp).inDays <= 30
    ).toList();
    
    // 최근 패턴 분석
    final recentFrequency = last7Days.length;
    final avgRecentIntensity = last7Days.isEmpty ? 0.0 : 
        last7Days.fold(0, (sum, e) => sum + e.intensityLevel) / last7Days.length;
    
    // 트렌드 분석
    final firstWeek = entries.where((e) => 
        now.difference(e.timestamp).inDays > 7 && 
        now.difference(e.timestamp).inDays <= 14
    ).toList();
    
    final frequencyTrend = recentFrequency - firstWeek.length;
    final intensityTrend = last7Days.isEmpty || firstWeek.isEmpty ? 0.0 :
        avgRecentIntensity - (firstWeek.fold(0, (sum, e) => sum + e.intensityLevel) / firstWeek.length);
    
    // 위험 점수 계산 (0-10)
    double riskScore = 0;
    
    // 빈도 위험도
    if (recentFrequency >= 4) riskScore += 3;
    else if (recentFrequency >= 2) riskScore += 2;
    else if (recentFrequency >= 1) riskScore += 1;
    
    // 강도 위험도
    if (avgRecentIntensity >= 8) riskScore += 3;
    else if (avgRecentIntensity >= 6) riskScore += 2;
    else if (avgRecentIntensity >= 4) riskScore += 1;
    
    // 트렌드 위험도
    if (frequencyTrend > 0) riskScore += 2;
    if (intensityTrend > 1) riskScore += 2;
    
    // 패턴 일관성 (높을수록 예측 가능성 증가)
    final dailyPattern = _analyzeDailyPattern(entries);
    final patternConsistency = dailyPattern['consistency'] as double;
    
    String riskLevel;
    Color riskColor;
    String riskDescription;
    
    if (riskScore >= 7) {
      riskLevel = '높음';
      riskColor = const Color(0xFFFF5A5F);
      riskDescription = '향후 1-2주 내 발작 위험이 높습니다';
    } else if (riskScore >= 4) {
      riskLevel = '보통';
      riskColor = const Color(0xFFFFB400);
      riskDescription = '주의 깊은 관찰이 필요합니다';
    } else {
      riskLevel = '낮음';
      riskColor = const Color(0xFF00C9A7);
      riskDescription = '현재 상태가 안정적입니다';
    }
    
    return {
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'riskColor': riskColor,
      'riskDescription': riskDescription,
      'recentFrequency': recentFrequency,
      'avgRecentIntensity': avgRecentIntensity,
      'frequencyTrend': frequencyTrend,
      'intensityTrend': intensityTrend,
      'patternConsistency': patternConsistency,
      'last7Days': last7Days,
      'last14Days': last14Days,
      'last30Days': last30Days,
    };
  }
  
  Map<String, dynamic> _analyzeDailyPattern(List<AnxietyEntry> entries) {
    final hourCounts = <int, int>{};
    
    for (final entry in entries) {
      final hour = entry.timestamp.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    
    // 패턴 일관성 계산 (특정 시간대에 집중되는 정도)
    final maxCount = hourCounts.values.isEmpty ? 0 : hourCounts.values.reduce((a, b) => a > b ? a : b);
    final consistency = entries.isEmpty ? 0.0 : maxCount / entries.length;
    
    return {
      'consistency': consistency,
      'peakHour': hourCounts.entries.isEmpty ? -1 : 
          hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key,
    };
  }
  
  Widget _buildCurrentRiskLevel(Map<String, dynamic> analysis) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (analysis['riskColor'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: analysis['riskColor'] as Color,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: analysis['riskColor'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getRiskIcon(analysis['riskLevel'] as String),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 위험도: ${analysis['riskLevel']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: analysis['riskColor'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      analysis['riskDescription'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 위험도 점수 표시
          Row(
            children: [
              const Text(
                '위험 점수: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${(analysis['riskScore'] as double).toStringAsFixed(1)}/10',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: analysis['riskColor'] as Color,
                ),
              ),
              const Spacer(),
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ((analysis['riskScore'] as double) / 10).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: analysis['riskColor'] as Color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case '높음':
        return Icons.warning;
      case '보통':
        return Icons.info;
      default:
        return Icons.check_circle;
    }
  }
  
  Widget _buildRiskFactors(Map<String, dynamic> analysis) {
    final factors = <Map<String, dynamic>>[];
    
    // 최근 빈도
    if (analysis['recentFrequency'] >= 3) {
      factors.add({
        'title': '높은 발작 빈도',
        'description': '최근 7일간 ${analysis['recentFrequency']}회 발작',
        'severity': 'high',
      });
    }
    
    // 평균 강도
    if (analysis['avgRecentIntensity'] >= 7) {
      factors.add({
        'title': '높은 발작 강도',
        'description': '최근 평균 강도 ${(analysis['avgRecentIntensity'] as double).toStringAsFixed(1)}',
        'severity': 'high',
      });
    }
    
    // 증가 트렌드
    if (analysis['frequencyTrend'] > 0) {
      factors.add({
        'title': '발작 빈도 증가',
        'description': '지난주 대비 ${analysis['frequencyTrend']}회 증가',
        'severity': 'medium',
      });
    }
    
    if (analysis['intensityTrend'] > 1) {
      factors.add({
        'title': '발작 강도 증가',
        'description': '지난주 대비 강도 ${(analysis['intensityTrend'] as double).toStringAsFixed(1)} 증가',
        'severity': 'medium',
      });
    }
    
    // 패턴 일관성
    if (analysis['patternConsistency'] > 0.3) {
      factors.add({
        'title': '일정한 패턴 감지',
        'description': '특정 시간대에 발작이 집중됨',
        'severity': 'low',
      });
    }
    
    if (factors.isEmpty) {
      factors.add({
        'title': '주요 위험 요인 없음',
        'description': '현재 식별된 고위험 패턴이 없습니다',
        'severity': 'none',
      });
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.search,
              size: 16,
              color: Color(0xFFFF5A5F),
            ),
            const SizedBox(width: 8),
            const Text(
              '위험 요인 분석',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...factors.map((factor) => _buildRiskFactorItem(factor)).toList(),
      ],
    );
  }
  
  Widget _buildRiskFactorItem(Map<String, dynamic> factor) {
    Color severityColor;
    IconData severityIcon;
    
    switch (factor['severity']) {
      case 'high':
        severityColor = const Color(0xFFFF5A5F);
        severityIcon = Icons.warning;
        break;
      case 'medium':
        severityColor = const Color(0xFFFFB400);
        severityIcon = Icons.info;
        break;
      case 'low':
        severityColor = const Color(0xFF00C9A7);
        severityIcon = Icons.info_outline;
        break;
      default:
        severityColor = Colors.grey.shade600;
        severityIcon = Icons.check_circle_outline;
        break;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              severityIcon,
              color: severityColor,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  factor['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEarlyWarningSystem(Map<String, dynamic> analysis) {
    final warnings = <String>[];
    final riskScore = analysis['riskScore'] as double;
    
    if (riskScore >= 7) {
      warnings.add('⚠️ 고위험 상태: 즉시 스트레스 관리와 호흡법 실천을 권장합니다');
      warnings.add('📞 필요시 전문의 상담을 고려해보세요');
    } else if (riskScore >= 4) {
      warnings.add('🔍 주의 관찰: 다음 며칠간 증상 변화를 주의깊게 관찰하세요');
      warnings.add('🧘 예방적 호흡 운동을 늘려보세요');
    } else {
      warnings.add('✅ 안정 상태: 현재 관리 방법을 유지하세요');
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFC107),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Color(0xFFF57C00),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                '조기 경고 시스템',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...warnings.map((warning) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              warning,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
  
  Widget _buildPreventiveRecommendations(Map<String, dynamic> analysis) {
    final recommendations = <String>[];
    final riskScore = analysis['riskScore'] as double;
    
    if (riskScore >= 6) {
      recommendations.add('매일 2-3회 호흡 운동 실시');
      recommendations.add('스트레스 요인 식별 및 관리');
      recommendations.add('충분한 수면 (7-8시간) 확보');
      recommendations.add('카페인 섭취 줄이기');
    } else if (riskScore >= 3) {
      recommendations.add('매일 1-2회 호흡 운동');
      recommendations.add('규칙적인 생활 패턴 유지');
      recommendations.add('적절한 운동으로 스트레스 해소');
    } else {
      recommendations.add('현재 관리법 지속');
      recommendations.add('주간 호흡 운동 유지');
      recommendations.add('긍정적 생활 패턴 지속');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.health_and_safety,
              size: 16,
              color: Color(0xFF00C9A7),
            ),
            const SizedBox(width: 8),
            const Text(
              '예방 조치 권장사항',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recommendations.map((rec) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 5, right: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF00C9A7),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  rec,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
  
  Widget _buildRecoveryJourneyVisualization(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final monthsBack = 6;
    final oldestEntry = entries.isEmpty ? now : entries.map((e) => e.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);
    final dataSpanMonths = now.difference(oldestEntry).inDays ~/ 30;
    
    if (entries.length < 10 || dataSpanMonths < 2) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 32,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                const Text(
                  '회복 여정 추적을 위한 데이터 수집 중',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '장기적인 회복 여정을 추적하려면 최소 2개월간 10개 이상의 기록이 필요합니다.\n현재 ${entries.length}개 기록, ${dataSpanMonths}개월 데이터',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 전체 회복 진행률
        _buildOverallRecoveryProgress(entries),
        const SizedBox(height: 20),
        
        // 월별 진행 상황 차트
        _buildMonthlyProgressChart(entries),
        const SizedBox(height: 20),
        
        // 회복 마일스톤
        _buildRecoveryMilestones(entries),
        const SizedBox(height: 16),
        
        // 동기부여 인사이트
        _buildMotivationalInsights(entries),
      ],
    );
  }
  
  Widget _buildOverallRecoveryProgress(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final firstMonth = entries.map((e) => e.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);
    final totalMonths = now.difference(firstMonth).inDays ~/ 30;
    
    // 첫 달과 최근 달 비교
    final firstMonthEntries = entries.where((e) => 
        e.timestamp.difference(firstMonth).inDays <= 30
    ).toList();
    final lastMonthEntries = entries.where((e) => 
        now.difference(e.timestamp).inDays <= 30
    ).toList();
    
    final firstMonthAvgIntensity = firstMonthEntries.isEmpty ? 0.0 :
        firstMonthEntries.fold(0, (sum, e) => sum + e.intensityLevel) / firstMonthEntries.length;
    final lastMonthAvgIntensity = lastMonthEntries.isEmpty ? 0.0 :
        lastMonthEntries.fold(0, (sum, e) => sum + e.intensityLevel) / lastMonthEntries.length;
    
    final frequencyImprovement = firstMonthEntries.length - lastMonthEntries.length;
    final intensityImprovement = firstMonthAvgIntensity - lastMonthAvgIntensity;
    
    // 전체 진행률 계산 (0-100%)
    double overallProgress = 50.0; // 기본값
    
    if (frequencyImprovement > 0) overallProgress += 20;
    if (intensityImprovement > 0) overallProgress += 20;
    if (lastMonthEntries.length <= 2) overallProgress += 10;
    
    overallProgress = overallProgress.clamp(0.0, 100.0);
    
    final progressColor = overallProgress >= 70 ? const Color(0xFF00C9A7) :
                         overallProgress >= 40 ? const Color(0xFFFFB400) :
                         const Color(0xFFFF5A5F);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            progressColor.withOpacity(0.1),
            progressColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: progressColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '전체 회복 진행률',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalMonths개월간의 여정',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${overallProgress.toInt()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 진행률 바
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: overallProgress / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 개선 지표
          Row(
            children: [
              Expanded(
                child: _buildProgressMetric(
                  '빈도 변화',
                  frequencyImprovement >= 0 ? '-${frequencyImprovement}회' : '+${frequencyImprovement.abs()}회',
                  frequencyImprovement >= 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressMetric(
                  '강도 변화',
                  intensityImprovement >= 0 ? '-${intensityImprovement.toStringAsFixed(1)}' : '+${intensityImprovement.abs().toStringAsFixed(1)}',
                  intensityImprovement >= 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressMetric(String label, String value, bool isImprovement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              isImprovement ? Icons.trending_down : Icons.trending_up,
              size: 16,
              color: isImprovement ? const Color(0xFF00C9A7) : const Color(0xFFFF5A5F),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isImprovement ? const Color(0xFF00C9A7) : const Color(0xFFFF5A5F),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMonthlyProgressChart(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final monthlyData = <String, Map<String, dynamic>>{};
    
    // 최근 6개월 데이터 초기화
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      final displayKey = '${month.month}월';
      monthlyData[monthKey] = {
        'display': displayKey,
        'frequency': 0,
        'intensity': 0.0,
        'entries': <AnxietyEntry>[],
      };
    }
    
    // 데이터 집계
    for (final entry in entries) {
      final entryKey = '${entry.timestamp.year}-${entry.timestamp.month.toString().padLeft(2, '0')}';
      if (monthlyData.containsKey(entryKey)) {
        monthlyData[entryKey]!['frequency'] += 1;
        (monthlyData[entryKey]!['entries'] as List<AnxietyEntry>).add(entry);
      }
    }
    
    // 평균 강도 계산
    for (final data in monthlyData.values) {
      final entries = data['entries'] as List<AnxietyEntry>;
      if (entries.isNotEmpty) {
        data['intensity'] = entries.fold(0, (sum, e) => sum + e.intensityLevel) / entries.length;
      }
    }
    
    final maxFrequency = monthlyData.values.map((d) => d['frequency'] as int).reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.show_chart,
              size: 16,
              color: Color(0xFF00C9A7),
            ),
            const SizedBox(width: 8),
            const Text(
              '월별 진행 상황',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: monthlyData.entries.map((entry) {
              final data = entry.value;
              final frequency = data['frequency'] as int;
              final intensity = data['intensity'] as double;
              final barHeight = maxFrequency == 0 ? 0.0 : (frequency / maxFrequency) * 70;
              
              // 개선 정도에 따른 색상
              Color barColor;
              if (frequency == 0) {
                barColor = const Color(0xFF00C9A7);
              } else if (intensity <= 4) {
                barColor = const Color(0xFF00C9A7);
              } else if (intensity <= 6) {
                barColor = const Color(0xFFFFB400);
              } else {
                barColor = const Color(0xFFFF5A5F);
              }
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 빈도 표시
                      if (frequency > 0)
                        Text(
                          '$frequency',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: barColor,
                          ),
                        ),
                      const SizedBox(height: 4),
                      
                      // 막대 그래프
                      Container(
                        width: double.infinity,
                        height: barHeight.clamp(3.0, 70.0),
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // 월 라벨
                      Text(
                        data['display'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      // 강도 표시
                      if (intensity > 0)
                        Text(
                          '${intensity.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // 범례
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChartLegend('우수', const Color(0xFF00C9A7)),
            _buildChartLegend('보통', const Color(0xFFFFB400)),
            _buildChartLegend('주의', const Color(0xFFFF5A5F)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecoveryMilestones(List<AnxietyEntry> entries) {
    final milestones = _calculateMilestones(entries);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 16,
              color: Color(0xFFFFB400),
            ),
            const SizedBox(width: 8),
            const Text(
              '회복 마일스톤',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        ...milestones.map((milestone) => _buildMilestoneItem(milestone)).toList(),
      ],
    );
  }
  
  List<Map<String, dynamic>> _calculateMilestones(List<AnxietyEntry> entries) {
    final milestones = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    // 7일 연속 발작 없음
    final last7Days = entries.where((e) => now.difference(e.timestamp).inDays <= 7).toList();
    if (last7Days.isEmpty) {
      milestones.add({
        'title': '7일 연속 발작 없음',
        'description': '일주일간 안정적인 상태를 유지했습니다',
        'achieved': true,
        'icon': Icons.check_circle,
        'color': const Color(0xFF00C9A7),
      });
    }
    
    // 30일 연속 발작 없음
    final last30Days = entries.where((e) => now.difference(e.timestamp).inDays <= 30).toList();
    if (last30Days.isEmpty) {
      milestones.add({
        'title': '30일 연속 발작 없음',
        'description': '한 달간 완전한 안정 상태를 달성했습니다',
        'achieved': true,
        'icon': Icons.star,
        'color': const Color(0xFFFFB400),
      });
    }
    
    // 강도 감소 달성
    final recentEntries = entries.where((e) => now.difference(e.timestamp).inDays <= 60).toList();
    final oldEntries = entries.where((e) => 
        now.difference(e.timestamp).inDays > 60 && 
        now.difference(e.timestamp).inDays <= 120
    ).toList();
    
    if (recentEntries.isNotEmpty && oldEntries.isNotEmpty) {
      final recentAvg = recentEntries.fold(0, (sum, e) => sum + e.intensityLevel) / recentEntries.length;
      final oldAvg = oldEntries.fold(0, (sum, e) => sum + e.intensityLevel) / oldEntries.length;
      
      if (recentAvg < oldAvg - 1) {
        milestones.add({
          'title': '강도 대폭 감소',
          'description': '발작 강도가 ${(oldAvg - recentAvg).toStringAsFixed(1)}점 감소했습니다',
          'achieved': true,
          'icon': Icons.trending_down,
          'color': const Color(0xFF00C9A7),
        });
      }
    }
    
    // 빈도 감소 달성
    final recentFreq = entries.where((e) => now.difference(e.timestamp).inDays <= 30).length;
    final oldFreq = entries.where((e) => 
        now.difference(e.timestamp).inDays > 30 && 
        now.difference(e.timestamp).inDays <= 60
    ).length;
    
    if (recentFreq < oldFreq && oldFreq > 0) {
      milestones.add({
        'title': '발작 빈도 감소',
        'description': '월 발작 횟수가 ${oldFreq - recentFreq}회 감소했습니다',
        'achieved': true,
        'icon': Icons.trending_down,
        'color': const Color(0xFF00C9A7),
      });
    }
    
    if (milestones.isEmpty) {
      milestones.add({
        'title': '기록 시작',
        'description': '회복 여정을 시작했습니다. 꾸준한 기록이 첫 번째 성취입니다',
        'achieved': true,
        'icon': Icons.play_arrow,
        'color': const Color(0xFF00C9A7),
      });
    }
    
    return milestones;
  }
  
  Widget _buildMilestoneItem(Map<String, dynamic> milestone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (milestone['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              milestone['icon'] as IconData,
              color: milestone['color'] as Color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  milestone['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (milestone['achieved'] as bool)
            Icon(
              Icons.check_circle,
              color: milestone['color'] as Color,
              size: 20,
            ),
        ],
      ),
    );
  }
  
  Widget _buildMotivationalInsights(List<AnxietyEntry> entries) {
    final insights = _generateMotivationalInsights(entries);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0EA5E9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                color: Color(0xFF0EA5E9),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                '동기부여 인사이트',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              insight,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
  
  List<String> _generateMotivationalInsights(List<AnxietyEntry> entries) {
    final insights = <String>[];
    final now = DateTime.now();
    
    // 전체 기간 분석
    if (entries.isNotEmpty) {
      final totalDays = now.difference(entries.first.timestamp).inDays;
      insights.add('💪 ${totalDays}일간 꾸준히 기록하며 자신의 변화를 추적하고 있습니다.');
    }
    
    // 최근 개선 상황
    final recent30 = entries.where((e) => now.difference(e.timestamp).inDays <= 30).toList();
    final previous30 = entries.where((e) => 
        now.difference(e.timestamp).inDays > 30 && 
        now.difference(e.timestamp).inDays <= 60
    ).toList();
    
    if (recent30.length < previous30.length) {
      insights.add('📈 지난달 대비 발작 빈도가 감소했습니다. 현재 방법이 효과적입니다.');
    }
    
    // 안정 기간
    final daysSinceLastAttack = entries.isEmpty ? 0 : now.difference(entries.last.timestamp).inDays;
    if (daysSinceLastAttack >= 7) {
      insights.add('🌟 마지막 발작 후 ${daysSinceLastAttack}일이 지났습니다. 안정적인 상태를 잘 유지하고 있습니다.');
    }
    
    // 격려 메시지
    if (entries.length >= 20) {
      insights.add('🎯 충분한 데이터를 수집했습니다. 이제 패턴을 파악하고 더 효과적인 관리가 가능합니다.');
    }
    
    if (insights.isEmpty) {
      insights.add('🌱 회복은 하루아침에 이루어지지 않습니다. 꾸준한 기록과 관리가 변화를 만들어냅니다.');
    }
    
    return insights;
  }
}