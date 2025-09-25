import 'package:flutter/material.dart';

const PlaceIconMap = {
  "school": Icons.school,
  "market": Icons.storefront,
  "sport": Icons.sports_soccer,
  "station": Icons.train,
  "airport": Icons.connecting_airports,
  "place_of_worship": Icons.church,
  "default": Icons.trip_origin,
};

IconData getPlaceIcon(String icon) {
  if (PlaceIconMap[icon] == null) return PlaceIconMap["default"]!;
  return PlaceIconMap[icon]!;
}
