import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/classification_result.dart';

class ConstructionRecommendationScreen extends StatefulWidget {
  final ClassificationResult result;
  const ConstructionRecommendationScreen({super.key, required this.result});

  @override
  State<ConstructionRecommendationScreen> createState() =>
      _ConstructionRecommendationScreenState();
}

class _ConstructionRecommendationScreenState
    extends State<ConstructionRecommendationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();
    _scoreAnim =
        CurvedAnimation(parent: _scoreController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  Color _ratingColor(String rating) {
    switch (rating) {
      case 'HIGHLY RECOMMENDED':
        return AppColors.primary;
      case 'RECOMMENDED':
        return const Color(0xFF4A7C59);
      case 'LIMITED USE':
        return AppColors.gold;
      default:
        return AppColors.danger;
    }
  }

  Color _suitabilityColor(int level) {
    switch (level) {
      case 3:
        return AppColors.primary;
      case 2:
        return const Color(0xFF4A90D9);
      case 1:
        return AppColors.gold;
      default:
        return AppColors.danger;
    }
  }

  IconData _suitabilityIcon(int level) {
    switch (level) {
      case 3:
        return Icons.check_circle_rounded;
      case 2:
        return Icons.check_circle_outline_rounded;
      case 1:
        return Icons.remove_circle_outline_rounded;
      default:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final rec = r.constructionRecommendation;
    final ratingColor = _ratingColor(rec.overallRating);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Construction Recommendation'),
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
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
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
                  Expanded(
                    child: Column(
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
                  ),
                  // Strength badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      r.maturityInfo.woodProperties.strengthGrade,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Overall Rating Card ────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ratingColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Score circle
                  AnimatedBuilder(
                    animation: _scoreAnim,
                    builder: (_, __) {
                      final displayScore =
                          (rec.overallScore * _scoreAnim.value).round();
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value:
                                  (rec.overallScore / 100) * _scoreAnim.value,
                              strokeWidth: 7,
                              backgroundColor:
                                  Colors.white.withOpacity(0.2),
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$displayScore',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              const Text(
                                '/100',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  Text(
                    rec.overallRating,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontFamily: 'Georgia',
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    rec.overallRationale,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Application Suitability ────────────────────
            const _SectionLabel(label: 'APPLICATION SUITABILITY'),
            const SizedBox(height: 10),

            ...rec.uses.map((use) => _UseTile(
                  use: use,
                  color: _suitabilityColor(use.suitabilityLevel),
                  icon: _suitabilityIcon(use.suitabilityLevel),
                )),

            const SizedBox(height: 20),

            // ── Pros & Limitations ─────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ProsConsCard(
                    title: 'Advantages',
                    icon: Icons.thumb_up_alt_rounded,
                    iconColor: AppColors.primary,
                    items: rec.pros,
                    bgColor: AppColors.primaryLight,
                    textColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProsConsCard(
                    title: 'Limitations',
                    icon: Icons.thumb_down_alt_rounded,
                    iconColor: AppColors.danger,
                    items: rec.limitations,
                    bgColor: const Color(0xFFFFF0F0),
                    textColor: AppColors.danger,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Procurement Note ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.gold.withOpacity(0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: AppColors.gold),
                      const SizedBox(width: 8),
                      const Text(
                        'PROCUREMENT GUIDANCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rec.procurementNote,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDark,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Summary Footer ─────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _FooterStat(
                      label: 'Strength',
                      value: r.maturityInfo.woodProperties.strengthGrade
                          .split(' ')
                          .first,
                    ),
                  ),
                  _FooterDivider(),
                  Expanded(
                    child: _FooterStat(
                      label: 'Durability',
                      value: r.maturityInfo.woodProperties.durabilityClass
                          .split(' ')
                          .first,
                    ),
                  ),
                  _FooterDivider(),
                  Expanded(
                    child: _FooterStat(
                      label: 'Workability',
                      value: r.maturityInfo.woodProperties.workability,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── CTA: Back to Start ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
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
                    Icon(Icons.camera_alt_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Scan Another Sample',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.5,
        color: AppColors.textMuted,
        fontFamily: 'sans-serif',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _UseTile extends StatelessWidget {
  final ConstructionUse use;
  final Color color;
  final IconData icon;

  const _UseTile({
    required this.use,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  use.application,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  use.suitability,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Suitability bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: use.suitabilityLevel / 3,
              minHeight: 4,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            use.reason,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProsConsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> items;
  final Color bgColor;
  final Color textColor;

  const _ProsConsCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: textColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterStat extends StatelessWidget {
  final String label;
  final String value;
  const _FooterStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _FooterDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.surface,
    );
  }
}
