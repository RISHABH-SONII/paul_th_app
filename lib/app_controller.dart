import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/models/NotificationModel.dart';
import 'package:tharkyApp/models/base_response_model.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';

class AppController extends GetxController {
  var isLoading = true.obs;
  var typinrooms = <String>[].obs;
  var isAuth = false.obs;
  var isDocumentVerified = false.obs;
  var isRegistered = false.obs;
  var messageloading = false.obs;
  var callanswer = "calling".obs;
  var matches = <Room>[].obs;
  var newMatches = <Room>[].obs;
  var notifications = <NotificationModel>[].obs;
  var room = Rxn<Room>(),
      meeting = Rxn<Meeting>(),
      messages = <Message>[].obs,
      onlineUsers = <OnlineUser>[].obs,
      refreshMeetings = null;
  var localRenderer, remoteRenderer;

  RTCPeerConnection? peerConnection;

  Rx<MediaStream?> remoteStream = Rx<MediaStream?>(null);
  Rx<MediaStream?> localStream = Rx<MediaStream?>(null);
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() async {
    super.onInit();
    await checkAuth();
    getMatches();
  }

  // Future<void> checkAuth() async {
  //   int? userId = getIntAsync(USER_ID, defaultValue: 0);
  //   String? fullName = getStringAsync(USERNAME, defaultValue: "");
  //
  //   if (userId != 0) {
  //     isLoading.value = true;
  //     await getUser(userId: '$userId').then((res) async {
  //       if (res.firstName != null) {
  //         await saveUserData(res);
  //         // initSocket(appStore);
  //       }
  //     });
  //     isRegistered.value = true;
  //     isLoading.value = false;
  //   }
  //   isLoading.value = false;
  //
  //   if (fullName != " ") {
  //     isAuth.value = true;
  //   }
  // }

  Future<void> checkAuth() async {
    try {
      // Set loading to true at the start
      isLoading.value = true;

      // Fetch stored user data
      int? userId = await getIntAsync(USER_ID, defaultValue: 0);
      String? fullName = await getStringAsync(USERNAME, defaultValue: "");
      bool isDocVerified = await getBoolAsync(IS_DOCUMENT_VERIFIED, defaultValue: false);

      // Check if user is potentially authorized
      if (userId != 0) {
        try {
          // Fetch user data from API
          final res = await getUser(userId: '$userId');
          if (res.firstName != null) {
            await saveUserData(res);
            // initSocket(appStore); // Uncomment if needed
            isRegistered.value = true;
            isDocumentVerified.value = isDocVerified;
            isAuth.value = fullName.isNotEmpty && isDocVerified;
          } else {
            // User data invalid, treat as unauthorized
            isRegistered.value = false;
            isAuth.value = false;
          }
        } catch (e) {
          print('Error fetching user data: $e');
          isRegistered.value = false;
          isAuth.value = false;
        }
      } else {
        // No user ID, user is unauthorized
        isRegistered.value = false;
        isAuth.value = false;
      }
    } catch (e) {
      print('Error in checkAuth: $e');
      isRegistered.value = false;
      isAuth.value = false;
    } finally {
      // Always set loading to false to prevent splash screen hang
      isLoading.value = false;
    }
  }

  // Reactive lists for matches and new matches

  // Method to fetch matches

  Future<void> getMatches() async {
    try {
      final response = await getmatches();
      final fmatches = response.data["matches"];
      final fnewMatches = response.data["newMatches"];
      print("GetMatches Response :: $response");

      // Clear existing matches
      matches.clear();
      newMatches.clear();

      // Add new matches
      if (fmatches != null && fmatches.length > 0) {
        fmatches.forEach((f) async {
          matches.add(Room.fromJson(f));
        });
      }
      if (fnewMatches != null && fnewMatches.length > 0) {
        fnewMatches.forEach((f) async {
          newMatches.add(Room.fromJson(f));
        });
      }
    } catch (e) {
      // Handle errors
      print("Error fetching matches: $e");
    }
  }

  void readmessage() async {
    var req = {
      'isRead': true,
      "roomID": room.value!.id,
    };
    readMessage(req);
  }

  Future<void> getMessages() async {
    try {
      messageloading.value = true;
      final responses = await mygetMoreMessages({
        "roomID": room.value!.id,
        "firstMessageID":
            messages.isNotEmpty ? messages[0].id : room.value!.lastMessage?.id,
      });
      final newmessages = responses.data;

      if (newmessages != null && newmessages.length > 0) {
        newmessages.forEach((f) {
          messages.insert(0, Message.fromJson(f));
        });
        messages.value = messages.reversed.toList();
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
    messageloading.value = false;
  }

  Future<void> getNotifications() async {
    try {
      messageloading.value = true;

      final responses = await getmynotifications(
          first: notifications.isNotEmpty ? notifications[0].id : "");

      final newnotifications = responses.data;

      if (newnotifications != null && newnotifications.length > 0) {
        newnotifications.forEach((f) {
          notifications.insert(0, NotificationModel.fromJson(f));
        });
      }
    } catch (e) {
      inspect(e);
      Rks.logger.e("Error fetching messages: $e");
    }
    messageloading.value = false;
  }

  @override
  void onClose() {
    localStream.value?.dispose();
    remoteStream.value?.dispose();
    if (peerConnection != null) peerConnection!.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void playRemoteAudio(MediaStream? remoteStream) async {
    if (remoteStream != null) {
      final audioTrack = remoteStream.getAudioTracks().first;
      await audioPlayer
          .setUrl(audioTrack.kind!); // Utilisation fictive pour l'exemple
      await audioPlayer.play();
    }
  }
}
