import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';
import '../../../entry/presentation/pages/add_entry_page.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String _selectedFilter = '전체';
  final List<String> _filterOptions = ['전체', '이번 주', '이번 달', '높은 강도', '날짜 선택'];
  bool _isCalendarView = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDateRangeSelected = false;
  DateTime? _selectedCalendarDate;
  DateTime _currentCalendarMonth = DateTime.now();

  Color _getIntensityColor(int intensity) {
    if (intensity >= 8) return const Color(0xFFE53E3E); // 빨간색 (매우 높음)
    if (intensity >= 6) return const Color(0xFFFD9300); // 주황색 (높음)
    if (intensity >= 4) return const Color(0xFFECC94B); // 노란색 (중간)
    return const Color(0xFF38A169); // 초록색 (낮음)
  }

  Widget _buildCalendarView(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_currentCalendarMonth.year, _currentCalendarMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentCalendarMonth.year, _currentCalendarMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    
    // 월의 첫 번째 날이 무슨 요일인지 확인 (월요일=1, 일요일=7)
    final firstWeekday = firstDayOfMonth.weekday;
    
    // 달력에서 보여줄 총 셀 수 계산
    final totalCells = ((daysInMonth + firstWeekday - 1) / 7).ceil() * 7;
    
    // 각 날짜별 기록 그룹화
    final Map<int, List<AnxietyEntry>> entriesByDay = {};
    for (final entry in entries) {
      final day = entry.timestamp.day;
      if (entry.timestamp.month == _currentCalendarMonth.month && 
          entry.timestamp.year == _currentCalendarMonth.year) {
        entriesByDay[day] = entriesByDay[day] ?? [];
        entriesByDay[day]!.add(entry);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 년도/월 표시 및 변경 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 이전 월 버튼
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCalendarMonth = DateTime(
                          _currentCalendarMonth.year,
                          _currentCalendarMonth.month - 1,
                        );
                        // 월이 변경되면 선택된 날짜 초기화
                        _selectedCalendarDate = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  
                  // 년도/월 텍스트 (년도 탭 가능)
                  GestureDetector(
                    onTap: () => _showYearPicker(),
                    child: Text(
                      DateFormat('yyyy년 MM월').format(_currentCalendarMonth),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ),
                  
                  // 다음 월 버튼
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCalendarMonth = DateTime(
                          _currentCalendarMonth.year,
                          _currentCalendarMonth.month + 1,
                        );
                        // 월이 변경되면 선택된 날짜 초기화
                        _selectedCalendarDate = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 요일 헤더
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: ['월', '화', '수', '목', '금', '토', '일'].map((day) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF717171),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // 달력 그리드
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final dayNumber = index - firstWeekday + 2;
                final isValidDay = dayNumber > 0 && dayNumber <= daysInMonth;
                final dayEntries = isValidDay ? entriesByDay[dayNumber] ?? [] : <AnxietyEntry>[];
                final isToday = isValidDay && 
                    dayNumber == now.day && 
                    _currentCalendarMonth.month == now.month && 
                    _currentCalendarMonth.year == now.year;
                final selectedDate = DateTime(_currentCalendarMonth.year, _currentCalendarMonth.month, dayNumber);
                final isSelectedDate = _selectedCalendarDate != null && 
                    isValidDay && 
                    _selectedCalendarDate!.year == selectedDate.year &&
                    _selectedCalendarDate!.month == selectedDate.month &&
                    _selectedCalendarDate!.day == selectedDate.day;
                
                return GestureDetector(
                  onTap: isValidDay ? () {
                    setState(() {
                      _selectedCalendarDate = selectedDate;
                    });
                  } : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelectedDate 
                          ? const Color(0xFFFF9800).withOpacity(0.2)
                          : isToday 
                              ? const Color(0xFF222222).withOpacity(0.1) 
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelectedDate 
                          ? Border.all(color: const Color(0xFFFF9800), width: 2)
                          : null,
                    ),
                    child: isValidDay
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelectedDate || isToday ? FontWeight.w600 : FontWeight.normal,
                                color: isSelectedDate 
                                    ? const Color(0xFFFF9800)
                                    : isToday 
                                        ? const Color(0xFF222222) 
                                        : const Color(0xFF484848),
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (dayEntries.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: dayEntries.take(3).map((entry) {
                                  return Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      color: _getIntensityColor(entry.intensityLevel),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        )
                      : null,
                  ),
                );
              },
            ),
            
            // 범례
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '강도별 색상',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF484848),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem('낮음', const Color(0xFF38A169)),
                      _buildLegendItem('중간', const Color(0xFFECC94B)),
                      _buildLegendItem('높음', const Color(0xFFFD9300)),
                      _buildLegendItem('매우높음', const Color(0xFFE53E3E)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateEntries(List<AnxietyEntry> entries) {
    final selectedDateEntries = _selectedCalendarDate != null
        ? entries.where((entry) {
            return entry.timestamp.year == _selectedCalendarDate!.year &&
                   entry.timestamp.month == _selectedCalendarDate!.month &&
                   entry.timestamp.day == _selectedCalendarDate!.day;
          }).toList()
        : <AnxietyEntry>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedCalendarDate!.month}월 ${_selectedCalendarDate!.day}일 기록',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedDateEntries.length}개',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 기록 리스트
        if (selectedDateEntries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.event_note,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  '이 날에는 기록이 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ...selectedDateEntries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildEntryCard(entry),
          )).toList(),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF717171),
          ),
        ),
      ],
    );
  }

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
            final searchedEntries = _searchEntries(filteredEntries);

            return CustomScrollView(
              slivers: [
                // Header section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                              ],
                            ),
                            Row(
                              children: [
                                // 검색 버튼
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSearchVisible = !_isSearchVisible;
                                      if (!_isSearchVisible) {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _isSearchVisible ? const Color(0xFF222222) : const Color(0xFFF7F7F7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: _isSearchVisible ? Colors.white : const Color(0xFF717171),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // 뷰 전환 버튼
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F7F7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isCalendarView = false;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: !_isCalendarView ? const Color(0xFF222222) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.list_rounded,
                                            color: !_isCalendarView ? Colors.white : const Color(0xFF717171),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isCalendarView = true;
                                            // 달력뷰로 전환할 때 오늘 날짜를 자동으로 선택
                                            if (_selectedCalendarDate == null) {
                                              _selectedCalendarDate = DateTime.now();
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _isCalendarView ? const Color(0xFF222222) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.calendar_month_rounded,
                                            color: _isCalendarView ? Colors.white : const Color(0xFF717171),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // 검색창
                        if (_isSearchVisible) ...[
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '키워드, 증상, 생각 등을 검색하세요',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.grey.shade500,
                                          size: 20,
                                        ),
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        
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
                                  if (filter == '날짜 선택') {
                                    _showDateRangePicker();
                                  } else {
                                    setState(() {
                                      _selectedFilter = filter;
                                      _isDateRangeSelected = false;
                                      _startDate = null;
                                      _endDate = null;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isSelected || (_isDateRangeSelected && filter == '날짜 선택')) ? const Color(0xFF1A1A1A) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: (isSelected || (_isDateRangeSelected && filter == '날짜 선택')) ? const Color(0xFF1A1A1A) : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _getFilterDisplayText(filter),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected || (_isDateRangeSelected && filter == '날짜 선택') ? Colors.white : Colors.grey.shade700,
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
                if (searchedEntries.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildNoResultsState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: _isCalendarView 
                      ? SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _buildCalendarView(searchedEntries),
                              // 선택된 날짜의 기록들
                              if (_selectedCalendarDate != null) ...[
                                const SizedBox(height: 24),
                                _buildSelectedDateEntries(searchedEntries),
                              ],
                            ],
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = searchedEntries[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildEntryCard(entry),
                              );
                            },
                            childCount: searchedEntries.length,
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

  String _getFilterDisplayText(String filter) {
    if (filter == '날짜 선택' && _isDateRangeSelected && _startDate != null && _endDate != null) {
      final start = DateFormat('M/d').format(_startDate!);
      final end = DateFormat('M/d').format(_endDate!);
      return '$start - $end';
    }
    return filter;
  }

  Future<void> _showYearPicker() async {
    final currentYear = DateTime.now().year;
    final startYear = currentYear - 10;
    final endYear = currentYear + 5;
    int selectedYear = _currentCalendarMonth.year;
    int selectedMonth = _currentCalendarMonth.month;
    
    // 현재 년도가 보이도록 스크롤 컨트롤러 설정
    final scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = selectedYear - startYear;
      final itemWidth = 80.0; // 각 년도 아이템 너비(72) + 마진(8)
      final scrollOffset = (currentIndex * itemWidth) - 100; // 현재 년도가 중앙 근처에 오도록
      if (scrollOffset > 0) {
        scrollController.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white, // 다이얼로그 배경을 흰색으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 450, maxWidth: 350),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '년도/월 선택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 20),
                
                // 년도 선택
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '년도',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF717171),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: endYear - startYear + 1,
                        itemBuilder: (context, index) {
                          final year = startYear + index;
                          final isSelected = year == selectedYear;
                          
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedYear = year;
                              });
                            },
                            child: Container(
                              width: 72, // 고정 너비 설정
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFF9800) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '$year',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : const Color(0xFF222222),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 월 선택
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '월',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF717171),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = month == selectedMonth;
                        
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedMonth = month;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFF9800) : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${month}월',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF222222),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 버튼들
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Color(0xFF717171),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentCalendarMonth = DateTime(selectedYear, selectedMonth);
                            _selectedCalendarDate = null;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null 
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A1A1A),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedFilter = '날짜 선택';
        _isDateRangeSelected = true;
      });
    }
  }

  List<AnxietyEntry> _filterEntries(List<AnxietyEntry> entries) {
    final now = DateTime.now();
    
    if (_isDateRangeSelected && _startDate != null && _endDate != null) {
      return entries.where((entry) {
        final entryDate = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
        final startDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
        final endDate = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
        return (entryDate.isAtSameMomentAs(startDate) || entryDate.isAfter(startDate)) &&
               (entryDate.isAtSameMomentAs(endDate) || entryDate.isBefore(endDate));
      }).toList();
    }
    
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

  List<AnxietyEntry> _searchEntries(List<AnxietyEntry> entries) {
    if (_searchQuery.isEmpty) {
      return entries;
    }
    
    final query = _searchQuery.toLowerCase();
    return entries.where((entry) {
      return entry.trigger.toLowerCase().contains(query) ||
             entry.negativeThoughts.toLowerCase().contains(query) ||
             entry.copingStrategy.toLowerCase().contains(query) ||
             entry.symptoms.any((symptom) => symptom.toLowerCase().contains(query));
    }).toList();
  }

  Widget _buildEntryCard(AnxietyEntry entry) {
    String formatTimestamp(DateTime timestamp) {
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
      color: Colors.white,
      child: Stack(
        children: [
          // Main content with padding
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header without menu button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Intensity circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getIntensityColor(entry.intensityLevel),
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 40), // 메뉴 버튼 공간 확보
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          formatTimestamp(entry.timestamp),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${entry.durationInMinutes}분',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
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
          ),
          
          // Menu button positioned at top right corner
          Positioned(
            top: 4,
            right: 4,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey.shade500,
                size: 20,
              ),
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  _editEntry(entry);
                } else if (value == 'delete') {
                  _deleteEntry(entry);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: Color(0xFF1A1A1A)),
                      SizedBox(width: 8),
                      Text(
                        '수정',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text(
                        '삭제',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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

  void _editEntry(AnxietyEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEntryPage(entryToEdit: entry),
      ),
    ).then((_) {
      // 수정 후 목록 새로고침
      ref.invalidate(entriesProvider);
    });
  }

  Future<void> _deleteEntry(AnxietyEntry entry) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '기록 삭제',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          '이 기록을 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다.',
          style: TextStyle(
            color: Color(0xFF717171),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF717171),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              '삭제',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true && entry.id != null) {
      try {
        final deleteUseCase = ref.read(deleteEntryUseCaseProvider);
        await deleteUseCase(entry.id!);
        
        // 상태 새로고침
        ref.invalidate(entriesProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('기록이 삭제되었습니다'),
              backgroundColor: Color(0xFF1A1A1A),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('삭제 중 오류가 발생했습니다: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}