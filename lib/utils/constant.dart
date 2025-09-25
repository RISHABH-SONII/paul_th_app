import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
var appPackageName = isAndroid ? 'com.transyambro.user' : 'com.transiqonic.user';

//region Common Configs
const DEFAULT_FIREBASE_PASSWORD = 12345678;
const DECIMAL_POINT = 2;
const MAXIMUM_INTERESTS = 5;
const PER_PAGE_ITEM = 20;
const LABEL_TEXT_SIZE = 18;
const double SETTING_ICON_SIZE = 22;
const MARK_AS_READ = 'markas_read';
const PERMISSION_STATUS = 'permissionStatus';

const ONESIGNAL_TAG_KEY = 'appType';
const ONESIGNAL_TAG_VALUE = 'userApp';
const PER_PAGE_CHAT_LIST_COUNT = 50;

const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";

const BOOKING_TYPE_ALL = 'Tout';
//endregion

//region LIVESTREAM KEYS
const LIVESTREAM_TOKEN = 'tokenStream';
const LIVESTREAM_UPDATE_BOOKING_LIST = "UpdateBookingList";
const SLIDE_PROVIER_SCREEN = "SLIDE_PROVIER_SCREEN";
const LIVESTREAM_UPDATE_SERVICE_LIST = "LIVESTREAM_UPDATE_SERVICE_LIST";
const LIVESTREAM_UPDATE_job_LIST = "LIVESTREAM_UPDATE_job_LIST";
const LIVESTREAM_UPDATE_DASHBOARD = "streamUpdateDashboard";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
//endregion

//region default USER login
const DEFAULT_EMAIL = 'demo@user.com';
const DEFAULT_PASS = '12345678';
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion
//region User Properties Keys
const PHONE_NUMBER = 'PHONE_NUMBER';
const LAST_MSG = 'LAST_MSG';
const GENDER = 'GENDER';
const SHOW_GENDER = 'SHOW_GENDER';
const SHOW_INTERESTS = 'SHOW_INTERESTS';
const AGE_RANGE = 'AGE_RANGE';
const META = 'META';
const MAX_DISTANCE = 'MAX_DISTANCE';
const ABOUT = 'ABOUT';
const DISTANCE_BW = 'DISTANCE_BW';
const INTERESTS = 'INTERESTS';
const LEVEL = 'LEVEL';
const DOB = 'DOB';
const FAVORITES = 'FAVORITES';
const IMAGES = 'IMAGES';
const PRIVATES = 'PRIVATES';
const LAST_ONLINE = 'LAST_ONLINE';
//endregion
//region SHARED PREFERENCES KEYS
const IS_DOCUMENT_VERIFIED = 'IS_DOCUMENT_VERIFIED';
const TOTAL_SCORE = 'TOTAL_SCORE';
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_FULL_NAME = 'USER_FULL_NAME';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COORDINATE = 'COORDINATE';
const COUNTRY_INDICATIF = 'COUNTRY_INDICATIF';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
const LOGIN_TYPE = 'LOGIN_TYPE';
const PAYMENT_LIST = 'PAYMENT_LIST';
const USER_TYPE = 'USER_TYPE';
const USER_PS = 'USER_PS';

const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const USE_MATERIAL_YOU_THEME = 'USE_MATERIAL_YOU_THEME';
const IN_MAINTENANCE_MODE = 'inMaintenanceMode';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const SERVER_LANGUAGES = 'SERVER_LANGUAGES';
const AUTO_SLIDER_STATUS = 'AUTO_SLIDER_STATUS';
const UPDATE_NOTIFY = 'UPDATE_NOTIFY';
const CURRENCY_POSITION = 'CURRENCY_POSITION';
//endregion

//region FORCE UPDATE
const FORCE_UPDATE = 'forceUpdate';
const FORCE_UPDATE_USER = 'forceUpdateInUser';
const USER_CHANGE_LOG = 'userChangeLog';
const LATEST_VERSIONCODE_USER_APP_ANDROID = 'latestVersionCodeUserAndroid';
const LATEST_VERSIONCODE_USER_APP_IOS = 'latestVersionCodeUseriOS';
//endregion

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region CONFIGURATION KEYS
const CONFIGURATION_TYPE_CURRENCY = 'CURRENCY';
const CONFIGURATION_TYPE_CURRENCY_POSITION = 'CURRENCY_POSITION';
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
const IS_CURRENT_LOCATION = 'CURRENT_LOCATION';
//endregion

//region User Types
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const USER_TYPE_USER = 'user';
//endregion

//region LOGIN TYPE
const LOGIN_TYPE_USER = 'user';
const LOGIN_TYPE_GOOGLE = 'google';
const LOGIN_TYPE_FACEBOOK = 'facebook';
const LOGIN_TYPE_OTP = 'mobile';
//endregion

//region SERVICE TYPE
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_PERCENT = 'percent';
const SERVICE_TYPE_HOURLY = 'hourly';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_PAYSTACK = 'paystack';
const PAYMENT_METHOD_FLUTTER_WAVE = 'wave';
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;
//endregion

//region FILE TYPE
const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region CHAT LANGUAGE
const List<String> RTL_LanguageS = ['ar', 'ur'];
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}
//endregion

//region MessageExtension
extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'dd-MMM-yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'dd-MMM-yyyy';
const HOUR_12_FORMAT = 'HH:mm';
const DATE_FORMAT_4 = 'dd MMM';
const YEAR = 'yyyy';
const MONTH_YEAR = 'MMM yyyy';
const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';
const GOOGLE_MAP_DIRECTION = 'http://maps.google.com/maps?saddr=';

// max Video upload limit in MB
int maxUploadMB = 50;
// max Video upload second
int maxUploadSecond = 360;
const int paginationLimit = 5;

final List<Map<String, dynamic>> interestList = [
  {'name': 'Gaming', 'emoji': '🎮', 'ontap': false, 'color': Colors.redAccent},
  {'name': 'Dancing', 'emoji': '💃', 'ontap': false, 'color': Colors.blueAccent},
  {'name': 'Language', 'emoji': '🌐', 'ontap': false, 'color': Colors.greenAccent},
  {'name': 'Music', 'emoji': '🎵', 'ontap': false, 'color': Colors.purpleAccent},
  {'name': 'Movie', 'emoji': '🎬', 'ontap': false, 'color': Colors.orangeAccent},
  {'name': 'Photography', 'emoji': '📷', 'ontap': false, 'color': Colors.pinkAccent},
  {'name': 'Architecture', 'emoji': '🏛️', 'ontap': false, 'color': Colors.tealAccent},
  {'name': 'Fashion', 'emoji': '👗', 'ontap': false, 'color': Colors.indigoAccent},
  {'name': 'Books', 'emoji': '📚', 'ontap': false, 'color': Colors.amberAccent},
  {'name': 'Animals', 'emoji': '🐾', 'ontap': false, 'color': Colors.cyanAccent},
  {'name': 'Fitness', 'emoji': '💪', 'ontap': false, 'color': Colors.deepOrangeAccent},
  {'name': 'Writing', 'emoji': '✍️', 'ontap': false, 'color': Colors.lightGreenAccent},
];

List<Map<String, dynamic>> updateInterestList(
    List<Map<String, dynamic>> interestList, List<String> userInterests) {
  return interestList.map((interest) {
    return {
      'name': interest['name'],
      'emoji': interest['emoji'],
      'ontap': userInterests.contains(interest['name']),
      'color': interest['color'],
    };
  }).toList();
}
