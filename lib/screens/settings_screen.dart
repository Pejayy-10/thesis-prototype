import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../core/theme.dart';
import '../widgets/bottom_nav.dart';
import 'history_screen.dart';
import 'guide_screen.dart';
import 'capture_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _navIndex = 3;

  bool _saveHistory = true;
  bool _showConfidence = true;
  bool _showAlternatives = true;
  bool _darkMode = false;
  String _defaultSample = 'Leaf';

  final List<String> _sampleOptions = ['Leaf', 'Bark', 'Trunk', 'Wood Grain'];

  @override
  Widget build(BuildContext context) {
    Widget _buildAnimatedItem(Widget child, int index) {
      return TweenAnimationBuilder<double>(
        key: ValueKey('settings_item_$index'),
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 400 + (index * 100)),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: child,
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 120),
        children: [
          // ── Large Header ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          // ── App Info Card ──────────────────────────────────
          _buildAnimatedItem(
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.forest_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WoodConNet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Version 1.0.0  •  Thesis Prototype',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            0,
          ),

          const SizedBox(height: 20),

          // ── Scan Preferences ──────────────────────────────
          _buildAnimatedItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(label: 'SCAN PREFERENCES'),
                _SettingsCard(
                  children: [
                    _DropdownTile(
                      icon: Icons.eco_rounded,
                      label: 'Default Sample Type',
                      value: _defaultSample,
                      options: _sampleOptions,
                      onChanged: (v) => setState(() => _defaultSample = v!),
                    ),
                    const _Divider(),
                    _ToggleTile(
                      icon: Icons.percent_rounded,
                      label: 'Show Confidence Score',
                      value: _showConfidence,
                      onChanged: (v) => setState(() => _showConfidence = v),
                    ),
                    const _Divider(),
                    _ToggleTile(
                      icon: Icons.compare_arrows_rounded,
                      label: 'Show Alternative Matches',
                      value: _showAlternatives,
                      onChanged: (v) => setState(() => _showAlternatives = v),
                    ),
                  ],
                ),
              ],
            ),
            1,
          ),

          const SizedBox(height: 16),

          // ── Data & Privacy ─────────────────────────────────
          _buildAnimatedItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(label: 'DATA & PRIVACY'),
                _SettingsCard(
                  children: [
                    _ToggleTile(
                      icon: Icons.history_rounded,
                      label: 'Save Scan History',
                      value: _saveHistory,
                      onChanged: (v) => setState(() => _saveHistory = v),
                    ),
                    const _Divider(),
                    _TapTile(
                      icon: Icons.delete_outline_rounded,
                      label: 'Clear Scan History',
                      labelColor: AppColors.danger,
                      iconColor: AppColors.danger,
                      onTap: () => _showClearDialog(context),
                    ),
                  ],
                ),
              ],
            ),
            2,
          ),

          const SizedBox(height: 16),

          // ── Display ────────────────────────────────────────
          _buildAnimatedItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(label: 'DISPLAY'),
                _SettingsCard(
                  children: [
                    _ToggleTile(
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark Mode',
                      sub: 'Coming soon',
                      value: _darkMode,
                      onChanged: null,
                    ),
                  ],
                ),
              ],
            ),
            3,
          ),

          const SizedBox(height: 16),

          // ── About ──────────────────────────────────────────
          _buildAnimatedItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(label: 'ABOUT'),
                _SettingsCard(
                  children: [
                    _TapTile(
                      icon: Icons.school_outlined,
                      label: 'Thesis Information',
                      onTap: () => _showThesisInfo(context),
                    ),
                    const _Divider(),
                    _TapTile(
                      icon: Icons.account_balance_outlined,
                      label: 'WMSU College of Computing Studies',
                      onTap: () {},
                    ),
                    const _Divider(),
                    _TapTile(
                      icon: Icons.article_outlined,
                      label: 'Data Sources',
                      sub: 'iNaturalist, GBIF, FPRDI, DENR RO IX',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            4,
          ),

          const SizedBox(height: 20),

          // ── Version Footer ────────────────────────────────
          _buildAnimatedItem(
            const Center(
              child: Text(
                'WoodConNet  •  WMSU CCS  •  2026',
                style: TextStyle(fontSize: 11, color: AppColors.textLight),
              ),
            ),
            5,
          ),

          const SizedBox(height: 16),
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
            case 2:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const GuideScreen()), (route) => false);
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear History',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 17)),
        content: const Text(
          'This will permanently delete all scan history. This action cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear',
                style: TextStyle(color: AppColors.danger,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showThesisInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thesis Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                )),
            const SizedBox(height: 16),
            _InfoLine(label: 'Title',
                value: 'WoodConNet: Philippine Native Tree Species Classification for Construction Suitability'),
            const SizedBox(height: 10),
            _InfoLine(label: 'Model', value: 'ResNet-50 + EfficientNet-B4 (Feature Fusion CNN)'),
            const SizedBox(height: 10),
            _InfoLine(label: 'Species', value: 'Narra, Molave, Ipil, Apitong, White Lauan'),
            const SizedBox(height: 10),
            _InfoLine(label: 'Standards', value: 'FPRDI Strength Groupings, DENR DAO 2026-20'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Supporting Widgets ─────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1.5,
          color: AppColors.textDark,
          fontFamily: 'sans-serif',
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 52,
      color: Color(0xFFF0EDE8),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    this.sub,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textDark)),
                if (sub != null)
                  Text(sub!,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _TapTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  const _TapTile({
    required this.icon,
    required this.label,
    this.sub,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: iconColor ?? AppColors.primary, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: labelColor ?? AppColors.textDark,
                    ),
                  ),
                  if (sub != null)
                    Text(sub!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textDark)),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: options
                  .map((o) => DropdownMenuItem(
                        value: o,
                        child: Text(o,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500)),
                      ))
                  .toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.expand_more_rounded,
                  size: 18, color: AppColors.textMuted),
              style: const TextStyle(fontSize: 13, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
