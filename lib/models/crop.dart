class Crop {
  final String name;
  final String farmingtype;
  final String? id;

  Crop({
    required this.name,
    required this.farmingtype,
    this.id,
  });

  String get getName => name;
  String get getFarmingtype => farmingtype;
  String? get getId => id;

  // Converts Crop object to a Map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'farmingtype': farmingtype,
      'id': id,
    };
  }

  // Creates a Crop object from a Firestore document (Map)
  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      name: map['name'] as String,
      farmingtype: map['farmingtype'] as String,
      id: map['id'] as String?,
    );
  }
}
