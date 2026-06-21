import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../data/models/scan_result.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Analyzing...')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current State: ${provider.state.name}'),
            const SizedBox(height: 16),
            if (provider.state == ScanState.loading)
              const CircularProgressIndicator(),
            if (provider.state == ScanState.success)
              Text('Result: ${provider.currentResult?.classification.commonName}'),
            if (provider.state == ScanState.error)
              Text('Error: ${provider.errorMessage}', style: const TextStyle(color: Colors.red)),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Simulate analysis
                context.read<ScanProvider>().analyzeImage('mock/path.jpg', InputModality.woodGrain);
              },
              child: const Text('Trigger Mock Analysis'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.state == ScanState.success || provider.state == ScanState.error
                  ? () => Navigator.pushNamed(context, '/result')
                  : null,
              child: const Text('View Result'),
            ),
          ],
        ),
      ),
    );
  }
}
