import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../providers/scan_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.watch<ScanProvider>().currentResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Result')),
        body: const Center(child: Text('No result data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Species Classification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s16),
            _buildClassificationCard(result.classification),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Decision Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s16),
            StatusCard(
              uiState: result.decisionSupport.uiState,
              title: result.decisionSupport.recommendationLabel,
              description: 'DENR Status: ${result.decisionSupport.denrStatus}\nFPRDI Group: ${result.decisionSupport.fprdiGroup}',
            ),
            const SizedBox(height: AppSpacing.s40),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Back to Dashboard',
                icon: Icons.home,
                onPressed: () {
                  context.read<ScanProvider>().reset();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationCard(classification) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classification.commonName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            classification.scientificName,
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Confidence Score:', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '${(classification.confidenceScore * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
