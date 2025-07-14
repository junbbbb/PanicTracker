import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/presentation/pages/add_entry_page.dart';
import '../../../breathing/presentation/pages/breathing_exercise_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

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
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                      const SizedBox(height: 32),
                      
                      // Emergency panic button - Soft rounded design
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A5F),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF5A5F).withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '지금 공황',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Add entry button - Soft rounded design
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '새로운 기록 추가',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              
              // Stats Overview
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
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
                      const Text(
                        '이번 주 요약',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              label: '총 기록',
                              value: '${entries.length}개',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              label: '평균 강도',
                              value: _getAverageIntensity(entries),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              label: '이번 주',
                              value: '${_getThisWeekEntries(entries)}개',
                            ),
                          ),
                        ],
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFDDDDDD),
            width: 1,
          ),
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
}