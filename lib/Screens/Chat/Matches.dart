import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Chat/chatPage.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/utls.dart';

class Matches extends StatelessWidget {
  final User currentUser;
  final AppController appController = Get.find<AppController>();

  Matches(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: Obx(() {
      final matches = appController.newMatches; // Use reactive matches list

      // Debug print to check matches data
      print('Matches count: ${matches.length}');
      matches.forEach((match) {
        print('Match: ${match.id}, People count: ${match.people?.length ?? 0}');
      });

      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    el.tr('New Matches'),
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (matches.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        matches.length < 10 ? '${matches.length}' : '10+',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).paddingOnly(left: 6),
                ],
              ),
              GestureDetector(
                child: Icon(
                  Icons.more_horiz,
                ),
                onTap: () {},
              ),
            ],
          ).paddingOnly(left: 14, right: 14),
          Container(
              height: 100,
              child: matches.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: matches.length,
                      itemBuilder: (BuildContext context, int index) {
                        final people = matches[index].people;

                        // if (people.length <= 1) {
                        //   return const SizedBox(); // Skip this item if there's no second person
                        // }

                        if (people == null || people.length < 2)
                          return const SizedBox();


                        final secondPerson = people.firstWhere(
                              (user) => user.id != currentUser.id,
                          orElse: () =>
                          people[1], // fallback to first if logic fails
                        );
                        print(
                            'Second person in match $index: ${secondPerson.name} (${secondPerson.id})');

                        final imageUrlList = secondPerson.imageUrl;
                        final secondPersonNameList = secondPerson.name;
                        final hasImage =
                            imageUrlList != null && imageUrlList.isNotEmpty;

                        print(
                            "___${hasImage ? imageUrl(imageUrlList[0]) : 'No image'}");
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ChatPage(
                                sender: currentUser,
                                second: matches[index].people[1],
                                room: matches[index],
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: secondryColor,
                                radius: 30.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: CachedNetworkImage(
                                    imageUrl: hasImage
                                        ? imageUrl(imageUrlList[0]) ?? ''
                                        : '',
                                    useOldImageOnUrlChange: true,
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                getEllipsisText(secondPersonNameList ?? "",
                                    maxLength: 10),
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ).paddingOnly(top: 10, right: 10, left: 10),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      el.tr("No match found"),
                      style: TextStyle(color: secondryColor, fontSize: 16),
                    ))),
        ],
      ).paddingOnly(top: 20);
    }));
  }
}

var groupChatId;
