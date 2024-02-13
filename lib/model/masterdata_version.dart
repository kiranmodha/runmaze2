class MasterDataVersion {
  // Properties
  final String masterData;
  final double versionNumber;

  // Constructor
  MasterDataVersion({
    required this.masterData,
    required this.versionNumber,
  });

  // Constructor with defaults
  factory MasterDataVersion.empty() => MasterDataVersion(
        masterData: "",
        versionNumber: 0.0,
      );

  // Getters
  String get getMasterData => masterData;
  double get getVersionNumber => versionNumber;

  // toString() method
  @override
  String toString() {
    return 'MasterDataVersion{masterData: $masterData, versionNumber: $versionNumber}';
  }
}
