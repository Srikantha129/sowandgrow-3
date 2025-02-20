class CropArea {
  final String crop_id;
  final String farmingarea_id;
  final String? id;

  CropArea({
    required this.crop_id,
    required this.farmingarea_id,
    this.id,
  });

  String get getCrop_id => crop_id;
  String get getFarmingarea_id => farmingarea_id;
  String? get getId => id;
}
