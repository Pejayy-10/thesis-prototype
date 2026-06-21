enum InputModality { leaf, bark, trunk, woodGrain }

enum SupportUiState { criticalWarning, standardApproval, requiresVerification }

class ScanResult {
  final String scanId;
  final DateTime timestamp;
  final Classification classification;
  final DecisionSupport decisionSupport;

  ScanResult({
    required this.scanId,
    required this.timestamp,
    required this.classification,
    required this.decisionSupport,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      scanId: json['scanId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      classification: Classification.fromJson(json['classification'] as Map<String, dynamic>),
      decisionSupport: DecisionSupport.fromJson(json['decisionSupport'] as Map<String, dynamic>),
    );
  }
}

class Classification {
  final String commonName;
  final String scientificName;
  final double confidenceScore;
  final InputModality modality;

  Classification({
    required this.commonName,
    required this.scientificName,
    required this.confidenceScore,
    required this.modality,
  });

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      modality: InputModality.values.firstWhere(
        (e) => e.toString().split('.').last == json['modality'],
        orElse: () => InputModality.woodGrain,
      ),
    );
  }
}

class DecisionSupport {
  final bool isRestricted;
  final String denrStatus;
  final String fprdiGroup;
  final String recommendationLabel;
  final SupportUiState uiState;

  DecisionSupport({
    required this.isRestricted,
    required this.denrStatus,
    required this.fprdiGroup,
    required this.recommendationLabel,
    required this.uiState,
  });

  factory DecisionSupport.fromJson(Map<String, dynamic> json) {
    return DecisionSupport(
      isRestricted: json['isRestricted'] as bool,
      denrStatus: json['denrStatus'] as String,
      fprdiGroup: json['fprdiGroup'] as String,
      recommendationLabel: json['recommendationLabel'] as String,
      uiState: SupportUiState.values.firstWhere(
        (e) => e.toString().split('.').last == json['uiState'],
        orElse: () => SupportUiState.requiresVerification,
      ),
    );
  }
}
