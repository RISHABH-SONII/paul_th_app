// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:tharkyApp/components/mapc/sheets/unsupported_place.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/res/global_worker.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeController extends GetxController {
  // Map and UI controllers
  final mapController = MapController();
  final sheetController = PanelController();
  late final StreamSubscription<MapEvent> mapEventSubscription;

  // Observables
  final latLng = LatLng(0, 0).obs;
  final proposedPlaces = {"address": " ", "formatedAddress": ""}.obs;
  final isReversing = false.obs;
  final loading = false.obs;
  final crossSwitcher = YEnumerate.NearestPlace.obs;
  final sheetBusiness = 0.obs;
  final currentLocation = LocationData.fromMap({}).obs;
  final sheetIsDraggable = true.obs;

  dynamic context;

  // Dimensions and constants
  final pointSize = const Size(56, 110);
  final Location _locationService = Location();
  double panelHeightClosed = 38, panelHeightOpen = 250;
  bool locationPermission = false;

  late final StreamController<double?> centerCurrentLocationStreamController;

  final _canTimers = [
    Timer(Duration.zero, () {}),
    Timer(Duration.zero, () {}),
  ];

  @override
  void onInit() {
    super.onInit();
    centerCurrentLocationStreamController = StreamController<double?>();

    // Listen to map events
    mapEventSubscription = mapController.mapEventStream.listen((mapEvent) {
      onMapEvent(mapEvent, context as BuildContext);
      _updatePointLatLng(context);
    });

    // Initialize location service with a delay
    Timer(const Duration(seconds: 3), initLocationService);
  }

  Future<void> initLocationService() async {
    try {
      final serviceEnabled = await _locationService.serviceEnabled();
      locationPermission =
          await _locationService.hasPermission() == PermissionStatus.granted;

      // Request service and permissions if needed
      if (!serviceEnabled && !(await _locationService.requestService())) {
        throw 'SERVICE_DISABLED';
      }

      if (!locationPermission &&
          (await _locationService.requestPermission()) !=
              PermissionStatus.granted) {
        throw 'PERMISSION_DENIED';
      }

      await _locationService.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
      );

      currentLocation.value = await _locationService.getLocation();
      findMeOnce();
    } catch (e) {
      if (e == 'PERMISSION_DENIED') {
        show_common_toast("Location permission denied", context);
      } else {
        my_print_err("Error in location service: $e");
      }
    }
  }

  void toggleNearestSheet() {
    crossSwitcher.value = YEnumerate.NearestPlace;
    sheetController.animatePanelToPosition(0,
        duration: const Duration(milliseconds: 750), curve: Curves.ease);
  }

  void findMeOnce() {
    mapController.move(
      LatLng(currentLocation.value.latitude ?? 1,
          currentLocation.value.longitude ?? 1),
      30,
    );
  }

  void onMapEvent(MapEvent mapEvent, BuildContext context) {
    if (mapEvent is MapEventMoveEnd) {
      _updatePointLatLng(context);
    } else if (mapEvent is MapEventMoveStart) {
      isReversing.value = false;
      _canTimers[0].cancel();
      sheetIsDraggable.value = false;
      sheetController.close();
    }
  }

  void _updatePointLatLng(BuildContext context) {
    final pointX = getPointX(context, "");
    final pointY = getPointY(context, "");

    final currentLatLng =
        mapController.pointToLatLng(CustomPoint(pointX, pointY));
    latLng.value = currentLatLng!;
    sheetIsDraggable.value = true;

    _canTimers[0].cancel();
    _canTimers[0] = Timer(const Duration(milliseconds: 1050), () async {
      my_print(
          'Pointed location: (${latLng.value.latitude.toStringAsPrecision(4)}, ${latLng.value.longitude.toStringAsPrecision(4)})');

      proposedPlaces['lon'] = "${latLng.value.longitude}";
      proposedPlaces['lat'] = "${latLng.value.latitude}";

      isReversing.value = true;

      try {
        final value = await reverseplace({
          "lat": latLng.value.latitude,
          "lon": latLng.value.longitude,
        });

        isReversing.value = false;

        // Update proposed places
        proposedPlaces['address'] = value.data["address"];
        proposedPlaces['formatedAddress'] = value.data["formatedAddress"];

        sheetController.open().whenComplete(() {
          isReversing.value = false;
          _canTimers[0].cancel();
          sheetIsDraggable.value = false;
        });
      } catch (e) {
        my_print_err("Reverse geocoding error: $e");
        YGWorker.homeScaffoldKey.currentState
            ?.showBottomSheet(
                (context) => UnsupportedPleceSheet(onModify: () {}))
            .closed
            .whenComplete(() => my_print("Sheet closed."));
      }
    });
  }

  double getPointX(BuildContext context, String to) {
    return MediaQuery.of(context).size.width / 2 -
        (to == "screen" ? pointSize.width / 2 : 0);
  }

  double getPointY(BuildContext context, String to) {
    return MediaQuery.of(context).size.height / 2 -
        (to == "screen" ? 50 + pointSize.height / 2 : 0);
  }

  @override
  void dispose() {
    mapEventSubscription.cancel();
    centerCurrentLocationStreamController.close();
    super.dispose();
  }
}
