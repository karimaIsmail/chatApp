enum enLanguage { english, arabic }

class SettingsEntity {
  final int colorsIndex;
  final bool toggleSettings;
  final bool toggleColors;
  final bool toggleLanguage;
  final String errorMessage;

  final enLanguage language;

  SettingsEntity(
      {required this.colorsIndex,
      required this.toggleSettings,
      required this.toggleLanguage,
      required this.errorMessage,
      required this.toggleColors,
      required this.language});
  SettingsEntity copyWith(
      {int? colorsIndex,
      bool? openSettings,
      enLanguage? language,
      bool? toggleColors,
      bool? toggleLanguage,
      String? errorMessage}) {
    return SettingsEntity(
        colorsIndex: colorsIndex ?? this.colorsIndex,
        toggleSettings: openSettings ?? toggleSettings,
        language: language ?? this.language,
        toggleLanguage: toggleLanguage ?? this.toggleLanguage,
        toggleColors: toggleColors ?? this.toggleColors,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
