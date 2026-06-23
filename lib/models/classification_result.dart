class AlternativeMatch {
  final String name;
  final int confidence;
  final String imagePath;

  const AlternativeMatch({
    required this.name,
    required this.confidence,
    required this.imagePath,
  });
}

class WoodProperties {
  final String strengthGrade;
  final String durabilityClass;
  final String workability;

  const WoodProperties({
    required this.strengthGrade,
    required this.durabilityClass,
    required this.workability,
  });
}

class ProtectionInfo {
  final String denrClassification;
  final String citesAppendix;
  final String localName;
  final bool permitRequired;

  const ProtectionInfo({
    required this.denrClassification,
    required this.citesAppendix,
    required this.localName,
    required this.permitRequired,
  });
}

class MaturityInfo {
  final String status; // MATURE, SAPLING, SEEDLING
  final String description;
  final String minHarvestAge;
  final String requiredDbh;
  final int growthStage; // 0=Seedling, 1=Sapling, 2=YoungAdult, 3=Mature
  final WoodProperties woodProperties;

  const MaturityInfo({
    required this.status,
    required this.description,
    required this.minHarvestAge,
    required this.requiredDbh,
    required this.growthStage,
    required this.woodProperties,
  });
}

class ClassificationResult {
  final String commonName;
  final String scientificName;
  final int confidence;
  final String family;
  final String origin;
  final String woodType;
  final String sampleType; // LEAF SAMPLE, BARK SAMPLE, etc.
  final bool isProtected;
  final List<AlternativeMatch> alternatives;
  final MaturityInfo maturityInfo;
  final ProtectionInfo protectionInfo;

  const ClassificationResult({
    required this.commonName,
    required this.scientificName,
    required this.confidence,
    required this.family,
    required this.origin,
    required this.woodType,
    required this.sampleType,
    required this.isProtected,
    required this.alternatives,
    required this.maturityInfo,
    required this.protectionInfo,
  });
}

// ── Mock Data ──────────────────────────────────────────────
class MockResults {
  static const narra = ClassificationResult(
    commonName: 'Narra',
    scientificName: 'Pterocarpus indicus',
    confidence: 94,
    family: 'Fabaceae',
    origin: 'Philippines',
    woodType: 'Hardwood',
    sampleType: 'LEAF SAMPLE',
    isProtected: true,
    alternatives: [
      AlternativeMatch(name: 'Mahogany', confidence: 82, imagePath: ''),
      AlternativeMatch(name: 'Teak', confidence: 76, imagePath: ''),
      AlternativeMatch(name: 'Molave', confidence: 61, imagePath: ''),
    ],
    maturityInfo: MaturityInfo(
      status: 'MATURE',
      description:
          'This specimen has reached optimal structural density for high-grade timber applications.',
      minHarvestAge: '25-30 yrs',
      requiredDbh: '≥ 30 cm',
      growthStage: 3,
      woodProperties: WoodProperties(
        strengthGrade: 'D40 (High)',
        durabilityClass: 'Class 2 (Durable)',
        workability: 'Excellent',
      ),
    ),
    protectionInfo: ProtectionInfo(
      denrClassification: 'Critically Endangered',
      citesAppendix: 'Appendix II',
      localName: 'Narra / Agos',
      permitRequired: true,
    ),
  );

  static const molave = ClassificationResult(
    commonName: 'Molave',
    scientificName: 'Vitex parviflora',
    confidence: 88,
    family: 'Lamiaceae',
    origin: 'Philippines',
    woodType: 'Hardwood',
    sampleType: 'BARK SAMPLE',
    isProtected: false,
    alternatives: [
      AlternativeMatch(name: 'Ipil', confidence: 74, imagePath: ''),
      AlternativeMatch(name: 'Apitong', confidence: 68, imagePath: ''),
      AlternativeMatch(name: 'Lauan', confidence: 55, imagePath: ''),
    ],
    maturityInfo: MaturityInfo(
      status: 'MATURE',
      description:
          'This specimen has achieved full structural maturity suitable for heavy construction use.',
      minHarvestAge: '30-40 yrs',
      requiredDbh: '≥ 35 cm',
      growthStage: 3,
      woodProperties: WoodProperties(
        strengthGrade: 'D60 (Very High)',
        durabilityClass: 'Class 1 (Very Durable)',
        workability: 'Moderate',
      ),
    ),
    protectionInfo: ProtectionInfo(
      denrClassification: 'Vulnerable',
      citesAppendix: 'Not Listed',
      localName: 'Molave / Tugas',
      permitRequired: true,
    ),
  );
}
