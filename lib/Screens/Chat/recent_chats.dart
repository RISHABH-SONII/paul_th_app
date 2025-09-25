import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Chat/Matches.dart';
import 'package:tharkyApp/Screens/Chat/chatPage.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/utls.dart';

class RecentChats extends StatelessWidget {
  final User currentUser;
  final AppController appController = Get.find<AppController>();

  RecentChats(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final matches = appController.matches;
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
              ),
              child: ListView(
                  physics: ScrollPhysics(),
                  children: matches.map((index) {
                    var lastAuthor = index.lastAuthor,
                        lastMessage = index.lastMessage,
                        theOther = index.people
                            .firstWhere((u) => u.iid != currentUser.iid);

                    var istyping = appController.typinrooms.contains(index.id);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => ChatPage(
                            sender: currentUser,
                            second: theOther,
                            room: index,
                          ),
                        ),
                      ),
                      child: index.isGroup!
                          ? Container()
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: secondryColor,
                                        radius: 30.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child: (theOther
                                              .imageUrl?.isNotEmpty ??
                                              false)
                                              ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: imageUrl(
                                                    theOther.imageUrl![0]) ??
                                                '',
                                            useOldImageOnUrlChange: true,
                                            placeholder: (context, url) =>
                                                loadingImage(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    errorImage(),
                                          )
                                              : Icon(Icons.person, size: 30),
                                        ),
                                      ),
                                      Positioned(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(90)),
                                          child: SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: appController
                                                          .onlineUsers
                                                          .any((element) =>
                                                              element.id ==
                                                              theOther.iid)
                                                      ? greenColor
                                                      : grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          90)),
                                              child: SizedBox(
                                                height: 10,
                                                width: 10,
                                              ),
                                            ),
                                          ).paddingAll(5),
                                        ),
                                        right: 0,
                                        bottom: 0,
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                theOther.name!,
                                                style: TextStyle(
                                                  color: lastAuthor !=
                                                              currentUser.iid &&
                                                          !lastMessage!.isRead!
                                                      ? primaryColor
                                                      : blackColor,
                                                  fontSize: 16.0,
                                                  fontWeight: lastAuthor !=
                                                              currentUser.iid &&
                                                          !lastMessage!.isRead!
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            if (lastMessage?.createdAt != null)
                                              Text(
                                                getmesssageDate(
                                                    lastMessage?.createdAt),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.0,
                                                  fontWeight: lastAuthor !=
                                                              currentUser.iid &&
                                                          !lastMessage!.isRead!
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 4.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                istyping
                                                    ? "Typing..."
                                                    : lastMessage?.type ==
                                                            "image"
                                                        ? "📷 Photo"
                                                        : lastMessage
                                                                ?.content ??
                                                            "",
                                                style: TextStyle(
                                                  color: istyping
                                                      ? greenColor
                                                      : Colors.blueGrey,
                                                  fontSize: 14.0,
                                                  fontWeight: lastAuthor !=
                                                              currentUser.iid &&
                                                          !lastMessage!.isRead!
                                                      ? FontWeight.bold
                                                      : FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            if (lastAuthor == currentUser.iid)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Icon(
                                                  lastMessage?.isRead ?? false
                                                      ? Icons.done_all
                                                      : Icons.done,
                                                  color: lastMessage?.isRead ??
                                                          false
                                                      ? primaryColor
                                                      : secondryColor,
                                                  size: 18,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  }).toList()),
            )).paddingTop(10);
      }),
    );
  }
}
