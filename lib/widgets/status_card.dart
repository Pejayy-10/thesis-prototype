import 'package:flutter/material.dart';
import '../core/theme/theme.dart';
import '../data/models/scan_result.dart';

class StatusCard extends StatelessWidget {
  final SupportUiState uiState;
  final String title;
  final String description;

  const StatusCard({
    super.key,
    required this.uiState,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = uiState == SupportUiState.criticalWarning;
    final backgroundColor = isCritical ? AppColors.signalCritical : AppColors.signalApprove;
    final iconData = isCritical ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        border: Border.all(color: backgroundColor, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, color: backgroundColor, size: 32),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
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
