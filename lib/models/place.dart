class Place {
  final String localname;
  final String? category, type;
  final int place_id;
  final double longitute;
  final double latitude;

  Place({
    required this.localname,
    required this.place_id,
    required this.longitute,
    required this.latitude,
    this.category,
    this.type,
  });
}
