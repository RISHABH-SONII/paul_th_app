import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isRememberMe = false;

  @observable
  String selectedLanguageCode = "en";

  @observable
  List<String>? userProfileImage = [];

  @observable
  String privacyPolicy = '';

  @observable
  String loginType = '';

  @observable
  String termConditions = '';

  @observable
  String displayname = '';

  @observable
  String iid = '';

  @observable
  String helplineNumber = '';

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  @observable
  String uid = '';

  @observable
  String userEmail = '';

  @observable
  String userName = '';

  @observable
  double latitude = 0.0;

  @observable
  double longitude = 0.0;

  @observable
  String currentAddress = '';

  @observable
  String token = '';

  @observable
  ObservableMap<String, String> coordinates = ObservableMap<String, String>();

  @observable
  String currencySymbol = '';

  @observable
  String userDob = '';

  @observable
  String currencyCountryId = '';

  @observable
  String address = '';

  @observable
  String playerId = '';

  @observable
  int? userId = -1;

  @observable
  int? unreadCount = 0;

  @observable
  bool useMaterialYouTheme = true;

  @observable
  ObservableList<String> todos = ObservableList<String>();

  @observable
  String userType = '';

  @observable
  String purchaseString = '';

  // New fields added
  @observable
  String? phoneNumber;

  @observable
  int? lastmsg;

  @observable
  String? gender;

  @observable
  String? showGender;

  @observable
  bool? showInterests;

  @observable
  Map<String, dynamic>? ageRange;

  @observable
  Map<String, dynamic>? meta;

  @observable
  int? maxDistance;

  @observable
  String? about;

  @observable
  double? distanceBW;

  @observable
  List<String>? interests;

  @observable
  String? level;

  @observable
  List<String>? favorites;

  @observable
  List<String>? images;
  @observable
  List<String>? privates;
  @observable
  List<String>? imageUrl;

  @observable
  int? lastOnline;

  @observable
  String? totalScore;

  @observable
  bool? isDocumentVerified;

  @action
  Future<void> setUseMaterialYouTheme(bool val,
      {bool isInitializing = false}) async {
    useMaterialYouTheme = val;
    if (!isInitializing) await setValue(USE_MATERIAL_YOU_THEME, val);
  }

  @action
  Future<void> setPlayerId(String val, {bool isInitializing = false}) async {
    playerId = val;
    if (!isInitializing) await setValue(PLAYERID, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setpurchaseString(String val,
      {bool isInitializing = false}) async {
    purchaseString = val;
    if (!isInitializing) await setValue(USER_PS, val);
  }

  @action
  Future<void> setAddress(String val, {bool isInitializing = false}) async {
    address = val;
    if (!isInitializing) await setValue(ADDRESS, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val,
      {bool isInitializing = false}) async {
    privacyPolicy = val;
    if (!isInitializing) await setValue(PRIVACY_POLICY, val);
  }

  @action
  Future<void> setLoginType(String val, {bool isInitializing = false}) async {
    loginType = val;
    if (!isInitializing) await setValue(LOGIN_TYPE, val);
  }

  @action
  Future<void> setTermConditions(String val,
      {bool isInitializing = false}) async {
    termConditions = val;
    if (!isInitializing) await setValue(TERM_CONDITIONS, val);
  }

  @action
  Future<void> setDisplayname(String val, {bool isInitializing = false}) async {
    displayname = val;
    if (!isInitializing) await setValue(INQUIRY_EMAIL, val);
  }

  @action
  Future<void> set_id(String val, {bool isInitializing = false}) async {
    iid = val;
    if (!isInitializing) await setValue("IID", val);
  }

  @action
  Future<void> setHelplineNumber(String val,
      {bool isInitializing = false}) async {
    helplineNumber = val;
    if (!isInitializing) await setValue(HELPLINE_NUMBER, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  @action
  Future<void> setCoordinates(ObservableMap<String, String> val,
      {bool isInitializing = false}) async {
    coordinates = val;
    if (!isInitializing) await setValue(COORDINATE, val);
  }

  @action
  Future<void> setCurrencySymbol(String val,
      {bool isInitializing = false}) async {
    currencySymbol = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_SYMBOL, val);
  }

  @action
  Future<void> setUserDob(String val, {bool isInitializing = false}) async {
    userDob = val;
    if (!isInitializing) await setValue(DOB, val);
  }

  @action
  Future<void> setCurrencyCountryId(String val,
      {bool isInitializing = false}) async {
    currencyCountryId = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_ID, val);
  }

  @action
  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uid = val;
    if (!isInitializing) await setValue(UID, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USERNAME, val);
  }

  @action
  Future<void> setCurrentAddress(String val,
      {bool isInitializing = false}) async {
    currentAddress = val;
    if (!isInitializing) await setValue(CURRENT_ADDRESS, val);
  }

  @action
  Future<void> setLatitude(double val, {bool isInitializing = false}) async {
    latitude = val;
    await setValue(LATITUDE, val);
  }

  @action
  Future<void> setLongitude(double val, {bool isInitializing = false}) async {
    longitude = val;
    await setValue(LONGITUDE, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setUnreadCount(int val) {
    unreadCount = val;
  }

  @action
  void setRemember(bool val) {
    isRememberMe = val;
  }

  @action
  Future<void> setPhoneNumber(String? val) async {
    phoneNumber = val;
    await setValue(PHONE_NUMBER, val);
  }

  @action
  Future<void> setLastMsg(int? val) async {
    lastmsg = val;
    await setValue(LAST_MSG, val);
  }

  @action
  Future<void> setGender(String? val) async {
    gender = val;
    await setValue(GENDER, val);
  }

  @action
  Future<void> setShowGender(String? val) async {
    showGender = val;
    await setValue(SHOW_GENDER, val);
  }

  @action
  Future<void> setShowInterests(bool? val) async {
    showInterests = val;
    await setValue(SHOW_INTERESTS, val);
  }

  @action
  Future<void> setAgeRange(Map<String, dynamic>? val) async {
    ageRange = val;
    await setValue(META, val);
  }

  @action
  Future<void> setMeta(Map<String, dynamic>? val) async {
    meta = val;
    await setValue(AGE_RANGE, val);
  }

  @action
  Future<void> setMaxDistance(int? val) async {
    maxDistance = val;
    await setValue(MAX_DISTANCE, val);
  }

  @action
  Future<void> setAbout(String? val) async {
    about = val;
    await setValue(ABOUT, val);
  }

  @action
  Future<void> setDistanceBW(double? val) async {
    distanceBW = val;
    await setValue(DISTANCE_BW, val);
  }

  @action
  Future<void> setInterests(List<String>? val) async {
    interests = val;
    await setValue(INTERESTS, val);
  }

  @action
  Future<void> setLevel(String? val) async {
    level = val;
    await setValue(LEVEL, val);
  }

  @action
  Future<void> setFavorites(List<String>? val) async {
    favorites = val;
    await setValue(FAVORITES, val);
  }

  @action
  Future<void> setImages(List<String>? val) async {
    images = val;
    await setValue(IMAGES, val);
  }

  @action
  Future<void> setPrivates(List<String>? val) async {
    privates = val;
    await setValue(PRIVATES, val);
  }

  @action
  Future<void> setImageUrl(List<String>? val) async {
    imageUrl = val;
    await setValue(IMAGES, val);
  }

  @action
  Future<void> setLastOnline(int? val) async {
    lastOnline = val;
    await setValue(LAST_ONLINE, val);
  }

  @action
  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = darkPrimaryColor;
      appButtonBackgroundColorGlobal = darkPrimaryColor;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
    }
  }

  @action
  Future<void> setTotalScore(String? val) async {
    totalScore = val;
    await setValue(TOTAL_SCORE, val);
  }

  @action
  Future<void> setIsDocumentVerified(bool? val) async {
    isDocumentVerified = val;
    await setValue(IS_DOCUMENT_VERIFIED, val);
  }

}
