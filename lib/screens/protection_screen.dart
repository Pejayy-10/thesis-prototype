import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/classification_result.dart';
import '../widgets/bottom_nav.dart';
import 'maturity_screen.dart';
import 'history_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

class ProtectionScreen extends StatefulWidget {
  final ClassificationResult result;
  const ProtectionScreen({super.key, required this.result});

  @override
  State<ProtectionScreen> createState() => _ProtectionScreenState();
}

class _ProtectionScreenState extends State<ProtectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final p = r.protectionInfo;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Protection Status'),
        leading: const BackButton(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Species Header ─────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(Icons.eco_rounded,
                        color: AppColors.primary, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.commonName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        r.scientificName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Protection Badge ───────────────────────────
            Center(
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer pulsing ring
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.danger.withValues(alpha: 0.25),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        // Inner dashed ring (simulated with border)
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.danger.withValues(alpha: 0.08),
                            border: Border.all(
                              color: AppColors.danger.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            color: AppColors.danger,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    r.isProtected ? 'PROTECTED\nSPECIES' : 'NOT\nPROTECTED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Georgia',
                      color:
                          r.isProtected ? AppColors.danger : AppColors.primary,
                      height: 1.15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Protection Details Card ────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _ProtectionRow(
                    label: 'DENR\nCLASSIFICATION',
                    value: p.denrClassification,
                    isFirst: true,
                  ),
                  const Divider(height: 1, color: Color(0xFFF0EDE8)),
                  _ProtectionRow(
                    label: 'CITES APPENDIX',
                    value: p.citesAppendix,
                  ),
                  const Divider(height: 1, color: Color(0xFFF0EDE8)),
                  _ProtectionRow(
                    label: 'LOCAL NAME',
                    value: p.localName,
                  ),
                  const Divider(height: 1, color: Color(0xFFF0EDE8)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PERMIT REQUIRED',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: AppColors.textMuted,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: p.permitRequired
                                ? AppColors.danger
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            p.permitRequired ? 'YES' : 'NO',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Legal Warning ──────────────────────────────
            if (r.isProtected)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cutting or transporting this species without a valid DENR permit is punishable under P.D. 705 and R.A. 9175.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // ── CTA ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaturityScreen(result: widget.result),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Check Maturity',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: globalNavIndex,
        builder: (context, navIndex, _) {
          return WoodConNetBottomNav(
            currentIndex: navIndex,
            onTap: (i) {
              if (i == navIndex) return;
              switch (i) {
                case 1:
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HistoryScreen()), (route) => false);
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
          );
        },
      ),
    );
  }
}

class _ProtectionRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isFirst;

  const _ProtectionRow({
    required this.label,
    required this.value,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 14 : 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
              fontFamily: 'sans-serif',
              height: 1.4,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
