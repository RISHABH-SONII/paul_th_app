import 'package:tharkyApp/models/place.dart';

class ProposedPlace extends Place {
  double persistance;
  String icon;
  String? areaName;

  ProposedPlace({
    required int place_id,
    required String localname,
    String? category,
    String? type,
    required double longitute,
    required double latitude,
    required this.persistance,
    required this.icon,
    this.areaName,
  }) : super(
            place_id: place_id,
            localname: localname,
            category: category,
            type: type,
            longitute: longitute,
            latitude: latitude);
}
