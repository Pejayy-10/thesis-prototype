import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../core/theme.dart';
import '../widgets/bottom_nav.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'capture_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _navIndex = 2;
  String _activeCategory = 'Species';

  final List<String> _categories = ['Species', 'How to Scan', 'Regulations'];

  final List<Map<String, dynamic>> _species = [
    {
      'name': 'Narra',
      'scientific': 'Pterocarpus indicus',
      'strength': 'D40 (High)',
      'durability': 'Class 2',
      'status': 'Critically Endangered',
      'statusColor': 0xFFB83232,
      'suitability': 'High-grade structural timber',
      'icon': Icons.eco_rounded,
    },
    {
      'name': 'Molave',
      'scientific': 'Vitex parviflora',
      'strength': 'D60 (Very High)',
      'durability': 'Class 1',
      'status': 'Vulnerable',
      'statusColor': 0xFFD4A017,
      'suitability': 'Heavy construction, flooring',
      'icon': Icons.park_rounded,
    },
    {
      'name': 'Ipil',
      'scientific': 'Intsia bijuga',
      'strength': 'D60 (Very High)',
      'durability': 'Class 1',
      'status': 'Vulnerable',
      'statusColor': 0xFFD4A017,
      'suitability': 'Heavy beams, bridge components',
      'icon': Icons.forest_rounded,
    },
    {
      'name': 'Apitong',
      'scientific': 'Dipterocarpus grandiflorus',
      'strength': 'D40 (High)',
      'durability': 'Class 2',
      'status': 'Least Concern',
      'statusColor': 0xFF2D5A3D,
      'suitability': 'General construction, framing',
      'icon': Icons.nature_rounded,
    },
    {
      'name': 'White Lauan',
      'scientific': 'Shorea contorta',
      'strength': 'D30 (Moderate)',
      'durability': 'Class 3',
      'status': 'Critically Endangered',
      'statusColor': 0xFFB83232,
      'suitability': 'Light construction, paneling',
      'icon': Icons.eco_outlined,
    },
  ];

  final List<Map<String, dynamic>> _scanSteps = [
    {
      'step': '01',
      'title': 'Choose Sample Type',
      'desc': 'Select Leaf, Bark, Trunk, or Wood Grain depending on what part of the tree you are scanning.',
      'icon': Icons.touch_app_rounded,
    },
    {
      'step': '02',
      'title': 'Align the Camera',
      'desc': 'Position the camera so the sample fills the scan frame. Ensure good lighting and a clear, focused shot.',
      'icon': Icons.center_focus_strong_rounded,
    },
    {
      'step': '03',
      'title': 'Capture the Image',
      'desc': 'Tap the shutter button. The system will analyze the image and identify the species.',
      'icon': Icons.camera_alt_rounded,
    },
    {
      'step': '04',
      'title': 'Review the Result',
      'desc': 'Check the Classification screen for the identified species, confidence score, and alternative matches.',
      'icon': Icons.checklist_rounded,
    },
    {
      'step': '05',
      'title': 'Check Suitability',
      'desc': 'Tap "View Suitability Report" to see maturity status, wood properties, and protection classification.',
      'icon': Icons.verified_rounded,
    },
  ];

  final List<Map<String, dynamic>> _regulations = [
    {
      'law': 'P.D. 705',
      'title': 'Revised Forestry Code',
      'desc': 'Prohibits cutting, gathering, or transporting timber without proper permits from DENR.',
      'icon': Icons.gavel_rounded,
    },
    {
      'law': 'R.A. 9175',
      'title': 'Chainsaw Act of 2002',
      'desc': 'Regulates the ownership and use of chainsaws to prevent illegal logging.',
      'icon': Icons.policy_rounded,
    },
    {
      'law': 'DENR DAO 2026-20',
      'title': 'Wood Suitability Standards',
      'desc': 'Sets the FPRDI-based strength groupings used to classify wood for construction applications.',
      'icon': Icons.article_rounded,
    },
    {
      'law': 'CITES Appendix II',
      'title': 'International Trade Control',
      'desc': 'Species listed under CITES Appendix II require documentation for international trade.',
      'icon': Icons.public_rounded,
    },
  ];

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
                'Guide',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          // ── Category Tabs ─────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final bool active = _categories[i] == _activeCategory;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _activeCategory = _categories[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
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
                        _categories[i],
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

          const SizedBox(height: 12),

          // ── Content ───────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
              children: [
                if (_activeCategory == 'Species') ...[
                  const _SectionHeader(
                    title: '5 Classified Species',
                    sub: 'Based on FPRDI strength groupings and DENR standards',
                  ),
                  ..._species.asMap().entries.map((entry) {
                    final int i = entry.key;
                    final s = entry.value;
                    return TweenAnimationBuilder<double>(
                      key: ValueKey('${s['name']}_$_activeCategory'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (i * 100)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _SpeciesCard(species: s),
                    );
                  }),
                ] else if (_activeCategory == 'How to Scan') ...[
                  const _SectionHeader(
                    title: 'Scanning Guide',
                    sub: 'Follow these steps for accurate classification',
                  ),
                  ..._scanSteps.asMap().entries.map((entry) {
                    final int i = entry.key;
                    final s = entry.value;
                    return TweenAnimationBuilder<double>(
                      key: ValueKey('${s['step']}_$_activeCategory'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (i * 100)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _StepCard(step: s),
                    );
                  }),
                ] else ...[
                  const _SectionHeader(
                    title: 'Legal References',
                    sub: 'Philippine laws governing timber use and protection',
                  ),
                  ..._regulations.asMap().entries.map((entry) {
                    final int i = entry.key;
                    final r = entry.value;
                    return TweenAnimationBuilder<double>(
                      key: ValueKey('${r['law']}_$_activeCategory'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (i * 100)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _RegCard(reg: r),
                    );
                  }),
                ],
                const SizedBox(height: 16),
              ],
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
            case 1:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HistoryScreen()), (route) => false);
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

// ── Section Header ─────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String sub;
  const _SectionHeader({required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: AppColors.textDark,
              )),
          const SizedBox(height: 2),
          Text(sub,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ── Species Card ───────────────────────────────────────────

class _SpeciesCard extends StatelessWidget {
  final Map<String, dynamic> species;
  const _SpeciesCard({required this.species});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData badgeIcon;
    final status = species['status'] as String;
    if (status == 'Critically Endangered') {
      badgeColor = const Color(0xFFD32F2F); // Vibrant Red
      badgeIcon = Icons.warning_rounded;
    } else if (status == 'Vulnerable') {
      badgeColor = const Color(0xFFF57F17); // Vibrant Orange
      badgeIcon = Icons.info_outline_rounded;
    } else {
      badgeColor = const Color(0xFF2E7D32); // Vibrant Green
      badgeIcon = Icons.verified_user_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(species['icon'] as IconData,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Georgia',
                        color: AppColors.textDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      species['scientific'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0EDE8)),
          const SizedBox(height: 12),
          Row(
            children: [
              _PropChip(label: 'Strength', value: species['strength'] as String),
              const SizedBox(width: 8),
              _PropChip(label: 'Durability', value: species['durability'] as String),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.construction_rounded,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                species['suitability'] as String,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PropChip extends StatelessWidget {
  final String label;
  final String value;
  const _PropChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textLight,
                fontFamily: 'sans-serif',
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontFamily: 'sans-serif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step Card ──────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final Map<String, dynamic> step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                step['step'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step['desc'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Regulation Card ────────────────────────────────────────

class _RegCard extends StatelessWidget {
  final Map<String, dynamic> reg;
  const _RegCard({required this.reg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(reg['icon'] as IconData,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reg['law'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        reg['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  reg['desc'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
