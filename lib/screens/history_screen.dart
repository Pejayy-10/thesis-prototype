import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../core/theme.dart';
import '../widgets/bottom_nav.dart';
import '../models/classification_result.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';
import 'capture_screen.dart';
import 'classification_screen.dart';

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
      'result': MockResults.narra,
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
      'result': MockResults.molave,
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
      'result': MockResults.narra,
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
      'result': MockResults.molave,
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
      'result': MockResults.narra,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _mockHistory;
    return _mockHistory.where((h) => h['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Large Header ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 12),
              child: const Text(
                'History',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          
          // ── Search Bar ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: AppTheme.premiumShadow,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by species or date...',
                  hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          active ? AppColors.primary : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: active ? [] : AppTheme.premiumShadow,
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              active ? Colors.white : AppColors.textMuted,
                        ),
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
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              '${_filtered.length} scan${_filtered.length != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
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
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        return TweenAnimationBuilder<double>(
                          key: ValueKey('${_filtered[i]['species']}_$_filter'),
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (i * 100)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: _HistoryCard(item: _filtered[i]),
                        );
                      },
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
    // Determine vibrant colors and icons for status
    Color badgeColor;
    IconData badgeIcon;
    final status = item['status'] as String;
    if (status == 'Approved') {
      badgeColor = const Color(0xFF2E7D32); // Vibrant Green
      badgeIcon = Icons.check_circle_rounded;
    } else if (status == 'Rejected') {
      badgeColor = const Color(0xFFD32F2F); // Vibrant Red
      badgeIcon = Icons.cancel_rounded;
    } else {
      badgeColor = const Color(0xFFF57F17); // Vibrant Orange/Yellow
      badgeIcon = Icons.schedule_rounded;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClassificationScreen(
              result: item['result'] as ClassificationResult,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.premiumShadow,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item['icon'] as IconData,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),

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
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Georgia',
                          color: AppColors.textDark,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(badgeIcon, size: 12, color: badgeColor),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: badgeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['scientific'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMuted.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Tag(label: item['sampleType'] as String),
                      const SizedBox(width: 6),
                      _Tag(label: '${item['confidence']}% match'),
                      const Spacer(),
                      Text(
                        '${item['date']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
