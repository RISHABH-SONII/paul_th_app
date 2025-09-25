import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as pathd;
import 'package:permission_handler/permission_handler.dart';
import 'package:tharkyApp/Screens/Information.dart';
import 'package:tharkyApp/Screens/Payment/build_transection_json.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormScreen.dart';
import 'package:tharkyApp/Screens/reportUser.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/components/copole2.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/network_utils.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/snackbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Calling/dial.dart';

class ChatPage extends StatefulWidget {
  final User sender;
  final User second;
  final Room? room;

  ChatPage({required this.sender, required this.second, this.room});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isBlocked = false;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppController appController = Get.find<AppController>();
  File f_conten = File('');

  // Ads _ads = new Ads();

  @override
  void initState() {
    super.initState();
    print("INIT");
    createroom();
    checkblock();
  }

  @override
  void dispose() {
    super.dispose();
    appController.messages.clear();
    appController.room.value = null;
  }

  createroom() async {
    print("Creating/loading room between:");
    print("User 1: ${widget.sender.iid} (${widget.sender.name})");
    print("User 2: ${widget.second.iid} (${widget.second.name})");
    appController.messages.clear();
    var req = {"counterpart": widget.second.iid};
    if (widget.room != null) {
      appController.room.value = widget.room;
      if (widget.room!.lastMessage != null) {
        appController.messages.value = [widget.room!.lastMessage!];
      }
      appController.getMessages();
      appController.readmessage();
    } else {
      createRoom(req).then((res) async {
        if (res.room != null) {
          appController.room.value = res.room;
          appController.getMessages();
          appController.readmessage();
        }
      });
    }
  }

  var blockedBy;

  checkblock() {
    // chatReference.doc('blocked').snapshots().listen((onData) {
    //   if (true) {
    //     // (onData.data != null) {
    //     blockedBy = onData.get('blockedBy');
    //     if (onData.get('isBlocked')) {
    //       isBlocked = true;
    //     } else {
    //       isBlocked = false;
    //     }
    //     if (mounted) setState(() {});
    //   }
    //   // print(onData.data['blockedBy']);
    // });
  }

