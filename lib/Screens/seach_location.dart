import 'package:flutter/material.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/components/mapc/autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:tharkyApp/utils/colors.dart';

import 'AllowLocation.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchLocation extends StatefulWidget {
  final Map<String, dynamic> userData;

  SearchLocation(this.userData);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late MapBoxPlace _mapBoxPlace = MapBoxPlace(
    id: "dede",
    placeName: "toronto, Canada",
    lon: "1.225454151",
    lat: "2.564545",
  );

  TextEditingController _city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: BackWidgetuser(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Padding(
                  child: Text(
                    "Select\nyour city".tr().toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  padding: EdgeInsets.only(left: 50, top: 120),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        autofocus: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Enter your city name".tr().toString(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          helperText: "This is how it will appear in App."
                              .tr()
                              .toString(),
                          helperStyle:
                              TextStyle(color: secondryColor, fontSize: 15),
                        ),
                        controller: _city,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapBoxAutoCompleteWidget(
                                language: 'en',
                                closeOnSelect: true,
                                city: "mapboxApi",
                                limit: 10,
                                hint: 'Enter your city name'.tr().toString(),
                                onSelect: (place) {
                                  setState(() {
                                    _mapBoxPlace = place;
                                    _city.text = _mapBoxPlace.placeName!;
                                  });
                                },
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    primaryColor.withOpacity(.5),
                                    primaryColor.withOpacity(.8),
                                    primaryColor,
                                    primaryColor
                                  ])),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "Continue".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () async {
                        // Ajout des données par défaut si aucune ville n'est sélectionnée
                        if (_city.text.isEmpty) {
                          _city.text = _mapBoxPlace.placeName!;
                        }

                        widget.userData.addAll(
                          {
                            'coordinates': {
                              'latitude': _mapBoxPlace.lat,
                              'longitude': _mapBoxPlace.lon,
                              'address': "${_mapBoxPlace.placeName}"
                            },
                            'maxDistance': 20,
                            'ageRange': {
                              'min': "20",
                              'max': "50",
                            },
                          },
                        );
                        await setUserData(widget.userData);

                        showWelcomDialog(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
