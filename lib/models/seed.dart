class Seed {
  final String id;
  final String name;
  final String farmingarea;
  final String farmingtype;
  final double percentage;
  final double price;
  final String supplier;
  final String status;
  final int stock;
  final String image;

  Seed({
    required this.id,
    required this.name,
    required this.farmingarea,
    required this.farmingtype,
    required this.percentage,
    required this.price,
    required this.supplier,
    required this.status,
    required this.stock,
    required this.image,
  });

  String get getId => id;
  String get getName => name;
  String get getFarmingarea => farmingarea;
  String get getFarmingtype => farmingtype;
  double  get getPercentage => percentage;
  double get getPrice => price;
  String get getSupplier => supplier;
  String get getStatus => status;
  int get getStock => stock;
  String get getImage => image;

  // Converts Seed object to a Map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'farmingarea': farmingarea,
      'farmingtype': farmingtype,
      'percentage': percentage,
      'price': price,
      'supplier': supplier,
      'status': status,
      'stock': stock,
      'image': image,
    };
  }

  // Creates a Seed object from a Firestore document (Map)
  factory Seed.fromMap(Map<String, dynamic> map) {
    return Seed(
      id: map['id'] as String,
      name: map['name'] as String,
      farmingarea: map['farmingarea'] as String,
      farmingtype: map['farmingtype'] as String,
      percentage: map['percentage'] as double,
      price: map['price'] as double,
      supplier: map['supplier'] as String,
      status: map['status'] as String,
      stock: map['stock'] as int,
      image: map['image'] as String,
    );
  }
}
