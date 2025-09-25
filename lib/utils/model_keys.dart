import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:logger/logger.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:video_player/video_player.dart';

class CommonKeys {
  static String id = 'id';
  static String address = 'address';
  static String serviceId = 'service_id';
  static String jobId = 'offer_id';
  static String customerId = 'customer_id';
  static String handymanId = 'handyman_id';
  static String providerId = 'provider_id';
  static String bookingId = 'booking_id';
  static String date = 'date';
  static String status = 'status';
  static String dateTime = 'datetime';
}

class ServiceTypesKeys {
  static String reservation = 'reservation';
  static String payable = 'payable';
  static String contact = 'contact';
}

class Rks {
  static Map<String, VideoPlayerController> videosing =
      new Map<String, VideoPlayerController>(); // Make it non-nullable

  Future<bool> netChecker() async {
    // return kReleaseMode ? await isNetworkAvailable() : true;
    return true;
  }

  static Future<User?> get_current_user() async {
    int? userId = nb_utils.getIntAsync(USER_ID, defaultValue: 0);
    if (userId != 0) {
      User res = await getUser(userId: '$userId');

      if (res.id != null) {
        return res;
      }
    }
    return null;
  }

  static dynamic Function() update_current_user = () async {
    int? userId = nb_utils.getIntAsync(USER_ID, defaultValue: 0);
    if (userId != 0) {
      User res = await getUser(userId: '$userId');

      if (res.id != null) {
        return res;
      }
    }
    return null;
  };

  static dynamic Function() createAnswer = () async {};
  static dynamic Function() closeCall = () async {};

  static dynamic callApiForYou;
  static dynamic source;
  static dynamic uploadFile;
  static dynamic onclickAddMedia;
  static dynamic items;
  static int idnotifications = 1;
  static Timer? typingTimer;
  static User? currentUser;
  static Room? callinlingRoom;
  static ProductDetails? product;

  static BuildContext? context = null;
  static List? imageUrl = null;
  static User currencUser = User();
  static Map? imagesIndexes = {};
  static Map? toastcolor = {};
  static User? payingUser;
  static Logger logger = Logger(
      // filter: ProductionFilter(),
      // level: Level.error,
      );
  static Map? postdescriptor = {
    "describe": false,
    "title": "",
    "go": "no",
    "f_type": '',
    "f_conten": null,
    "tags": [],
    "description": "",
    "thumbNail": null,
  };
  static var temptoken = "";

  static var socket;

  static void initdesciptor() {
    postdescriptor = {
      "describe": false,
      "title": "",
      "go": "no",
      "f_type": '',
      "f_conten": null,
      "tags": [],
      "thumbNail": null,
    };
  }
}

class UserKeys {
  static String firstName = 'firstName';
  static String lastName = 'lastName';
  static String userName = 'username';
  static String email = 'email';
  static String dob = 'user_DOB';
  static String about = 'about';
  static String interests = 'interests';
  static String gender = 'userGender';
  static String password = 'password';
  static String userType = 'user_type';
  static String contactNumber = 'phone';
  static String countryId = 'country_id';
  static String indicatif = 'indicatif';
  static String stateId = 'state_id';
  static String cityId = 'city_id';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String profileImage = 'profile_image';
  static String playerId = 'player_id';
  static String uid = 'uid';
  static String id = 'id';
  static String loginType = 'login_type';
  static String accessToken = 'accessToken';
}

class BookingServiceKeys {
  static String description = 'description';
  static String couponId = 'coupon_id';
  static String date = 'date';
  static String totalAmount = 'total_amount';
}

class CouponKeys {
  static String code = 'code';
  static String discount = 'discount';
  static String discountType = 'discount_type';
  static String expireDate = 'expire_date';
}

class PubsTypeKeys {
  static const String joboffer = 'joboffer';
  static const String provider = 'provider';
  static const String service = 'service';
}

class BookService {
  static String amount = 'amount';
  static String totalAmount = 'total_amount';
  static String quantity = 'quantity';
  static String bookingAddressId = 'booking_address_id';
}

class BookingStatusKeys {
  static String pending = 'pending';
  static String accept = 'accept';
  static String onGoing = 'on_going';
  static String inProgress = 'in_progress';
  static String hold = 'hold';
  static String rejected = 'rejected';
  static String failed = 'failed';
  static String complete = 'completed';
  static String cancelled = 'cancelled';
}

class BookingUpdateKeys {
  static String reason = 'reason';
  static String startAt = 'start_at';
  static String endAt = 'end_at';
  static String date = 'date';

  static String durationDiff = 'duration_diff';
}

class NotificationKey {
  static String type = 'type';
  static String page = 'page';
}

class CurrentLocationKey {
  static String latitude = 'latitude';
  static String longitude = 'longitude';
}
