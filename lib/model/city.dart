class City {
  // Properties
  final String id;
  final String name;

  // Constructor
  City(this.id, this.name);

  // Getters
  String get getId => id;
  String get getName => name;

  // toString() for displaying in a spinner
  @override
  String toString() {
    return name;
  }

  // equals() for object comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City &&
           other.id == id &&
           other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_name': name,
    };
  }


  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      map['id'],
      map['city_name'],
    );
  }
}
