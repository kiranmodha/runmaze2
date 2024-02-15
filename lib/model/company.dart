class Company {
  // Properties
  final String id;
  final String name;

  // Constructor
  Company(this.id, this.name);

  // Getters
  String get getId => id;
  String get getName => name;

  // toString() for displaying in a spinner
  @override
  String toString() => name;

  // equals() for object comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_name': name,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      map['id'],
      map['company_name'],
    );
  }
}
