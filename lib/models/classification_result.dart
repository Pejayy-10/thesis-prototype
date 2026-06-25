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
  final String status;
  final String description;
  final String minHarvestAge;
  final String requiredDbh;
  final int growthStage;
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

// ── NEW: Construction Recommendation Data ──────────────────

class ConstructionUse {
  final String application;   // e.g. "Structural Beams"
  final String suitability;   // "Highly Suitable" / "Suitable" / "Not Recommended"
  final int suitabilityLevel; // 3=High, 2=Moderate, 1=Low, 0=Not Recommended
  final String reason;

  const ConstructionUse({
    required this.application,
    required this.suitability,
    required this.suitabilityLevel,
    required this.reason,
  });
}

class ConstructionRecommendation {
  final String overallRating;       // "HIGHLY RECOMMENDED" / "RECOMMENDED" / "LIMITED USE" / "NOT RECOMMENDED"
  final int overallScore;           // 0–100
  final String overallRationale;
  final List<ConstructionUse> uses;
  final List<String> pros;
  final List<String> limitations;
  final String procurementNote;

  const ConstructionRecommendation({
    required this.overallRating,
    required this.overallScore,
    required this.overallRationale,
    required this.uses,
    required this.pros,
    required this.limitations,
    required this.procurementNote,
  });
}

// ── Main Result Model ──────────────────────────────────────

class ClassificationResult {
  final String commonName;
  final String scientificName;
  final int confidence;
  final String family;
  final String origin;
  final String woodType;
  final String sampleType;
  final bool isProtected;
  final List<AlternativeMatch> alternatives;
  final MaturityInfo maturityInfo;
  final ProtectionInfo protectionInfo;
  final ConstructionRecommendation constructionRecommendation; // NEW

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
    required this.constructionRecommendation,
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
    constructionRecommendation: ConstructionRecommendation(
      overallRating: 'RECOMMENDED',
      overallScore: 78,
      overallRationale:
          'Narra is structurally sound with high strength and excellent workability. However, its Critically Endangered status and permit requirements limit procurement feasibility for general construction.',
      uses: [
        ConstructionUse(
          application: 'Interior Finishing',
          suitability: 'Highly Suitable',
          suitabilityLevel: 3,
          reason: 'Excellent workability and fine grain make it ideal for flooring, paneling, and cabinetry.',
        ),
        ConstructionUse(
          application: 'Structural Beams',
          suitability: 'Suitable',
          suitabilityLevel: 2,
          reason: 'D40 strength grade supports medium-load beams. Verify DENR permit before procurement.',
        ),
        ConstructionUse(
          application: 'Roof Framing',
          suitability: 'Suitable',
          suitabilityLevel: 2,
          reason: 'Adequate for light-to-medium roof loads. Durability Class 2 provides weather resistance.',
        ),
        ConstructionUse(
          application: 'Outdoor Decking',
          suitability: 'Limited Use',
          suitabilityLevel: 1,
          reason: 'Class 2 durability is sufficient but protected status makes sourcing difficult.',
        ),
        ConstructionUse(
          application: 'Foundation Posts',
          suitability: 'Not Recommended',
          suitabilityLevel: 0,
          reason: 'D40 grade is below the D60 threshold recommended for foundation applications.',
        ),
      ],
      pros: [
        'Excellent workability — easy to cut and finish',
        'Fine, attractive grain suitable for visible surfaces',
        'Good natural durability (Class 2)',
        'High market value and wide local familiarity',
      ],
      limitations: [
        'Critically Endangered — requires DENR permit',
        'D40 strength grade limits heavy structural use',
        'Limited availability due to protected status',
        'Higher cost compared to non-protected species',
      ],
      procurementNote:
          'A valid DENR permit is required before cutting or transporting Narra. Contact DENR Regional Office IX or a licensed timber dealer. Alternatively, consider plantation-grown Narra or substitute with Apitong for structural applications.',
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
    constructionRecommendation: ConstructionRecommendation(
      overallRating: 'HIGHLY RECOMMENDED',
      overallScore: 91,
      overallRationale:
          'Molave is one of the strongest and most durable Philippine native timbers. Its D60 strength grade and Class 1 durability make it suitable for the most demanding structural applications.',
      uses: [
        ConstructionUse(
          application: 'Foundation Posts',
          suitability: 'Highly Suitable',
          suitabilityLevel: 3,
          reason: 'D60 grade and Class 1 durability exceed minimum requirements for foundation use.',
        ),
        ConstructionUse(
          application: 'Structural Beams',
          suitability: 'Highly Suitable',
          suitabilityLevel: 3,
          reason: 'Very high strength grade supports heavy loads. Recommended for main structural members.',
        ),
        ConstructionUse(
          application: 'Roof Framing',
          suitability: 'Highly Suitable',
          suitabilityLevel: 3,
          reason: 'Excellent load-bearing capacity with natural resistance to decay and insects.',
        ),
        ConstructionUse(
          application: 'Outdoor Decking',
          suitability: 'Highly Suitable',
          suitabilityLevel: 3,
          reason: 'Class 1 durability provides outstanding resistance to weathering and moisture.',
        ),
        ConstructionUse(
          application: 'Interior Finishing',
          suitability: 'Suitable',
          suitabilityLevel: 2,
          reason: 'Suitable but moderate workability requires skilled labor. Best used for structural elements.',
        ),
      ],
      pros: [
        'Highest strength grade (D60) among target species',
        'Class 1 durability — very resistant to decay and insects',
        'Excellent for heavy structural and outdoor applications',
        'Long service life — reduces long-term maintenance cost',
      ],
      limitations: [
        'Moderate workability — requires skilled carpentry',
        'Vulnerable species — DENR permit required',
        'Longer harvest cycle (30–40 years) limits supply',
        'Heavier weight increases handling and transport cost',
      ],
      procurementNote:
          'A DENR permit is required for harvesting. Molave from certified community-based forest management areas may be available through DENR Regional Office IX. Verify timber legality documentation (TLA/CADT) before purchase.',
    ),
  );
}
