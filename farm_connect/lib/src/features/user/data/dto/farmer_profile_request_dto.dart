class FarmerProfileRequestDto {
  final String? farmType;
  final String? landSize;
  final String? farmingCategory;
  final List<String> seasonalHiringPreferences;

  const FarmerProfileRequestDto({
    this.farmType,
    this.landSize,
    this.farmingCategory,
    required this.seasonalHiringPreferences,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (_hasValue(farmType)) 'farmType': farmType,
      if (_hasValue(landSize)) 'landSize': landSize,
      if (_hasValue(farmingCategory)) 'farmingCategory': farmingCategory,
      'seasonalHiringPreferences': seasonalHiringPreferences,
    };
  }
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
