import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/classification_result.dart';
import '../widgets/bottom_nav.dart';
import '../screens/maturity_screen.dart';
import 'history_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

class ClassificationScreen extends StatefulWidget {
  final ClassificationResult result;
  const ClassificationScreen({super.key, required this.result});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _barController;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();
    _barAnim = CurvedAnimation(parent: _barController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
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
                      'Classification',
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
            // ── Sample Image ───────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFF2E4A35),
                      child: const Icon(
                        Icons.eco_rounded,
                        size: 80,
                        color: Color(0xFF4A7C59),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🌿', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 5),
                            Text(
                              r.sampleType,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Identified Species ─────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'IDENTIFIED SPECIES',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: AppColors.textMuted,
                    fontFamily: 'sans-serif',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      const Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              r.commonName,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              r.scientificName,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 16),

            // ── Confidence Bar ─────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.premiumShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MATCH CONFIDENCE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.2,
                          color: AppColors.textMuted,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      Text(
                        '${r.confidence}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedBuilder(
                      animation: _barAnim,
                      builder: (_, _) => LinearProgressIndicator(
                        value: (r.confidence / 100) * _barAnim.value,
                        backgroundColor: AppColors.surface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Species Metadata ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.premiumShadow,
              ),
              child: Row(
                children: [
                  _MetaItem(label: 'FAMILY', value: r.family),
                  _MetaDivider(),
                  _MetaItem(label: 'ORIGIN', value: r.origin),
                  _MetaDivider(),
                  _MetaItem(label: 'WOOD TYPE', value: r.woodType),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Alternative Matches ────────────────────────
            const Text(
              'ALTERNATIVE MATCHES',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.textMuted,
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: r.alternatives.length,
                itemBuilder: (_, i) {
                  final alt = r.alternatives[i];
                  return _AltCard(alt: alt);
                },
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
                      builder: (_) =>
                          MaturityScreen(result: widget.result),
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
                      'View Suitability Report',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: AppColors.textLight,
              fontFamily: 'sans-serif',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _AltCard extends StatelessWidget {
  final AlternativeMatch alt;
  const _AltCard({required this.alt});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 70,
              color: const Color(0xFF3A5C42),
              child: const Center(
                child: Icon(Icons.park_rounded,
                    size: 30, color: Color(0xFF6A9E76)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alt.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${alt.confidence}% Match',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
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
