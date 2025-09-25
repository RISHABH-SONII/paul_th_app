import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/components/mapc/autocomplete/flutter_mapbox_autocomplete.dart';

import 'package:tharkyApp/res/global_worker.dart';
import 'package:tharkyApp/res/globals.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:tharkyApp/components/mapc/header_bottomsheet_push_over.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/components/mapc/markers/location.dart';
import 'package:easy_localization/easy_localization.dart' as easylo;

class MapViewHome extends GetView<HomeController> {
  const MapViewHome(this.userData, {Key? key}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    final double _initFabHeight = 120.0;
    double _fabHeight = 0;

    void _pannelSlide(double pos) {
      if (YGlobalWorker["home"]["go_to_inputs"] == true) {
        if (pos < 0.3 &&
            YGlobalWorker["home"]["sheetPosToShowInputs"] == true) {
          controller.toggleNearestSheet();

          YGlobalWorker["home"]["sheetPosToShowInputs"] = false;
        }
        if (pos == 0.0) {
          YGlobalWorker["home"]["go_to_inputs"] = false;

          controller.panelHeightClosed =
              YGlobals["nearestSheetMinHeight"] as double;

          controller.panelHeightOpen = YGlobals["nearestSheetHeight"] as double;
        }
      }

      _fabHeight =
          pos * (controller.panelHeightOpen - controller.panelHeightClosed) +
              _initFabHeight;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(() {
        controller.context = context;

        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Stack(
            children: [
              SlidingUpPanel(
                color: transparentColor,
                boxShadow: [BoxShadow(color: transparentColor)],
                controller: controller.sheetController,
                maxHeight: controller.panelHeightOpen,
                minHeight: controller.panelHeightClosed,
                isDraggable: controller.sheetIsDraggable.value,
                onPanelSlide: _pannelSlide,
                panelBuilder: (sc) {
                  return MediaQuery.removePadding(
                      context: controller.context as BuildContext,
                      removeTop: true,
                      child: HeaderBottomSheetPushOver(controller,
                          pannelScroller: sc, userData: userData));
                },
                body: Stack(
                  children: [
                    FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        center: LatLng(51.5074, -0.1278),
                        zoom: 15,
                        minZoom: 3,
                        maxZoom: 20,
                        interactiveFlags:
                            InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                        rotation: 0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=6170aad10dfd42a38d4d8c709a536f38',
                          //'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                          userAgentPackageName:
                              'dev.fleaflet.flutter_map.example',
                        )
                      ],
                    ),
                    Positioned(
                        top: controller.getPointY(context, "screen"),
                        left: controller.getPointX(context, "screen"),
                        child: LocationPicker(pointSize: controller.pointSize)),
                    BackButton()
                    ///Commented by Shubham
                    // .yellowed(color: white)
                        .marginAll(10)
                        .cornerRadiusWithClipRRect(100)
                  ],
                ),
              ), // the fab
              Positioned(
                right: 20.0,
                bottom: _fabHeight,
                child: Column(
                  children: [
                    if (!userData.containsKey("editing"))
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: FittedBox(
                          child: FloatingActionButton(
                            key: Key("1"),
                            heroTag: 'unique_tag_2',
                            backgroundColor: Colors.white,
                            mini: true,
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MapBoxAutoCompleteWidget(
                                      language: 'en',
                                      closeOnSelect: true,
                                      city: "mapboxApi",
                                      limit: 10,
                                      hint: easylo
                                          .tr('Enter your city name')
                                          .toString(),
                                      onSelect: (place) {
                                        controller.proposedPlaces[
                                                'formatedAddress'] =
                                            place.placeName!;

                                        controller.proposedPlaces['lat'] =
                                            place.lat!;

                                        controller.proposedPlaces['lon'] =
                                            place.lon!;

                                        controller.proposedPlaces['address'] =
                                            "${place.lat} ${place.lon} ";

                                        final latitude = double.tryParse(
                                            place.lat.toString());
                                        final longitude = double.tryParse(
                                            place.lon.toString());

                                        if (latitude != null &&
                                            longitude != null) {
                                          controller.mapController.move(
                                            LatLng(latitude, longitude),
                                            15, // Zoom level
                                          );
                                        } else {
                                          debugPrint(
                                              "Error: Invalid latitude or longitude.");
                                        }

                                        controller.sheetController
                                            .open()
                                            .whenComplete(() {
                                          controller.isReversing.value = false;
                                          controller.sheetIsDraggable.value =
                                              false;
                                        });
                                      },
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    7.height,
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: FittedBox(
                        child: FloatingActionButton(
                          key: Key("2"),
                          heroTag: 'unique_tag_1',
                          backgroundColor: Colors.white,
                          mini: true,
                          child: const Icon(
                            Icons.near_me_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            controller.findMeOnce();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
