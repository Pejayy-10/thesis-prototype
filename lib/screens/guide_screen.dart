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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guide'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
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
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : const Color(0xFFDDD9D3),
                      ),
                    ),
                    child: Text(
                      _categories[i],
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

          const SizedBox(height: 12),

          // ── Content ───────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_activeCategory == 'Species') ...[
                  const _SectionHeader(
                    title: '5 Classified Species',
                    sub: 'Based on FPRDI strength groupings and DENR standards',
                  ),
                  ..._species.map((s) => _SpeciesCard(species: s)),
                ] else if (_activeCategory == 'How to Scan') ...[
                  const _SectionHeader(
                    title: 'Scanning Guide',
                    sub: 'Follow these steps for accurate classification',
                  ),
                  ..._scanSteps.map((s) => _StepCard(step: s)),
                ] else ...[
                  const _SectionHeader(
                    title: 'Legal References',
                    sub: 'Philippine laws governing timber use and protection',
                  ),
                  ..._regulations.map((r) => _RegCard(reg: r)),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(species['icon'] as IconData,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      species['scientific'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(species['statusColor'] as int).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  species['status'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(species['statusColor'] as int),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0EDE8)),
          const SizedBox(height: 10),
          Row(
            children: [
              _PropChip(label: 'Strength', value: species['strength'] as String),
              const SizedBox(width: 8),
              _PropChip(label: 'Durability', value: species['durability'] as String),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.construction_rounded,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 5),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step['step'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
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
                  step['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['desc'] as String,
                  style: const TextStyle(
                    fontSize: 12,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(reg['icon'] as IconData,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reg['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  reg['desc'] as String,
                  style: const TextStyle(
                    fontSize: 12,
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
