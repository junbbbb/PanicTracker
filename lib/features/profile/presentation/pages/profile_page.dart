import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../entry/presentation/providers/anxiety_entry_providers.dart';
import '../../../entry/domain/entities/anxiety_entry.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '프로필',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '데이터 관리 및 앱 정보',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      title: '데이터 내보내기',
                      icon: Icons.download_rounded,
                      children: [
                        entriesAsync.when(
                          data: (entries) => Column(
                            children: [
                              _buildExportButton(
                                context,
                                'CSV로 내보내기',
                                Icons.table_chart_rounded,
                                () => _exportToCSV(context, entries),
                              ),
                              const SizedBox(height: 12),
                              _buildExportButton(
                                context,
                                'JSON으로 내보내기',
                                Icons.code_rounded,
                                () => _exportToJSON(context, entries),
                              ),
                            ],
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF5A5F),
                            ),
                          ),
                          error: (error, stack) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5A5F).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '오류: $error',
                              style: const TextStyle(
                                color: Color(0xFFFF5A5F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSectionCard(
                      title: '앱 정보',
                      icon: Icons.info_rounded,
                      children: [
                        _buildInfoTile(
                          icon: Icons.app_settings_alt_rounded,
                          title: '버전',
                          subtitle: '1.0.0',
                          color: const Color(0xFF00C9A7),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoTile(
                          icon: Icons.psychology_rounded,
                          title: '소개',
                          subtitle: '마음 기록은 불안 패턴을 모니터링하고 이해하는 데 도움을 드립니다.',
                          color: const Color(0xFFFFB400),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoTile(
                          icon: Icons.privacy_tip_rounded,
                          title: '개인정보',
                          subtitle: '모든 데이터는 기기에 로컬로 저장됩니다.',
                          color: const Color(0xFFFF5A5F),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
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
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFFF5A5F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildExportButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF5A5F).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A5F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFFF5A5F),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
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
        const SizedBox(width: 16),
        Expanded(
          child: Column(
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
              const SizedBox(height: 4),
              Text(
                subtitle,
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

  Future<void> _exportToCSV(BuildContext context, List<AnxietyEntry> entries) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/anxiety_entries.csv');

      final headers = [
        'Date',
        'Time',
        'Trigger',
        'Symptoms',
        'Negative Thoughts',
        'Coping Strategy',
        'Duration (minutes)',
      ];

      final rows = entries.map((entry) => [
        entry.timestamp.toString().split(' ')[0],
        entry.timestamp.toString().split(' ')[1],
        entry.trigger,
        entry.symptoms.join('; '),
        entry.negativeThoughts,
        entry.copingStrategy,
        entry.durationInMinutes.toString(),
      ]).toList();

      final csvData = [headers, ...rows];
      final csv = const ListToCsvConverter().convert(csvData);

      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV가 내보내기 완료: ${file.path}'),
          backgroundColor: const Color(0xFF00C9A7),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV 내보내기 오류: $e'),
          backgroundColor: const Color(0xFFFF5A5F),
        ),
      );
    }
  }

  Future<void> _exportToJSON(BuildContext context, List<AnxietyEntry> entries) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/anxiety_entries.json');

      final jsonData = entries.map((entry) => {
        'id': entry.id,
        'timestamp': entry.timestamp.toIso8601String(),
        'trigger': entry.trigger,
        'symptoms': entry.symptoms,
        'negativeThoughts': entry.negativeThoughts,
        'copingStrategy': entry.copingStrategy,
        'durationInMinutes': entry.durationInMinutes,
      }).toList();

      await file.writeAsString(jsonData.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('JSON이 내보내기 완료: ${file.path}'),
          backgroundColor: const Color(0xFF00C9A7),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('JSON 내보내기 오류: $e'),
          backgroundColor: const Color(0xFFFF5A5F),
        ),
      );
    }
  }
}