import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/colors.dart';

class LargeImage extends StatelessWidget {
  final largeImage;

  LargeImage(this.largeImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CachedNetworkImage(
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: largeImage ?? '',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.arrow_back,
                          color: white,
                        ),
                        onPressed: () => Navigator.pop(context)),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )));
  }
}
