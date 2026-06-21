import 'dart:math';
import '../models/scan_result.dart';

class MockInferenceService {
  final Random _random = Random();

  Future<ScanResult> analyzeImage(String imagePath, InputModality modality) async {
    // Simulate 3-second network latency
    await Future.delayed(const Duration(seconds: 3));

    // Simulate 10% error rate
    if (_random.nextDouble() < 0.1) {
      throw Exception("Network Timeout or Model Extraction Failure.");
    }

    // Hardcode 3 mock profiles
    final profiles = [
      _getRestrictedNarra(modality),
      _getApprovedSpecies(modality),
      _getLowConfidence(modality),
    ];

    // Pick a random profile for the prototype
    return profiles[_random.nextInt(profiles.length)];
  }

  ScanResult _getRestrictedNarra(InputModality modality) {
    return ScanResult(
      scanId: 'scn_${_random.nextInt(10000)}',
      timestamp: DateTime.now(),
      classification: Classification(
        commonName: 'Narra',
        scientificName: 'Pterocarpus indicus',
        confidenceScore: 0.94,
        modality: modality,
      ),
      decisionSupport: DecisionSupport(
        isRestricted: true,
        denrStatus: 'Vulnerable (VU)',
        fprdiGroup: 'Group II',
        recommendationLabel: 'CRITICAL: Restricted Species. Requires DENR clearance.',
        uiState: SupportUiState.criticalWarning,
      ),
    );
  }

  ScanResult _getApprovedSpecies(InputModality modality) {
    return ScanResult(
      scanId: 'scn_${_random.nextInt(10000)}',
      timestamp: DateTime.now(),
      classification: Classification(
        commonName: 'Mahogany',
        scientificName: 'Swietenia macrophylla',
        confidenceScore: 0.88,
        modality: modality,
      ),
      decisionSupport: DecisionSupport(
        isRestricted: false,
        denrStatus: 'Not Evaluated / Least Concern',
        fprdiGroup: 'Group III',
        recommendationLabel: 'APPROVED: Suitable for general construction.',
        uiState: SupportUiState.standardApproval,
      ),
    );
  }

  ScanResult _getLowConfidence(InputModality modality) {
    return ScanResult(
      scanId: 'scn_${_random.nextInt(10000)}',
      timestamp: DateTime.now(),
      classification: Classification(
        commonName: 'Unknown',
        scientificName: 'Unknown',
        confidenceScore: 0.35,
        modality: modality,
      ),
      decisionSupport: DecisionSupport(
        isRestricted: false,
        denrStatus: 'Unknown',
        fprdiGroup: 'Unknown',
        recommendationLabel: 'WARNING: Blurry or invalid image. Please recapture.',
        uiState: SupportUiState.requiresVerification,
      ),
    );
  }
}
