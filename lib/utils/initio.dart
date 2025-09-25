import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as gt;
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tharkyApp/Screens/Calling/incomingCall.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/NotificationModel.dart';
import 'package:tharkyApp/models/base_response_model.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/store/app_store.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

void initSocket([AppStore? appStore]) {
  IO.Socket socket = IO.io(DOMAIN_URL, <String, dynamic>{
    'autoConnect': true,
    'transports': ['websocket'],
  });

  // 🎯 Connexion et authentification
  socket.onConnect((_) {
    myprint2('Socket connecté');
    socket.emit('authenticate', {"token": appStore!.token});
  });

  socket.on('authenticated', (data) {
    myprint2("Socket authentifié");
    Rks.socket = socket;
  });

  socket.on('message-in', (data) {
    String roomId = data['room']['_id'];
    Map<String, dynamic> message = data['message'];
    appController.getMatches();

    if (appController.messages.isEmpty ||
        appController.messages.first.id != message['_id']) {
      appController.messages.insert(0, Message.fromJson(data['message']));
    }
    final currentRoom = appController.room.value;
    if (currentRoom != null &&
        currentRoom.id == roomId &&
        data["sender"] != appStore?.iid) {
      appController.readmessage();
    }

    // String currentRoom = appStore!.currentR  oomId;

    // // Mise à jour des messages non lus
    // if (currentRoom != roomId) {
    //   appStore.addUnreadMessage(roomId);
    // } else {
    //   appStore.addMessage(message);
    // }

    myprint2('Nouveau message reçu: $message $roomId');
  });

  // 🎯 Gestion des nouveaux producteurs (WebRTC)
  socket.on('notification', (data) {
    print('New notification: ${data}');
    NotificationModel notificationModel = NotificationModel.fromJson(data);
    appController.notifications.add(notificationModel);
    appController.notifications.refresh();
    appController.getNotifications();
    appController.getMatches();
    showNotification(
        {"title": notificationModel.title, "body": notificationModel.body},
        type: "simple");
  });

  // // 🎯 Gestion de la déconnexion des producteurs
  // socket.on('leave', (data) {
  //   appStore!.removeProducer(data['socketID']);
  //   myprint2('Un utilisateur a quitté: ${data['socketID']}');
  // });

  // 🎯 Gestion des appels WebRTC
  socket.on('call', (data) {
    User caller = User.fromJson(data['counterpart']);
    Rks.callinlingRoom = Room.fromJson(data['room']);

    showNotification({
      "title": "${caller.firstName} ${caller.lastName}",
      "body": "Call in progress..."
    }, type: "call");

    Map callInfo = {
      'caller': caller.iid,
      'channel_id': data['meetingID'],
      'callType': data['callType'] ?? "",
      'senderName': "${caller.firstName} ${caller.lastName}",
      'senderPicture': imageUrl(caller.imageUrl?[0]),
      'callerobj': caller,
    };
    // Map callInfo = {};
    // callInfo['caller'] = caller.iid;
    // callInfo['channel_id'] = data['meetingID'];
    // callInfo['callType'] = data['callType'] ?? "";
    // callInfo['senderName'] = "${caller.firstName} ${caller.lastName}";
    // callInfo['senderPicture'] = imageUrl(caller.imageUrl![0]);
    // callInfo['callerobj'] = caller;

    gt.Get.to(() => Incoming(callInfo));
  });
  socket.on('offertcandidate', (dato) async {
    String currentRoute = gt.Get.currentRoute;
    if (currentRoute == "/Incoming" && dato['type'] == "offer") {
      //3---> initiation de bleu 2

      try {
        dynamic data = jsonDecode(dato["sdpOfferController"]);

        String sdp = write(data["sdp"], null);

        RTCSessionDescription description = RTCSessionDescription(
          sdp,
          dato['type'] ?? 'answer',
        );

        await appController.peerConnection!.setRemoteDescription(description);

        if (data['candidates'] != null) {
          for (var candidate in data['candidates']) {
            await appController.peerConnection!.addCandidate(RTCIceCandidate(
              candidate['candidate'],
              candidate['sdpMid'],
              candidate['sdpMlineIndex'],
            ));
          }
        }
        while ((await appController.peerConnection!.getStats()).length < 3) {
          await Future.delayed(Duration(seconds: 2));
        }
        //4---> initiation de rouge 2

        Rks.createAnswer();
      } catch (e) {
        myprint(e);
      }
    }
    if (dato['type'] == "answer") {
      //5---> initiation de bleu 1

      try {
        dynamic data = jsonDecode(dato["sdpOfferController"]);

        String sdp = write(data["sdp"], null);

        RTCSessionDescription description = RTCSessionDescription(
          sdp,
          dato['type'] ?? 'answer',
        );

        await appController.peerConnection!.setRemoteDescription(description);

        if (data['candidates'] != null) {
          for (var candidate in data['candidates']) {
            await appController.peerConnection!.addCandidate(RTCIceCandidate(
              candidate['candidate'],
              candidate['sdpMid'],
              candidate['sdpMlineIndex'],
            ));
          }
        }
      } catch (e) {
        myprint(e);
      }
    }
  });

  socket.on('answer', (data) {
    myprint2("ttttt ${data['answer']}");

    if (appController.meeting.value!.id == data['meetingID']) {
      appController.callanswer.value = data['answer'];
    }
  });

  socket.on('close', (data) {
    cancelNotificationWithTag();
    String currentRoute = gt.Get.currentRoute;
    appController.callanswer.value = "calling";
    Rks.context = Rks.context ?? gt.Get.context;
    Rks.logger.t(" '$currentRoute' ${Rks.context}");

    if (currentRoute == "/Incoming" || currentRoute == "/Incomdddding") {
      Navigator.pushReplacement(Rks.context!,
          MaterialPageRoute(builder: (context) => Tabbar(null, false)));
    }

    // if (currentRoute == "/Incomdddding") {
    //   Navigator.pushReplacement(Rks.context!,
    //       MaterialPageRoute(builder: (context) => Tabbar(null, false)));
    // }
  });

  // 🎯 Suppression de l'utilisateur (déconnexion)
  socket.on('user-deleted', (_) {
    myprint2('Utilisateur supprimé, déconnexion...');
    logout(Rks.context!).whenComplete(() {});
  });

  // 🎯 Gestion des utilisateurs en ligne
  socket.on('onlineUsers', (data) {
    appController.onlineUsers.value = data.map<OnlineUser>((e) {
      return OnlineUser.fromJson(e);
    }).toList();
    // appStore!.setOnlineUsers(data);
  });

  socket.on('typing', (data) {
    try {
      final currentRoom = appController.room.value;
      if (data != null &&
          data is Map &&
          data['roomID'] != null &&
          currentRoom?.id == data['roomID'])
      // if (appController.room.value != null &&
      //     appController.room.value!.id == data!['roomID'])
      {
        if (data['isTyping'] == true) {
          Rks.typingTimer?.cancel();
          Rks.typingTimer = Timer(Duration(seconds: 10), () {
            appController.typinrooms
                .removeWhere((element) => element == data['roomID']);
          });
        } else {
          Rks.typingTimer?.cancel();
        }
        appController.typinrooms.add(data['roomID']);
      }
    } catch (e, stacktrace) {
      myprint("Error in typing event: $e");
      myprint(stacktrace);
    }
  });

  // socket.on('typing', (data) {
  //   if (appController.room.value != null &&
  //       appController.room.value!.id == data!['roomID']) {
  //     if (data['isTyping']) {
  //       Rks.typingTimer?.cancel();
  //       Rks.typingTimer = Timer(Duration(seconds: 10), () {
  //         appController.typinrooms
  //             .removeWhere((element) => element == data['roomID']);
  //       });
  //     } else {
  //       Rks.typingTimer?.cancel();
  //     }
  //     appController.typinrooms.add(data['roomID']);
  //   }
  // });

  socket.on('haveread', (data) {
    if (data['haveRead'] == true) {
      appController.matches.forEach((element) {
        if (element.id == data['roomID']) {
          element.lastMessage?.isRead = true;
        }
      });
      appController.matches.refresh();
    }
    // if (appController.room.value != null &&
    //     appController.room.value!.id == data!['roomID'])
    final currentRoom = appController.room.value;
    if (data != null &&
        data is Map &&
        data['roomID'] != null &&
        currentRoom != null &&
        currentRoom.id == data['roomID']) {
      for (var element in appController.messages) {
        element.isRead = true;
      }
      appController.messages.refresh();
      currentRoom.lastMessage?.isRead = true;
      appController.room.refresh();
    }
  });

  // socket.on('haveread', (data) {
  //   if (data['haveRead']) {
  //     appController.matches.forEach((element) {
  //       if (element.id == data!['roomID']) {
  //         element.lastMessage!.isRead = true;
  //       }
  //     });
  //     appController.matches.refresh();
  //   }
  //   if (appController.room.value != null &&
  //       appController.room.value!.id == data!['roomID']) {
  //     appController.messages.forEach((element) {
  //       element.isRead = true;
  //     });
  //     appController.messages.refresh();
  //     appController.room.value!.lastMessage?.isRead = true;
  //     appController.room.refresh();
  //   }
  // });

  // // 🔥 Déconnexion et erreurs
  // socket.onDisconnect((_) => myprint2('Déconnecté du serveur'));
  // socket.onConnectError((err) => my_print_err(err));
  // socket.onError((err) => my_print_err(err));

  // // Avant fermeture de l'application, envoi de "leave"
  // WidgetsBinding.instance.addObserver(LifecycleEventHandler(
  //   onClose: () {
  //     socket.emit(
  //         'leave', {"socketID": socket.id, "roomID": appStore!.currentRoomId});
  //     return Future.value();
  //   },
  // ));

  socket.onDisconnect((_) => myprint2('disconnect'));
  socket.on('fromServer', (_) => myprint2(_));
  // socket.connect();
  socket.onConnectError((err) => my_print_err(err));
  socket.onError((err) => my_print_err(err));
}
