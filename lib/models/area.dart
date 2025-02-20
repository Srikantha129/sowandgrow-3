class Area {
  final String name;
  final String? id;

  Area({
    required this.name,
    this.id,
  });

  String get getName => name;
  String? get getId => id;
}
