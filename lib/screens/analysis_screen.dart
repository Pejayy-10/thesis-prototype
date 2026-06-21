import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../providers/scan_provider.dart';
import '../widgets/primary_button.dart';
import '../data/models/scan_result.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  ScanProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_provider == null) {
      _provider = context.read<ScanProvider>();
      _provider!.addListener(_onStateChange);
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (!mounted) return;
    if (_provider?.state == ScanState.success) {
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Analyzing...'),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: _buildContent(provider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ScanProvider provider) {
    if (provider.state == ScanState.error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.signalCritical),
          const SizedBox(height: AppSpacing.s16),
          const Text(
            'Analysis Failed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.signalCritical),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            provider.errorMessage ?? 'An unknown error occurred.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s32),
          PrimaryButton(
            label: 'Retry',
            icon: Icons.refresh,
            onPressed: () {
              provider.analyzeImage('mock/path.jpg', InputModality.woodGrain);
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 4),
        const SizedBox(height: AppSpacing.s24),
        const Text(
          'Extracting Features...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          'Simulating ResNet-50 + EfficientNet-B4',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
