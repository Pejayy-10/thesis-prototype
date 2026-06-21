import 'package:flutter/material.dart';
import '../core/theme/theme.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WoodConNet Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Scans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s16),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey),
                    SizedBox(height: AppSpacing.s16),
                    Text('No recent scans found.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'New Scan',
                icon: Icons.camera_alt,
                onPressed: () => Navigator.pushNamed(context, '/capture'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
