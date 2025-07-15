import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/presentation/pages/add_entry_page.dart';
import '../../../breathing/presentation/pages/breathing_exercise_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../panic_response/presentation/pages/panic_response_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> _breathingExercises = [
    {
      'title': '4-7-8 호흡법',
      'description': '4초 들이쉬고, 7초 멈추고, 8초 내쉬기',
      'duration': '5분',
      'type': '4-7-8',
      'benefits': '깊은 이완, 수면 개선, 불안 완화',
      'bestFor': '잠들기 전, 스트레스 해소',
      'difficulty': '중급',
    },
    {
      'title': '박스 호흡법',
      'description': '4초씩 들이쉬고, 멈추고, 내쉬고, 멈추기',
      'duration': '3분',
      'type': '박스',
      'benefits': '집중력 향상, 정신 집중, 균형감',
      'bestFor': '업무 전, 명상, 집중력 필요할 때',
      'difficulty': '초급',
    },
    {
      'title': '심호흡',
      'description': '천천히 깊게 들이쉬고 내쉬기',
      'duration': '2분',
      'type': '심호흡',
      'benefits': '즉각적 진정, 산소 공급, 긴장 완화',
      'bestFor': '초보자, 응급상황, 빠른 진정',
      'difficulty': '초급',
    },
    {
      'title': '4-4-6 호흡법',
      'description': '4초 들이쉬고, 4초 멈추고, 6초 내쉬기',
      'duration': '4분',
      'type': '4-4-6',
      'benefits': '심박수 안정, 혈압 조절, 차분함',
      'bestFor': '공황 발작 시, 심장 두근거림',
      'difficulty': '중급',
    },
    {
      'title': '삼각 호흡법',
      'description': '3초씩 들이쉬고, 멈추고, 내쉬기',
      'duration': '3분',
      'type': '삼각',
      'benefits': '리듬감, 규칙적 호흡, 기초 훈련',
      'bestFor': '호흡법 입문, 규칙적 연습',
      'difficulty': '초급',
    },
    {
      'title': '7-11 호흡법',
      'description': '7초 들이쉬고 11초 내쉬기',
      'duration': '6분',
      'type': '7-11',
      'benefits': '깊은 이완, 부교감신경 활성화',
      'bestFor': '심한 스트레스, 깊은 휴식',
      'difficulty': '고급',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: SafeArea(
        child: entriesAsync.when(
          data: (entries) => CustomScrollView(
            slivers: [
              // Modern Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top greeting with time-based message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreetingMessage(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '오늘 하루는 어떠셨나요?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800), // 따스한 주황색
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFFF6F00),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'J',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Simple panic button
                      /*
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEntryPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A5F),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF5A5F).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '지금 공황',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      */
                      
                      const SizedBox(height: 16),
                      
                      // Simple add entry button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEntryPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8F00),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE65100),
                              width: 0.5,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Background illustration - diary theme
                              const Positioned(
                                right: 16,
                                top: 2,
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Icon(
                                    Icons.menu_book,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 45,
                                top: 8,
                                child: Opacity(
                                  opacity: 0.15,
                                  child: Icon(
                                    Icons.edit,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 75,
                                top: 20,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Icon(
                                    Icons.favorite,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 90,
                                top: 45,
                                child: Opacity(
                                  opacity: 0.08,
                                  child: Icon(
                                    Icons.auto_stories,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Content
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '감정 기록 하기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 지금 공황 버튼
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PanicResponsePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 0.5,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '지금 공황',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF222222),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              
              // Stats Overview
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '이번 주 요약',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatItemWithTrend(
                                label: '발작빈도',
                                value: '${_getThisWeekEntries(entries)}개',
                                trend: _getFrequencyTrend(entries),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildStatItemWithTrend(
                                label: '평균 강도',
                                value: _getThisWeekAverageIntensityString(entries),
                                trend: _getIntensityTrend(entries),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildStatItemWithTrend(
                                label: '평균 지속시간',
                                value: '${_getThisWeekAverageDuration(entries)}분',
                                trend: _getDurationTrend(entries),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              
              // Breathing Exercise section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '호흡 운동',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Breathing cards - Limited to 4 cards
                      Column(
                        children: [
                          ...List.generate(
                            4, // 4개까지만 표시
                            (index) {
                              final exercise = _breathingExercises[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildBreathingCard(
                                  title: exercise['title'] ?? '',
                                  description: exercise['description'] ?? '',
                                  duration: exercise['duration'] ?? '',
                                  benefits: exercise['benefits'] ?? '',
                                  bestFor: exercise['bestFor'] ?? '',
                                  difficulty: exercise['difficulty'] ?? '',
                                  onTap: () => _startBreathingExercise(exercise['type'] ?? '', context),
                                ),
                              );
                            },
                          ),
                          // 더보기 버튼
                          if (_breathingExercises.length > 4)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () => _showAllBreathingExercises(context),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '더 많은 호흡법 보기 (+${_breathingExercises.length - 4})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF717171),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.expand_more,
                                        color: Color(0xFF717171),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Commented out - Recent entries section
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 24),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text(
              //           '최근 기록',
              //           style: TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.w600,
              //             color: Color(0xFF1A1A1A),
              //           ),
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             // Navigate to history page (tab index 1)
              //             DefaultTabController.of(context)?.animateTo(1);
              //           },
              //           child: Text(
              //             '전체 보기',
              //             style: TextStyle(
              //               color: Colors.grey.shade600,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              
              // const SliverToBoxAdapter(child: SizedBox(height: 16)),
              
              // Recent entries list
              // SliverPadding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //   sliver: SliverList(
              //     delegate: SliverChildBuilderDelegate(
              //       (context, index) {
              //         if (index >= entries.length) return null;
              //         final entry = entries[index];
              //         return Container(
              //           margin: const EdgeInsets.only(bottom: 16),
              //           padding: const EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(20),
              //             border: Border.all(
              //               color: Colors.grey.shade300,
              //               width: 1,
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Expanded(
              //                     child: Text(
              //                       entry.trigger,
              //                       style: const TextStyle(
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w600,
              //                         color: Color(0xFF1A1A1A),
              //                       ),
              //                       overflow: TextOverflow.ellipsis,
              //                       maxLines: 1,
              //                     ),
              //                   ),
              //                   Container(
              //                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //                     decoration: BoxDecoration(
              //                       color: _getIntensityColor(entry.intensityLevel).withOpacity(0.15),
              //                       borderRadius: BorderRadius.circular(12),
              //                     ),
              //                     child: Text(
              //                       '강도 ${entry.intensityLevel}',
              //                       style: TextStyle(
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.w500,
              //                         color: _getIntensityColor(entry.intensityLevel),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               const SizedBox(height: 8),
              //               Text(
              //                 entry.negativeThoughts,
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   color: Colors.grey.shade600,
              //                   height: 1.4,
              //                 ),
              //                 maxLines: 2,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //               const SizedBox(height: 12),
              //               Row(
              //                 children: [
              //                   Icon(
              //                     Icons.access_time,
              //                     size: 14,
              //                     color: Colors.grey.shade500,
              //                   ),
              //                   const SizedBox(width: 4),
              //                   Text(
              //                     _formatTimestamp(entry.timestamp),
              //                     style: TextStyle(
              //                       fontSize: 12,
              //                       color: Colors.grey.shade500,
              //                     ),
              //                   ),
              //                   const Spacer(),
              //                   Text(
              //                     '${entry.durationInMinutes}분',
              //                     style: TextStyle(
              //                       fontSize: 12,
              //                       color: Colors.grey.shade500,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //       childCount: entries.length > 5 ? 5 : entries.length,
              //     ),
              //   ),
              // ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6366F1),
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
  
  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '좋은 아침이에요';
    if (hour < 18) return '좋은 오후에요';
    return '좋은 저녁이에요';
  }
  
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionCharacter(IconData iconType, Color color) {
    return Container(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: SlimePainter(iconType, color),
      ),
    );
  }

  Widget _buildTrendSection(List entries) {
    final thisWeekEntries = _getThisWeekEntries(entries);
    final lastWeekEntries = _getLastWeekEntries(entries);
    final thisWeekAverage = _getThisWeekAverageIntensity(entries);
    final lastWeekAverage = _getLastWeekAverageIntensity(entries);
    
    bool isImproving = false;
    String trendText = '';
    IconData trendIcon = Icons.trending_flat;
    Color trendColor = Colors.grey;
    
    if (lastWeekEntries > 0) {
      // 빈도 개선 확인 (적을수록 좋음)
      final frequencyImprovement = thisWeekEntries < lastWeekEntries;
      // 강도 개선 확인 (낮을수록 좋음)
      final intensityImprovement = thisWeekAverage < lastWeekAverage;
      
      if (frequencyImprovement && intensityImprovement) {
        isImproving = true;
        trendText = '많이 좋아졌어요!';
        trendIcon = Icons.emoji_emotions;
        trendColor = const Color(0xFF4CAF50);
      } else if (frequencyImprovement || intensityImprovement) {
        isImproving = true;
        trendText = '조금 좋아졌어요';
        trendIcon = Icons.sentiment_satisfied_alt;
        trendColor = const Color(0xFF8BC34A);
      } else if (thisWeekEntries > lastWeekEntries || thisWeekAverage > lastWeekAverage) {
        trendText = '힘든 시간이네요';
        trendIcon = Icons.sentiment_very_dissatisfied;
        trendColor = const Color(0xFFFF7043);
      } else {
        trendText = '비슷한 상태예요';
        trendIcon = Icons.sentiment_neutral;
        trendColor = Colors.grey;
      }
    } else {
      trendText = '첫 주간 기록이에요';
      trendIcon = Icons.star;
      trendColor = const Color(0xFFFF9800);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildEmotionCharacter(trendIcon, trendColor),
        const SizedBox(height: 16),
        Text(
          '지난 주 대비',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          trendText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: trendColor,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  String _getAverageIntensity(List entries) {
    if (entries.isEmpty) return '0';
    final total = entries.fold(0, (int sum, entry) => sum + (entry.intensityLevel as int));
    return (total / entries.length).toStringAsFixed(1);
  }
  
  int _getThisWeekEntries(List entries) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return entries.where((entry) => entry.timestamp.isAfter(weekStart)).length;
  }
  
  int _getLastWeekEntries(List entries) {
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    return entries.where((entry) => 
      entry.timestamp.isAfter(lastWeekStart) && 
      entry.timestamp.isBefore(thisWeekStart)
    ).length;
  }
  
  double _getThisWeekAverageIntensity(List entries) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final thisWeekEntries = entries.where((entry) => entry.timestamp.isAfter(weekStart)).toList();
    if (thisWeekEntries.isEmpty) return 0;
    final total = thisWeekEntries.fold(0, (int sum, entry) => sum + (entry.intensityLevel as int));
    return total / thisWeekEntries.length;
  }
  
  double _getLastWeekAverageIntensity(List entries) {
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEntries = entries.where((entry) => 
      entry.timestamp.isAfter(lastWeekStart) && 
      entry.timestamp.isBefore(thisWeekStart)
    ).toList();
    if (lastWeekEntries.isEmpty) return 0;
    final total = lastWeekEntries.fold(0, (int sum, entry) => sum + (entry.intensityLevel as int));
    return total / lastWeekEntries.length;
  }
  
  Color _getIntensityColor(int intensity) {
    if (intensity <= 3) return const Color(0xFF00C9A7); // Warm teal
    if (intensity <= 6) return const Color(0xFFFFB400); // Warm amber
    return const Color(0xFFFF5A5F); // Warm coral
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  Widget _buildBreathingCard({
    required String title,
    required String description,
    required String duration,
    required String benefits,
    required String bestFor,
    required String difficulty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더: 제목과 난이도
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    difficulty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF717171),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 설명
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF717171),
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 장점과 적합한 상황
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefits,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF484848),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bestFor,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF717171),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 하단: 시간과 시작 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717171),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '초급':
        return const Color(0xFF10B981); // 초록색
      case '중급':
        return const Color(0xFFF59E0B); // 주황색
      case '고급':
        return const Color(0xFFEF4444); // 빨간색
      default:
        return const Color(0xFF6B7280); // 회색
    }
  }

  void _showAllBreathingExercises(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 핸들바
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '모든 호흡법',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF717171),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // 호흡법 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _breathingExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _breathingExercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildBreathingCard(
                      title: exercise['title'] ?? '',
                      description: exercise['description'] ?? '',
                      duration: exercise['duration'] ?? '',
                      benefits: exercise['benefits'] ?? '',
                      bestFor: exercise['bestFor'] ?? '',
                      difficulty: exercise['difficulty'] ?? '',
                      onTap: () {
                        Navigator.pop(context); // 바텀 시트 닫기
                        _startBreathingExercise(exercise['type'] ?? '', context);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _startBreathingExercise(String type, BuildContext context) {
    final breathingExercises = [
      {
        'title': '4-7-8 호흡법',
        'description': '4초 들이쉬고, 7초 멈추고, 8초 내쉬기',
        'duration': '5분',
        'type': '4-7-8',
      },
      {
        'title': '박스 호흡법',
        'description': '4초씩 들이쉬고, 멈추고, 내쉬고, 멈추기',
        'duration': '3분',
        'type': '박스',
      },
      {
        'title': '심호흡',
        'description': '천천히 깊게 들이쉬고 내쉬기',
        'duration': '2분',
        'type': '심호흡',
      },
      {
        'title': '4-4-6 호흡법',
        'description': '4초 들이쉬고, 4초 멈추고, 6초 내쉬기',
        'duration': '4분',
        'type': '4-4-6',
      },
      {
        'title': '삼각 호흡법',
        'description': '3초씩 들이쉬고, 멈추고, 내쉬기',
        'duration': '3분',
        'type': '삼각',
      },
      {
        'title': '7-11 호흡법',
        'description': '7초 들이쉬고 11초 내쉬기',
        'duration': '6분',
        'type': '7-11',
      },
    ];
    
    final exercise = breathingExercises.firstWhere(
      (ex) => ex['type'] == type,
      orElse: () => breathingExercises[0],
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExercisePage(
          exerciseType: type,
          title: exercise['title'] ?? '',
          description: exercise['description'] ?? '',
        ),
      ),
    );
  }

  Widget _buildStatItemWithTrend({
    required String label,
    required String value,
    required String trend,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9800), // 주황색
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  String _getThisWeekAverageIntensityString(List entries) {
    final thisWeekList = entries.where((entry) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return entry.timestamp.isAfter(weekStart) && entry.timestamp.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
    
    if (thisWeekList.isEmpty) return '0.0';
    
    final sum = thisWeekList.fold(0.0, (sum, entry) => sum + entry.intensityLevel);
    return (sum / thisWeekList.length).toStringAsFixed(1);
  }

  int _getThisWeekAverageDuration(List entries) {
    final thisWeekList = entries.where((entry) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return entry.timestamp.isAfter(weekStart) && entry.timestamp.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
    
    if (thisWeekList.isEmpty) return 0;
    
    final sum = thisWeekList.fold<int>(0, (sum, entry) => sum + (entry.durationInMinutes as int));
    return (sum / thisWeekList.length).round();
  }

  String _getFrequencyTrend(List entries) {
    final thisWeekCount = _getThisWeekEntries(entries);
    final lastWeekCount = _getLastWeekEntries(entries);
    
    if (lastWeekCount == 0) {
      return thisWeekCount > 0 ? '↑' : '→';
    }
    
    if (thisWeekCount > lastWeekCount) {
      return '↑';
    } else if (thisWeekCount < lastWeekCount) {
      return '↓';
    } else {
      return '→';
    }
  }

  String _getIntensityTrend(List entries) {
    final thisWeekAvg = double.tryParse(_getThisWeekAverageIntensityString(entries)) ?? 0.0;
    final lastWeekAvg = _getLastWeekAverageIntensity(entries);
    
    if (lastWeekAvg == 0) {
      return thisWeekAvg > 0 ? '↑' : '→';
    }
    
    if (thisWeekAvg > lastWeekAvg) {
      return '↑';
    } else if (thisWeekAvg < lastWeekAvg) {
      return '↓';
    } else {
      return '→';
    }
  }

  String _getDurationTrend(List entries) {
    final thisWeekAvg = _getThisWeekAverageDuration(entries);
    final lastWeekAvg = _getLastWeekAverageDuration(entries);
    
    if (lastWeekAvg == 0) {
      return thisWeekAvg > 0 ? '↑' : '→';
    }
    
    if (thisWeekAvg > lastWeekAvg) {
      return '↑';
    } else if (thisWeekAvg < lastWeekAvg) {
      return '↓';
    } else {
      return '→';
    }
  }

  int _getLastWeekAverageDuration(List entries) {
    final now = DateTime.now();
    final lastWeekStart = now.subtract(Duration(days: now.weekday - 1 + 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
    
    final lastWeekList = entries.where((entry) {
      return entry.timestamp.isAfter(lastWeekStart) && entry.timestamp.isBefore(lastWeekEnd.add(const Duration(days: 1)));
    }).toList();
    
    if (lastWeekList.isEmpty) return 0;
    
    final sum = lastWeekList.fold<int>(0, (sum, entry) => sum + (entry.durationInMinutes as int));
    return (sum / lastWeekList.length).round();
  }
}

class SlimePainter extends CustomPainter {
  final IconData iconType;
  final Color color;

  SlimePainter(this.iconType, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // 슬라임 몸체 그리기
    _drawSlimeBody(canvas, center, radius);
    
    // 표정 그리기
    if (iconType == Icons.emoji_emotions) {
      _drawHappyFace(canvas, center, radius);
    } else if (iconType == Icons.sentiment_satisfied_alt) {
      _drawContentFace(canvas, center, radius);
    } else if (iconType == Icons.sentiment_very_dissatisfied) {
      _drawSadFace(canvas, center, radius);
    } else if (iconType == Icons.sentiment_neutral) {
      _drawNeutralFace(canvas, center, radius);
    } else {
      _drawStarFace(canvas, center, radius);
    }
  }

  void _drawSlimeBody(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // 메인 슬라임 몸체 (둥근 타원형)
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.1),
      width: radius * 2,
      height: radius * 1.8,
    );
    canvas.drawOval(bodyRect, paint);

    // 슬라임 하이라이트
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
        width: radius * 0.8,
        height: radius * 0.6,
      ),
      highlightPaint,
    );
  }

  void _drawHappyFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // 눈 (작은 점들)
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.15),
      radius * 0.08,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.15),
      radius * 0.08,
      eyePaint,
    );

    // 큰 웃는 입
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.2),
      width: radius * 0.8,
      height: radius * 0.4,
    );
    canvas.drawArc(mouthRect, 0, pi, false, mouthPaint);
  }

  void _drawContentFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // 눈 (작은 점들)
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.1),
      radius * 0.06,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.1),
      radius * 0.06,
      eyePaint,
    );

    // 작은 미소
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.25),
      width: radius * 0.5,
      height: radius * 0.2,
    );
    canvas.drawArc(mouthRect, 0, pi, false, mouthPaint);
  }

  void _drawSadFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    // X 모양 눈
    canvas.drawLine(
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.2),
      Offset(center.dx - radius * 0.2, center.dy),
      eyePaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
      Offset(center.dx - radius * 0.4, center.dy),
      eyePaint,
    );

    canvas.drawLine(
      Offset(center.dx + radius * 0.2, center.dy - radius * 0.2),
      Offset(center.dx + radius * 0.4, center.dy),
      eyePaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.2),
      Offset(center.dx + radius * 0.2, center.dy),
      eyePaint,
    );

    // 슬픈 입 (아래로 휜 곡선)
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.5),
      width: radius * 0.6,
      height: radius * 0.3,
    );
    canvas.drawArc(mouthRect, pi, pi, false, mouthPaint);
  }

  void _drawNeutralFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // 눈 (작은 점들)
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.1),
      radius * 0.06,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.1),
      radius * 0.06,
      eyePaint,
    );

    // 일자 입
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.25),
      Offset(center.dx + radius * 0.2, center.dy + radius * 0.25),
      mouthPaint,
    );
  }

  void _drawStarFace(Canvas canvas, Offset center, double radius) {
    final starPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // 별 모양 눈
    _drawStar(canvas, Offset(center.dx - radius * 0.3, center.dy - radius * 0.1), radius * 0.15, starPaint);
    _drawStar(canvas, Offset(center.dx + radius * 0.3, center.dy - radius * 0.1), radius * 0.15, starPaint);

    // 웃는 입
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.25),
      width: radius * 0.6,
      height: radius * 0.3,
    );
    canvas.drawArc(mouthRect, 0, pi, false, mouthPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * pi) / 5 - pi / 2;
      final outerRadius = size;
      final innerRadius = size * 0.4;
      
      // 외부 점
      final outerX = center.dx + outerRadius * cos(angle);
      final outerY = center.dy + outerRadius * sin(angle);
      
      // 내부 점
      final innerAngle = angle + pi / 5;
      final innerX = center.dx + innerRadius * cos(innerAngle);
      final innerY = center.dy + innerRadius * sin(innerAngle);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}