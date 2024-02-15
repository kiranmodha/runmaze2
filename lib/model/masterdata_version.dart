class MasterDataVersion {
  // Properties
  final String masterData;
  final double versionNumber;

  // Constructor
  MasterDataVersion( 
      this.masterData,
      this.versionNumber, 
);

  // Constructor with defaults
  // factory MasterDataVersion.empty() => MasterDataVersion(
  //       masterData: "",
  //       versionNumber: 0.0,
  //     );

  // Getters
  String get getMasterData => masterData;
  double get getVersionNumber => versionNumber;

  // toString() method
  @override
  String toString() {
    return 'MasterDataVersion{masterData: $masterData, versionNumber: $versionNumber}';
  }

  Map<String, dynamic> toMap() {
    return {
      'master_data': masterData,
      'version_number': versionNumber,
    };
  }

  factory MasterDataVersion.fromMap(Map<String, dynamic> map) {
    return MasterDataVersion(
       map['master_data'],
       map['version_number'],
    );
  }

}
