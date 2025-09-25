/*
        ///Commented by Shubham
// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:get/get_connect.dart';
import 'package:latlong2/latlong.dart';
import 'package:yambro/Helpers/utls.dart';
import 'package:yambro/models/place_icons.dart';
import 'package:http/http.dart' as http;
import 'package:yambro/res/neter.dart';
import 'package:yambro/res/globals.dart';

import '../models/proposed_place.dart';

class Fetcher extends GetConnect {
  static final faker = Faker.withGenerator(RandomGenerator(seed: 63833423));
  static final baseurl = "${YNeter["uri3"]}";
  Fetcher() {
    httpClient.baseUrl = "${YNeter["uri3"]}";
    allowAutoSignedCert = true;
  }

  Future<dynamic> GetPlaceName(LatLng latLng) async {
    List<ProposedPlace> places = [];
    var response =
        await http.get(Uri.https(baseurl, '/yamapi/royal/map/reverse', {
      'lat': "${latLng.latitude}",
      'lon': "${latLng.longitude}",
      'addressdetails': "0",
      'extratags': "0",
      'namedetails': "0",
      'email': "${YGlobals["app_mail"]}",
    }));
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }

  Future<dynamic> GetProposedPlace(LatLng latLng) async {
    List<ProposedPlace> places = [];

    // var response = await http
    //     .get(Uri.https("${YGlobals["nominatim"]["api_url"]}", '/reverse', {
    //   'lat': "${latLng.latitude}",
    //   'lon': "${latLng.longitude}",
    //   'addressdetails': "0",
    //   'extratags': "0",
    //   'namedetails': "0",
    //   'email': "${YGlobals["app_mail"]}",
    //   'format': 'json',
    // }));

    // var jsonData = jsonDecode(response.body);
    // my_inspect(jsonData);

    // var usersData = jsonData["results"];

    // for (var user in usersData) {
    //   ProposedPlace newProposedPlace = ProposedPlace(
    //       user["name"]["first"] + user["name"]["last"],
    //       user["email"],
    //       user["picture"]["large"],
    //       user["phone"]);

    //   places.add(newProposedPlace);
    // }

    // return places;

    Future<dynamic> fetch() {
      var lili = [.33, .5, .66];
      return Future.delayed(
          const Duration(seconds: 2),
          () => [
                ProposedPlace(
                    place_id: 1,
                    localname: faker.address.streetName(),
                    longitute: my_DoubleRandom(-180, 180),
                    latitude: my_DoubleRandom(-90, 90),
                    persistance: lili[0],
                    icon: ''),
                ProposedPlace(
                    place_id: 1,
                    localname: faker.address.streetName(),
                    longitute: my_DoubleRandom(-180, 180),
                    latitude: my_DoubleRandom(-90, 90),
                    persistance: lili[0],
                    icon: ''),
                ProposedPlace(
                    place_id: 1,
                    localname: faker.address.streetName(),
                    longitute: my_DoubleRandom(-180, 180),
                    latitude: my_DoubleRandom(-90, 90),
                    persistance: lili[0],
                    icon: ''),
                ProposedPlace(
                    place_id: 1,
                    localname: faker.address.streetName(),
                    longitute: my_DoubleRandom(-180, 180),
                    latitude: my_DoubleRandom(-90, 90),
                    persistance: lili[1],
                    icon: ''),
                ProposedPlace(
                    place_id: 1,
                    localname: faker.address.streetName(),
                    longitute: my_DoubleRandom(-180, 180),
                    latitude: my_DoubleRandom(-90, 90),
                    persistance: lili[1],
                    icon: ''),
              ]);
    }

    var result = await fetch();
    return result;
  }

  static Future<dynamic> getSearchedPlaces(dynamic q) async {
    //6.376721066094644,2.40741279579169

    Future<dynamic> fetch() {
      final lili = [.33, .5, .66];

      final random = Random();

      return Future.delayed(
          const Duration(seconds: 3),
          () => List.generate(
              30,
              (i) => ProposedPlace(
                  place_id: 1,
                  localname: faker.address.streetName(),
                  longitute: my_DoubleRandom(-180, 180),
                  latitude: my_DoubleRandom(-90, 90),
                  persistance: lili[0],
                  areaName: faker.address.streetAddress(),
                  icon: PlaceIconMap.keys
                      .toList()[random.nextInt(PlaceIconMap.keys.length)])));
    }

    var result = await fetch();
    return result;
  }
}
*/
