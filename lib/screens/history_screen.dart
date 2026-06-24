import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../core/theme.dart';
import '../widgets/bottom_nav.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';
import 'capture_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _navIndex = 1;
  String _filter = 'All';

  final List<String> _filters = ['All', 'Approved', 'Deferred', 'Rejected'];

  final List<Map<String, dynamic>> _mockHistory = [
    {
      'species': 'Narra',
      'scientific': 'Pterocarpus indicus',
      'sampleType': 'Leaf',
      'confidence': 94,
      'status': 'Rejected',
      'statusColor': 0xFFB83232,
      'date': 'Jun 23, 2026',
      'time': '05:41 PM',
      'icon': Icons.eco_rounded,
    },
    {
      'species': 'Molave',
      'scientific': 'Vitex parviflora',
      'sampleType': 'Bark',
      'confidence': 88,
      'status': 'Approved',
      'statusColor': 0xFF2D5A3D,
      'date': 'Jun 23, 2026',
      'time': '03:12 PM',
      'icon': Icons.park_rounded,
    },
    {
      'species': 'Ipil',
      'scientific': 'Intsia bijuga',
      'sampleType': 'Trunk',
      'confidence': 79,
      'status': 'Deferred',
      'statusColor': 0xFFD4A017,
      'date': 'Jun 22, 2026',
      'time': '10:05 AM',
      'icon': Icons.nature_rounded,
    },
    {
      'species': 'Apitong',
      'scientific': 'Dipterocarpus grandiflorus',
      'sampleType': 'Wood Grain',
      'confidence': 85,
      'status': 'Approved',
      'statusColor': 0xFF2D5A3D,
      'date': 'Jun 21, 2026',
      'time': '02:30 PM',
      'icon': Icons.forest_rounded,
    },
    {
      'species': 'White Lauan',
      'scientific': 'Shorea contorta',
      'sampleType': 'Leaf',
      'confidence': 72,
      'status': 'Deferred',
      'statusColor': 0xFFD4A017,
      'date': 'Jun 20, 2026',
      'time': '09:18 AM',
      'icon': Icons.eco_rounded,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _mockHistory;
    return _mockHistory.where((h) => h['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('History'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter Chips ─────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final bool active = _filters[i] == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          active ? AppColors.primary : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : const Color(0xFFDDD9D3),
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color:
                            active ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Count label ──────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              '${_filtered.length} scan${_filtered.length != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),

          // ── List ─────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const _EmptyState(
                    icon: Icons.history_rounded,
                    message: 'No scans found',
                    sub: 'Your scan history will appear here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) =>
                        _HistoryCard(item: _filtered[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: WoodConNetBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          if (i == _navIndex) return;
          switch (i) {
            case 0:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaptureScreen(cameras: [])), (route) => false);
              break;
            case 2:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const GuideScreen()), (route) => false);
              break;
            case 3:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SettingsScreen()), (route) => false);
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['icon'] as IconData,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['species'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: AppColors.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(item['statusColor'] as int)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(item['statusColor'] as int),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item['scientific'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Tag(label: item['sampleType'] as String),
                    const SizedBox(width: 6),
                    _Tag(label: '${item['confidence']}% match'),
                    const Spacer(),
                    Text(
                      '${item['date']}  ${item['time']}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
