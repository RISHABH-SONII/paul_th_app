import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tharkyApp/components/mapc/autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:location/location.dart' as loc;
import 'package:easy_localization/easy_localization.dart';
import 'package:geocoding/geocoding.dart';

class UpdateLocation extends StatefulWidget {
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  Map? _newAddress;

  @override
  void initState() {
    getLocationCoordinates().then((updateAddress) {
      setState(() {
        _newAddress = updateAddress!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: blackColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Text(
            "Use current location".tr().toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _newAddress != null
                ? _newAddress!['PlaceName'] ?? 'Fetching..'.tr().toString()
                : 'Unable to load...'.tr().toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: Icon(
            Icons.location_searching_rounded,
            color: Colors.white,
          ),
          onTap: () async {
            if (_newAddress == null) {
              await getLocationCoordinates().then((updateAddress) {
                print(updateAddress);
                setState(() {
                  _newAddress = updateAddress!;
                });
              });
            } else {
              Navigator.pop(context, _newAddress);
            }
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .6,
        child: MapBoxAutoCompleteWidget(
          language: 'en',
          closeOnSelect: false,
          limit: 10,
          hint: 'Enter your city name'.tr().toString(),
          onSelect: (place) {
            Map obj = {};
            obj['address'] = place.placeName;
            obj['latitude'] = place.lat;
            obj['longitude'] = place.lon;
            Navigator.pop(context, obj);
          },
        ).paddingAll(20),
      ),
    );
  }
}

Future<Map?> getLocationCoordinates() async {
  loc.Location location = loc.Location();
  try {
    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }
    }

    // Get the location
    final coordinates = await location.getLocation();
    return await coordinatesToAddress(
      latitude: coordinates.latitude!,
      longitude: coordinates.longitude!,
    );
  } catch (e) {
    if (e is PlatformException) {
      loc.PermissionStatus permissionGranted = await location.hasPermission();

      if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        await openAppSettings(); // Requires permission_handler package
        throw Exception("Permission denied forever. Redirected to settings.");
      } else if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          throw Exception("Location permission denied.");
        }
      }
    }

    return null;
  }
}

Future<Map<String, dynamic>> coordinatesToAddress(
    {required double latitude, required double longitude}) async {
  Map<String, dynamic> obj = {};
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks.first;

    String currentAddress =
        "${place.locality ?? ''} ${place.subLocality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}, ${place.postalCode ?? ''}";

    print(currentAddress);
    obj['PlaceName'] = currentAddress;
    obj['latitude'] = latitude;
    obj['longitude'] = longitude;

    return obj;
  } catch (e) {
    obj['PlaceName'] = "Roar city";
    obj['latitude'] = latitude;
    obj['longitude'] = longitude;

    return obj;
  }
}
