import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/entry/presentation/pages/add_entry_page.dart';
import '../../features/analysis/presentation/pages/analysis_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const AnalysisPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: '홈',
                  index: 0,
                  isSelected: _currentIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  label: '기록',
                  index: 1,
                  isSelected: _currentIndex == 1,
                ),
                _buildAddButton(),
                _buildNavItem(
                  icon: Icons.analytics_rounded,
                  label: '분석',
                  index: 2,
                  isSelected: _currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: '프로필',
                  index: 3,
                  isSelected: _currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                        Icon(
              icon,
              size: 24,
              color: isSelected 
                  ? const Color(0xFFFF5A5F)
                  : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? const Color(0xFFFF5A5F)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEntryPage(),
          ),
        ).then((_) {
          // 저장 후 돌아왔을 때 홈 탭으로 이동
        setState(() {
            _currentIndex = 0;
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add_rounded,
                color: Colors.grey.shade700,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}