  generateMessages(List<Message> snapshot) {
    return snapshot.map<Widget>((doc) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: doc.type == "Call"
                ? [
                    Text("${getmesssageDate(doc.createdAt)} : " +
                        "by ${doc.author == widget.sender.iid ? "You" : widget.second.name}")
                  ]
                : doc.author!.iid != widget.sender.iid
                    ? [
                        ReceiverMessageWidget(
                          message: doc,
                          second: widget.second,
                          sender: widget.sender,
                        )
                      ]
                    : [
                        SenderMessageWidget(
                          message: doc,
                        )
                      ]),
      );
    }).toList();
  }

  bool isImageFile(String path) {
    if (path.isEmpty) return false;
    final ext = path.toLowerCase();
    return ext.endsWith('.png') ||
        ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    _showCurrencyDialog(BuildContext context) {
      final TextEditingController amountController = TextEditingController();
      final contextType = "gift";
      final List<String> currencies = ['USD', 'EUR', 'JPY', 'GBP'];
      String selectedCurrency = currencies[0];
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter Amount'),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCurrency,
                        decoration: InputDecoration(
                          labelText: 'Currency',
                          border: OutlineInputBorder(),
                        ),
                        items: currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCurrency = value;
                            });
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    final amount = amountController.text;
                    if (amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Amount is required')),
                      );
                      return;
                    }
                    print("receivers user name ::: ${widget.second.name}");
                    // Build dynamic JSON transaction
                    final transaction = TransactionBuilder.buildTransaction(
                      contextType: 'gift',
                      amount: amountController.text,
                      selectedCurrency: selectedCurrency,
                      currentUser: {
                        'id': widget.sender.id,
                        'name': widget.sender.name,
                      },
                      receiverUser: {
                        'id': widget.second.id,
                        'name': widget.second.name,
                      },
                      chatRoomId: appController.room.value?.id,
                    );

                    Navigator.pop(context);

                    print("Transaction Json : ${transaction}");

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PaymentFormScreen(
                        transaction: transaction, // if you need this later
                      ),
                    ));
                  },
                ),
              ],
            );
          });
    }

    return Obx(() {
      // var istyping = appController.typinrooms.contains(appController.room.value!.id);
      var istyping = appController.room.value != null &&
          appController.typinrooms.contains(appController.room.value!.id);
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            title: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Info(widget.second, widget.sender, null, null)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.second.name!),
                  Text(
                    istyping
                        ? "Typing..."
                        : appController.onlineUsers.any(
                                (element) => element.id == widget.second.iid)
                            ? "Online"
                            : "Last seen ${getmesssageDate(widget.second.lastOnline.toString())}",
                    style: TextStyle(
                        fontSize: 12,
                        color: istyping ? greenColor : Colors.black),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
              GestureDetector(
                  onTap: () {
                    _showCurrencyDialog(context);
                  },
                  child: Image.asset(
                    "asset/icons/giftbox.png", /*height: 16,width: 16,*/
                  )),
              IconButton(
                  icon: Icon(
                    Icons.call,
                    color: blackColor,
                  ),
                  onPressed: () {
                    onJoin("AudioCall");
                  }),
              IconButton(
                  icon: Icon(Icons.video_call, color: blackColor),
                  onPressed: () {
                    onJoin("VideoCall");
                  }),
              PopupMenuButton(itemBuilder: (ct) {
                return [
                  PopupMenuItem(
                    value: 'value1',
                    child: InkWell(
                      onTap: () => showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => ReportUser(
                                currentUser: widget.sender,
                                seconduser: widget.second,
                              )).then((value) => Navigator.pop(ct)),
                      child: Container(
                          width: 100,
                          height: 30,
                          child: Text(
                            el.tr("Report"),
                          )),
                    ),
                  ),
                  PopupMenuItem(
                    height: 30,
                    value: 'value2',
                    child: InkWell(
                      child: Text(isBlocked ? "Unblock user" : "Block user"),
                      onTap: () {
                        Navigator.pop(ct);
                        showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              backgroundColor: whiteColor,
                              title: Text(isBlocked ? 'Unblock' : 'Block'),
                              content: Text('Do you want to ').tr(args: [
                                "${isBlocked ? 'Unblock' : 'Block'}",
                                "${widget.second.name}"
                              ]),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(el.tr('No')),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    // if (isBlocked &&
                                    //     blockedBy == widget.sender.id) {
                                    //   chatReference.doc('blocked').set({
                                    //     'isBlocked': !isBlocked,
                                    //     'blockedBy': widget.sender.id,
                                    //   }, SetOptions(merge: true));
                                    // } else if (!isBlocked) {
                                    //   chatReference.doc('blocked').set({
                                    //     'isBlocked': !isBlocked,
                                    //     'blockedBy': widget.sender.id,
                                    //   }, SetOptions(merge: true));
                                    // } else {
                                    //   CustomSnackbar.snackbar(
                                    //       "You can't unblock".tr().toString(),
                                    //       context);
                                    // }
                                  },
                                  child: Text(el.tr('Yes')),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )
                ];
              })
            ]),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: white,
            body: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  (!appController.messageloading.value == true)
                      ? appController.messages.isNotEmpty
                          ? Expanded(
                              child: ListView(
                                reverse: true,
                                children:
                                    generateMessages(appController.messages),
                              ),
                            )
                          : startNewDiscussion()
                      : Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            strokeWidth: 2,
                          ),
                        ),
                  Divider(height: 1.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: isBlocked
                        ? Text(el.tr("Sorry You can't send message!"))
                        : _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget getDefaultSendButton() {
    return IconButton(
      icon: Transform.rotate(
        angle: -pi / 9,
        child: Icon(
          Icons.send,
          size: 25,
        ),
      ),
      color: primaryColor,
      onPressed: _isWritting
          ? () {
              if (f_conten.path.isNotEmpty) {
                final fileType = f_conten.path.endsWith(".mp4") ||
                        f_conten.path.endsWith(".mov")
                    ? 'video'
                    : 'image';
                uploadFile(f_conten, onfinish: (user) {
                  _sendText(_textController.text.trimRight(), fileType,
                          user["shieldedID"])
                      .then((d) {
                    setState(() {
                      f_conten = File('');
                      _isWritting = _textController.text.trim().length > 0;
                    });
                  });
                });
              } else
                _sendText(_textController.text.trimRight(), null, null);
            }
          : null,
    );
  }

  Widget _buildTextComposer() {
    bool _isPickingMedia = false;
    return IconTheme(
      data: IconThemeData(color: _isWritting ? black : secondryColor),
      child: Container(
        color: whiteColor,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            if (f_conten.path.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 1,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: white,
                      ),
                      child: isImageFile(f_conten.path)
                          ? Image.file(
                              f_conten,
                              fit: BoxFit.contain,
                            ).withWidth(155)
                          : Center(
                              child: Icon(
                                Icons.videocam,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            f_conten = File('');
                            _isWritting =
                                _textController.text.trim().length > 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: <Widget>[
                      // Container(
                      //   color: whiteColor,
                      //   margin: EdgeInsets.symmetric(horizontal: 4.0),
                      //   child: IconButton(
                      //       icon: Icon(
                      //         Icons.photo_camera,
                      //         color: black,
                      //       ),
                      //       onPressed: () async {
                      //         getImageMessage(ImageSource.gallery, context, false,
                      //             callback: (image) async {
                      //           setState(() {
                      //             f_conten = image!;
                      //             _isWritting = true;
                      //           });
                      //         });
                      //       }),
                      // ),
                      new Flexible(
                        child: new TextField(
                          controller: _textController,
                          maxLines: 15,
                          minLines: 1,
                          autofocus: false,
                          onChanged: (String messageText) {
                            setState(() {
                              _isWritting = messageText.trim().length > 0;
                            });
                            istyping({
                              "room": {
                                "_id": appController.room.value!.id,
                              },
                              "isTyping": true
                            });
                          },
                          decoration: new InputDecoration.collapsed(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              hintText: el.tr("Send a message...")),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.attach_file_rounded,
                            color: black,
                          ),
                          onPressed: () async {
                            if (_isPickingMedia) return;
                            setState(() => _isPickingMedia = true);

                            try {
                              await getImageMessage(
                                ImageSource.gallery,
                                context,
                                false,
                                callback: (file, type) {
                                  setState(() {
                                    f_conten = file;
                                    _isWritting = true;
                                  });
                                },
                              );
                            } catch (e) {
                              print("Media picking failed: $e");
                            } finally {
                              setState(() => _isPickingMedia = false);
                            }
                          }),
                      IconButton(
                        icon: Icon(
                          Icons.photo_camera,
                          color: black,
                        ),
                        onPressed: () async {
                          if (_isPickingMedia) return;
                          setState(() => _isPickingMedia = true);

                          try {
                            await getImageMessage(
                              ImageSource.camera,
                              context,
                              false,
                              callback: (file, type) {
                                setState(() {
                                  f_conten = file;
                                  _isWritting = true;
                                });
                              },
                            );
                          } catch (e) {
                            print("Media picking failed: $e");
                          } finally {
                            setState(() => _isPickingMedia = false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: getDefaultSendButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _sendText(String text, String? type, String? file) async {
    _textController.clear();

    // ADD DEBUG PRINTS HERE
    print("==========================================");
    print("Sending to room: ${appController.room.value!.id}");
    print("Current user: ${widget.sender.iid} (${widget.sender.name})");
    print("Recipient: ${widget.second.iid} (${widget.second.name})");
    print("Message content: $text");
    print("Message type: ${type ?? 'text'}");
    print("File ID: ${file ?? 'none'}");
    print("==========================================");

    if(appController.room.value != null){
      var req = {
        'sender_id': widget.sender.id,
        'receiver_id': widget.second.id,
        'fileID': file,
        'type': type ?? 'text',
        "roomID": appController.room.value!.id,
        "authorID": widget.sender.iid,
        "content": text,
        "contentType": 'text',
      };
      sendmessage(req).then((res) async {
        if (res.message != null) {
          setState(() {
            _isWritting = false;
          });
          appController.messages.insert(0, res.message!);
          appController.typinrooms
              .removeWhere((element) => element == appController.room.value!.id);
          appController.getMatches();

          // createroom();
        }
      });
    }
  }

  Future<void> onJoin(callType) async {
    if (!isBlocked) {
      await handleCameraAndMic(callType);

      var res = await getMeetingRoom({
        "startedAsCall": true,
        "caller": widget.sender.iid,
        "callee": widget.second.iid,
        "callToGroup": false,
        "group": appController.room.value!.id,
        "callType": callType,
      });

      appController.meeting.value = res;

      await postCall(
          {"roomID": appController.room.value!.id, "meetingID": res.id});
      appController.callanswer.value = "calling";

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DialCall(receiver: widget.second, callType: callType),
        ),
      );
    } else {
      CustomSnackbar.snackbar(el.tr("Blocked !"), context);
    }
  }
}

Future uploadFile(File? image, {onfinish}) async {
  var user = {};
  String fileExtension = pathd.extension(image!.path).toLowerCase();
  if (!image.existsSync()) {
    toast("Image is not available", print: true);
    return;
  }
  String path = "";
  if (isImage(fileExtension)) {
    path = "image";
  } else if (isVideo(fileExtension)) {
    path = "video";
  } else {
    toast("Unsupported file type: $fileExtension");
  }
  http.MultipartRequest multiPartRequest =
      await getMultiPartRequest('upload/${path}');
  multiPartRequest.files
      .add(await http.MultipartFile.fromPath(path, image.path));
  multiPartRequest.headers.addAll(buildHeaderTokens());
  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      if (data != null) {
        if ((data as String).isJson()) {
          data = json.decode(data) as Map<String, dynamic>?;
          user["shieldedID"] = "${data[path]["_id"]}";
        }
      }
    },
    onError: (error) {
      toast(error.toString(), print: true);
    },
  ).catchError((e) {
    toast(e.toString(), print: true);
  });

  if (onfinish != null) {
    onfinish(user);
  }
}

Future<void> handleCameraAndMic(callType) async {
  if (callType == 'VideoCall') {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  } else {
    await Permission.microphone.request();
  }
}

Future<Uint8List?> getVideoThumbnail(String videoUrl) async {
  try {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxWidth: 300, // customize thumbnail width
      quality: 75,
    );
    return uint8list;
  } catch (e) {
    print("Thumbnail error: $e");
    return null;
  }
}
