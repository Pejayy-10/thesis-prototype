import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/classification_result.dart';
import '../widgets/bottom_nav.dart';
import 'protection_screen.dart';
import 'construction_recommendation_screen.dart';
import 'history_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

class MaturityScreen extends StatefulWidget {
  final ClassificationResult result;
  const MaturityScreen({super.key, required this.result});

  @override
  State<MaturityScreen> createState() => _MaturityScreenState();
}

class _MaturityScreenState extends State<MaturityScreen> {

  final List<String> _stages = ['Seedling', 'Sapling', 'Young Adult', 'Mature'];

  Color _strengthColor(String grade) {
    if (grade.contains('Very High') || grade.contains('D60') || grade.contains('D80')) {
      return AppColors.primary;
    }
    if (grade.contains('High') || grade.contains('D40')) return AppColors.gold;
    return AppColors.textMuted;
  }

  Color _durabilityColor(String cls) {
    if (cls.contains('Class 1')) return AppColors.primary;
    if (cls.contains('Class 2')) return const Color(0xFF4A90D9);
    return AppColors.textMuted;
  }

  Color _workabilityColor(String w) {
    if (w == 'Excellent') return AppColors.primary;
    if (w == 'Moderate') return AppColors.gold;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final m = r.maturityInfo;
    final wp = m.woodProperties;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ──────────────────────────────────────
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.premiumShadow,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 22),
                        ),
                      ),
                    ),
                    const Text(
                      'Suitability Report',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Species Header Card ────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.premiumShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: AppColors.primary, size: 24),
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
                          color: AppColors.textDark,
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

            const SizedBox(height: 20),

            // ── Maturity Badge ─────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_work_rounded,
                            color: Colors.white, size: 36),
                        const SizedBox(height: 4),
                        Text(
                          m.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      m.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Min Harvest Age & DBH ──────────────────────
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    label: 'MIN. HARVEST AGE',
                    value: m.minHarvestAge,
                    valueColor: AppColors.gold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    label: 'REQUIRED DBH',
                    value: m.requiredDbh,
                    valueColor: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Growth Timeline ────────────────────────────
            const Text(
              'GROWTH TIMELINE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.textMuted,
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _GrowthTimeline(
              stages: _stages,
              currentStage: m.growthStage,
            ),

            const SizedBox(height: 24),

            // ── Wood Properties ────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      children: [
                        const Icon(Icons.dashboard_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'WOOD PROPERTIES',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFCCDDD3)),
                  _PropRow(
                    label: 'Strength Grade',
                    value: wp.strengthGrade,
                    valueColor: _strengthColor(wp.strengthGrade),
                  ),
                  const Divider(height: 1, color: Color(0xFFCCDDD3)),
                  _PropRow(
                    label: 'Durability Class',
                    value: wp.durabilityClass,
                    valueColor: _durabilityColor(wp.durabilityClass),
                  ),
                  const Divider(height: 1, color: Color(0xFFCCDDD3)),
                  _PropRow(
                    label: 'Workability',
                    value: wp.workability,
                    valueColor: _workabilityColor(wp.workability),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProtectionScreen(result: widget.result),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Protection Status',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConstructionRecommendationScreen(result: widget.result),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'View Construction Recommendation',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Supporting Widgets ─────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
              fontFamily: 'sans-serif',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PropRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _PropRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthTimeline extends StatelessWidget {
  final List<String> stages;
  final int currentStage;

  const _GrowthTimeline({required this.stages, required this.currentStage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stages.length, (i) {
        final bool isActive = i <= currentStage;
        final bool isCurrent = i == currentStage;
        final bool isLast = i == stages.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Line + node
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 3,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.surface,
                        ),
                        if (isCurrent)
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stages[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.textLight,
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 0,
                ), // spacer handled by Expanded
            ],
          ),
        );
      }),
    );
  }
}
