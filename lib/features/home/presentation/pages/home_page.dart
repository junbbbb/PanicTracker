import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/presentation/pages/add_entry_page.dart';
import '../../presentation/widgets/summary_card.dart';
import '../../presentation/widgets/recent_entries_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);
    
    final List<Map<String, String>> _breathingExercises = [
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
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5A5F),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5A5F).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Emergency panic button
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 60),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5A5F),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5A5F).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddEntryPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Center(
                                child: Text(
                                  '지금 공황',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Add entry button - White style
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 60),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddEntryPage(),
                                ),
                              );
                            },
                                                         borderRadius: BorderRadius.circular(20),
                                                          child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                               child: Center(
                                 child: Text(
                                   '새로운 기록 추가',
                                   style: TextStyle(
                                     fontSize: 17,
                                     fontWeight: FontWeight.normal,
                                     color: Colors.grey.shade800,
                                   ),
                                   overflow: TextOverflow.ellipsis,
                                 ),
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
                      
                      // Breathing cards - Horizontal scroll
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: _breathingExercises.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final exercise = _breathingExercises[index];
                                                         return SizedBox(
                               width: 200,
                               child: _buildBreathingCard(
                                 title: exercise['title'] ?? '',
                                 description: exercise['description'] ?? '',
                                 duration: exercise['duration'] ?? '',
                                 onTap: () => _startBreathingExercise(exercise['type'] ?? ''),
                               ),
                             );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5A5F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.tips_and_updates_outlined,
                                color: Color(0xFFFF5A5F),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '호흡법 팁',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '불안할 때 천천히 깊게 호흡하면 마음이 차분해집니다',
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.air_rounded,
                  color: const Color(0xFFFF5A5F),
                  size: 20,
                ),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _startBreathingExercise(String type) {
    // TODO: 호흡법 운동 화면 구현
    print('$type 호흡법을 시작합니다');
  }
}