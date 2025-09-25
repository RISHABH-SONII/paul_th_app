part of flutter_mapbox_autocomplete;

class Predections {
  String? type;
  List<dynamic>? query;
  List<MapBoxPlace>? features;

  Predections.prediction({
    this.type,
    this.query,
    this.features,
  });

  Predections.empty() {
    this.type = '';
    this.features = [];
    this.query = [];
  }

  String toRawJson() => json.encode(toJson());

  factory Predections.fromJson(Map<String, dynamic> json) {
    return Predections.prediction(
      type: '',
      query: [],
      features: List<MapBoxPlace>.from(
        json["places"].map((x) => MapBoxPlace.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query!.map((x) => x)),
        "features": List<dynamic>.from(
          features!.map((x) => x.toJson()),
        ),
      };
}

class MapBoxPlace {
  String? id;
  String? placeName;
  String? lon;
  String? lat;

  MapBoxPlace({
    this.id,
    this.lat,
    this.placeName,
    this.lon,
  });

  factory MapBoxPlace.fromRawJson(String str) =>
      MapBoxPlace.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MapBoxPlace.fromJson(Map<String, dynamic> json) => MapBoxPlace(
        id: json["id"] == null ? null : "${json["id"]}",
        placeName: json["name"] == null ? null : json["name"],
        lon: json["lon"] == null ? null : "${json["lon"]}",
        lat: json["lat"] == null ? null : "${json["lat"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "place_name": placeName,
      };
}
