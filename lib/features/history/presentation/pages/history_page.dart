import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String _selectedFilter = '전체';
  final List<String> _filterOptions = ['전체', '이번 주', '이번 달', '높은 강도'];

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }

            final filteredEntries = _filterEntries(entries);

            return CustomScrollView(
              slivers: [
                // Header section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '기록',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '총 ${entries.length}개',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Filter chips - Airbnb style
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filterOptions.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final filter = _filterOptions[index];
                              final isSelected = _selectedFilter == filter;
                              
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Entries list
                if (filteredEntries.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildNoResultsState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final entry = filteredEntries[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildEntryCard(entry),
                          );
                        },
                        childCount: filteredEntries.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1A1A1A),
              strokeWidth: 2,
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
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '아직 기록이 없습니다',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 감정 기록을 추가해보세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '조건에 맞는 기록이 없습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  List<AnxietyEntry> _filterEntries(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    
    switch (_selectedFilter) {
      case '이번 주':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return entries.where((entry) => 
          entry.timestamp.isAfter(weekStart)).toList();
      case '이번 달':
        final monthStart = DateTime(now.year, now.month, 1);
        return entries.where((entry) => 
          entry.timestamp.isAfter(monthStart)).toList();
      case '높은 강도':
        return entries.where((entry) => 
          entry.intensityLevel >= 7).toList();
      default:
        return entries;
    }
  }

  Widget _buildEntryCard(AnxietyEntry entry) {
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intensity circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${entry.intensityLevel}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.trigger,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(entry.timestamp),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              Text(
                '${entry.durationInMinutes}분',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Content sections
          if (entry.symptoms.isNotEmpty) ...[
            _buildSection(
              title: '증상',
              content: entry.symptoms.join(', '),
            ),
            const SizedBox(height: 16),
          ],
          
          _buildSection(
            title: '생각',
            content: entry.negativeThoughts,
          ),
          
          const SizedBox(height: 16),
          
          _buildSection(
            title: '대처법',
            content: entry.copingStrategy,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A1A),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}