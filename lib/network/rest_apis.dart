import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart' hide isNetworkAvailable;
import 'package:tharkyApp/Screens/auth/login.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/base_response_model.dart';
import 'package:tharkyApp/models/country_list_model.dart';
import 'package:tharkyApp/models/login_model.dart';
import 'package:tharkyApp/models/media_model.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/room_response_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/network_utils.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';

isNetworkAvailable() async {
  return await Rks().netChecker();
}

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  print("model data save....");
  return LoginResponse.fromJson(await (handleResponse(
      await buildHttpResponse('register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(
      isSocialLogin ? 'social-login' : 'login',
      request: request,
      method: HttpMethod.POST)));
  if (!isSocialLogin) await appStore.setLoginType(LOGIN_TYPE_USER);
  return res;

}

Future<BaseResponseModel> verifyCredential(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('auth/code', request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> verifyCode(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('auth/verify', request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> ratethepost(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/post/rate', request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> likeunlike(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('post/likeunlike',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> havepurchased(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('payements/havepurchased',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('auth/change', request: request, method: HttpMethod.POST)));
}

//region Review Api
Future<LoginResponse> edituser(Map request) async {
  return LoginResponse.fromJson(await handleResponse(
      await buildHttpResponse('/user/edit', request: request, method: HttpMethod.POST)));
}

Future<LoginResponse> editsettings(Map request) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse(
      '/user/setting',
      request: request,
      method: HttpMethod.POST)));
}

Future<BaseResponseModel> getplaces(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'map/search?city=${request["city"]}',
      request: request,
      method: HttpMethod.GET)));
}

Future<BaseResponseModel> reverseplace(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'map/reverse?lat=${request["lat"]}&lon=${request["lon"]}',
      request: request,
      method: HttpMethod.GET)));
}

Future<BaseResponseModel> updateImages(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      '/user/updateImages',
      request: request,
      method: HttpMethod.POST)));
}

Future<Meeting> getMeetingRoom(Map request) async {
  return Meeting.fromJson(await handleResponse(
      await buildHttpResponse('meeting/get', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> postCall(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'meeting/call',
      request: request,
      method: HttpMethod.POST)));
}

Future<User> getUser({String? userId = "0"}) async {
  return User.fromJson(await handleResponse(
      await buildHttpResponse('get-user?id=$userId', method: HttpMethod.POST)));
}

Future<RoomResponseModel> createRoom(Map request) async {
  return RoomResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(request: request, 'room/create', method: HttpMethod.POST)));
}

Future<BaseResponseModel> readMessage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(request: request, 'room/read', method: HttpMethod.POST)));
}

Future<BaseResponseModel> markNotifAsRead(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      request: request, 'notification/read', method: HttpMethod.POST)));
}

Future<BaseResponseModel> istyping(Map request) async {
  try {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(request: request, 'typing', method: HttpMethod.POST)));
  } catch (e) {
    return BaseResponseModel.fromJson({});
  }
}

Future<BaseResponseModel> postofferCandidates(Map request) async {
  try {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
        request: request, 'offerCandidates', method: HttpMethod.POST)));
  } catch (e) {
    inspect(e);
    return BaseResponseModel.fromJson({});
  }
}

Future<SendMessageResponse> sendmessage(Map request) async {
  return SendMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse(request: request, 'message', method: HttpMethod.POST)));
}

Future<List<CountryListResponse>> fetchLanguages({int? userId = 0}) async {
  Iterable res =
      await (handleResponse(await buildHttpResponse('language', method: HttpMethod.GET)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<BaseResponseModel> fetchRanking() async {
  return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('leadboard', method: HttpMethod.GET)));
}

Future<BaseResponseModel> fetchSecring() async {
  return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('orders', method: HttpMethod.GET)));
}

Future<BaseResponseModel> getusers({int? userId = 0}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('fake/${userId}/CheckedUser', method: HttpMethod.GET)));
}

Future<BaseResponseModel> getmynotifications({
  int? userId = 0,
  String? first = "",
}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'fake/${userId}/notifications?cursor=$first',
      method: HttpMethod.GET)));
}

Future<BaseResponseModel> getusersmy(
    {int? userId = 0, String? start, String? limit}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'fake/${userId}/getusersmy?start=${start}&limit=${limit}',
      method: HttpMethod.GET)));
}

Future<ImageModel> gepost({String id = ""}) async {
  return ImageModel.fromJson(await handleResponse(
      await buildHttpResponse('media/${id}', method: HttpMethod.GET)));
}

Future<BaseResponseModel> getmatches() async {
  return BaseResponseModel.fromJson(await (handleResponse(
      await buildHttpResponse('fake/matchables', method: HttpMethod.GET))));
}

Future<BaseResponseModel> mygetMoreMessages(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      request: request, 'rooms/getmessages', method: HttpMethod.POST)));
}

Future<BaseResponseModel> closeCall(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      request: request, 'meeting/close', method: HttpMethod.POST)));
}

Future<BaseResponseModel> postAnswer(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      request: request, 'meeting/answer', method: HttpMethod.POST)));
}

Future<BaseResponseModel> getItemsAccess() async {
  return BaseResponseModel.fromJson(await (handleResponse(
      await buildHttpResponse('item/access', method: HttpMethod.GET))));
}

// Future<List<BookingStatusResponse>> bookingStatus() async {
//   Iterable res = await (handleResponse(
//       await buildHttpResponse('booking-status', method: HttpMethod.GET)));
//   return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
// }
// //endregion
Future<void> saveUserData(User data, {String? token}) async {
  if (token.validate().isNotEmpty) await appStore.setToken(token!);

  await appStore.setUserId(data.id.validate());
  await appStore.set_id(data.iid.validate());

  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.name.validate());
  await appStore.setAddress(data.address.validate());

  // Add this line to save totalScore
  await appStore.setTotalScore(data.totalScore.validate());

  await appStore.setIsDocumentVerified(data.isDocumentVerified.validate());

  // Coordinates
  if (data.coordinates != null) {
    final rawCoordinates = data.coordinates as Map<dynamic, dynamic>;
    final formattedCoordinates = ObservableMap<String, String>.of(
      rawCoordinates.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
    );
    await appStore.setCoordinates(formattedCoordinates);
  }

  await appStore.setImageUrl(data.imageUrl.validate());
  await appStore.setPhoneNumber(data.phoneNumber.validate());
  await appStore.setGender(data.gender.validate());
  await appStore.setShowGender(data.showGender.validate());
  await appStore.setShowInterests(data.showInterests.validate());

  // Age range
  if (data.ageRange != null) {
    final rawAgeRange = data.ageRange as Map<dynamic, dynamic>;
    final formattedAgeRange = rawAgeRange.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await appStore.setAgeRange(formattedAgeRange);
  } // Age range
  if (data.meta != null) {
    final meta = data.meta as Map<dynamic, dynamic>;
    final formattedmeta = meta.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await appStore.setMeta(formattedmeta);
  }

  await appStore.setMaxDistance(data.maxDistance.validate());
  await appStore.setAbout(data.about.validate());

  // Last online
  if (data.lastOnline != null) {
    await appStore.setLastOnline(data.lastOnline?.millisecondsSinceEpoch);
  }

  // Lists
  await appStore.setFavorites(
    (data.favorites ?? []).map((e) => e.toString()).toList(),
  );
  await appStore.setImages(
    (data.images ?? []).map((e) => e.toString()).toList(),
  );
  await appStore.setPrivates(
    (data.privates ?? []).map((e) => e.toString()).toList(),
  );
  await appStore.setInterests(
    (data.interests ?? []).map((e) => e.toString()).toList(),
  );

  await appStore.setLevel(data.level.validate());
  appStore.setLoggedIn(true);
}

Future<void> clearPreferences() async {
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');

  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');

  await appStore.setTotalScore('');

  await appStore.setIsDocumentVerified(false);

  await appStore.setUId('');
  await appStore.setLatitude(0.0);
  await appStore.setLongitude(0.0);
  await appStore.setCurrentAddress('');

  await appStore.setToken('');
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setHelplineNumber('');

  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Container(
        color: whiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Do you want to logout your account ?", style: boldTextStyle()),
            28.height,
            Row(
              children: [
                AppButton(
                  child: Text("No", style: boldTextStyle(color: blackColor)),
                  elevation: 0,
                  onTap: () {
                    simulateScreenTap();
                  },
                ).expand(),
                16.width,
                AppButton(
                  child: Text("yes", style: boldTextStyle(color: blackColor)),
                  elevation: 0,
                  onTap: () async {
                    appStore.setLoading(true);
                    await clearPreferences();
                    appStore.setLoading(false);
                    simulateScreenTap();
                    finish(context);

                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => Login()),
                    );

                    return 1;
                  },
                ).expand(),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 24),
      );
    },
  );
}

Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethod.GET));
}

// Future<BaseResponseModel> forgotPassword(Map request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('forgot-password',
//           request: request, method: HttpMethod.POST)));
// }

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      'delete-user-account',
      request: {},
      method: HttpMethod.POST)));
}

// //endregion

// //region Country Api
// Future<List<CountryListResponse>> getCountryList() async {
//   Iterable res = await (handleResponse(
//       await buildHttpResponse('country-list', method: HttpMethod.POST)));
//   return res.map((e) => CountryListResponse.fromJson(e)).toList();
// }

// Future<List<StateListResponse>> getStateList(Map request) async {
//   Iterable res = await (handleResponse(await buildHttpResponse('state-list',
//       request: request, method: HttpMethod.POST)));
//   return res.map((e) => StateListResponse.fromJson(e)).toList();
// }

// Future<List<CityListResponse>> getCityList(Map request) async {
//   Iterable res = await (handleResponse(await buildHttpResponse('city-list',
//       request: request, method: HttpMethod.POST)));
//   return res.map((e) => CityListResponse.fromJson(e)).toList();
// }
// //endregion

// //region User Api
// Future<DashboardResponse> userDashboard(
//     {bool isCurrentLocation = false, double? lat, double? long}) async {
//   appStore.setLoading(true);
//   DashboardResponse? _dashboardResponse;

//   /// If any below condition not satisfied, call this
//   String endPoint = 'dashboard-detail';

//   if (isCurrentLocation &&
//       appStore.isLoggedIn &&
//       appStore.userId.validate() != 0) {
//     endPoint =
//         "$endPoint?latitude=$lat&longitude=$long&?customer_id=${appStore.userId.validate()}}";
//   } else if (isCurrentLocation) {
//     endPoint = "$endPoint?latitude=$lat&longitude=$long";
//   } else if (appStore.isLoggedIn && appStore.userId.validate() != 0) {
//     endPoint = "$endPoint?customer_id=${appStore.userId.validate()}";
//   }

//   _dashboardResponse = DashboardResponse.fromJson(await handleResponse(
//       await buildHttpResponse(endPoint, method: HttpMethod.GET)));

//   if (_dashboardResponse.privacyPolicy != null) {
//     if (_dashboardResponse.privacyPolicy!.value != null) {
//       appStore
//           .setPrivacyPolicy(_dashboardResponse.privacyPolicy!.value.validate());
//     } else {
//       appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
//     }
//   } else {
//     appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
//   }

//   if (_dashboardResponse.termConditions != null) {
//     if (_dashboardResponse.termConditions?.value != null) {
//       appStore.setTermConditions(
//           _dashboardResponse.termConditions!.value.validate());
//     } else {
//       appStore.setTermConditions(TERMS_CONDITION_URL);
//     }
//   } else {
//     appStore.setTermConditions(TERMS_CONDITION_URL);
//   }

//   if (!_dashboardResponse.inquiryEmail.isEmptyOrNull) {
//     appStore.setInquiryEmail(_dashboardResponse.inquiryEmail.validate());
//   } else {
//     appStore.setInquiryEmail(HELP_SUPPORT_URL);
//   }

//   if (!_dashboardResponse.helplineNumber.isEmptyOrNull) {
//     appStore.setHelplineNumber(_dashboardResponse.helplineNumber.validate());
//   } else {
//     appStore.setHelplineNumber(HELP_SUPPORT_URL);
//   }

//   if (_dashboardResponse.languageOption != null) {
//     setValue(SERVER_LANGUAGES,
//         jsonEncode(_dashboardResponse.languageOption!.toList()));
//   }

//   if (_dashboardResponse.configurations
//       .validate()
//       .any((element) => element.type == CONFIGURATION_TYPE_CURRENCY)) {
//     Configuration data = _dashboardResponse.configurations!
//         .firstWhere((element) => element.type == CONFIGURATION_TYPE_CURRENCY);

//     if (data.country!.currencyCode.validate() != appStore.currencyCode)
//       appStore.setCurrencyCode(data.country!.currencyCode.validate());
//     if (data.country!.id.validate().toString() != appStore.countryId.toString())
//       appStore.setCurrencyCountryId(data.country!.id.validate().toString());
//     if (data.country!.symbol.validate() != appStore.currencyCode)
//       appStore.setCurrencySymbol("${data.country!.currencyCode.validate()} ");
//   }

//   if (_dashboardResponse.configurations
//       .validate()
//       .any((element) => element.key == CONFIGURATION_TYPE_CURRENCY_POSITION)) {
//     Configuration data = _dashboardResponse.configurations!.firstWhere(
//         (element) => element.key == CONFIGURATION_TYPE_CURRENCY_POSITION);

//     if (data.value.validate().isNotEmpty) {
//       setValue(CURRENCY_POSITION, data.value);
//     }
//   }

//   if (_dashboardResponse.paymentSettings != null) {
//     setValue(PAYMENT_LIST,
//         PaymentSetting.encode(_dashboardResponse.paymentSettings.validate()));
//   }
//   appStore.setLoading(false);

//   return _dashboardResponse;
// }
// //endregion

// //region Service Api
// Future<ServiceDetailResponse> getServiceDetail(Map request) async {
//   return ServiceDetailResponse.fromJson(await handleResponse(
//       await buildHttpResponse('service-detail',
//           request: request, method: HttpMethod.POST)));
// }

// Future<ServiceDetailResponse> getServiceDetails(
//     {required int serviceId, int? customerId}) async {
//   Map request = {
//     CommonKeys.serviceId: serviceId,
//     if (appStore.isLoggedIn) CommonKeys.customerId: customerId
//   };
//   return ServiceDetailResponse.fromJson(await handleResponse(
//       await buildHttpResponse('service-detail',
//           request: request, method: HttpMethod.POST)));
// }

// Future<JobDetailResponse> getJobOfferDetails(
//     {required int serviceId, int? customerId}) async {
//   Map request = {
//     CommonKeys.jobId: serviceId,
//     if (appStore.isLoggedIn) CommonKeys.customerId: customerId
//   };
//   return JobDetailResponse.fromJson(await handleResponse(
//       await buildHttpResponse('job-detail',
//           request: request, method: HttpMethod.POST)));
// }

// Future<ServiceResponse> getSearchListServices({
//   String categoryId = '',
//   String ctypeId = '',
//   String providerId = '',
//   String handymanId = '',
//   String isPriceMin = '',
//   String isPriceMax = '',
//   String search = '',
//   String latitude = '',
//   String longitude = '',
//   String isFeatured = '',
//   String subCategory = '',
//   int page = 1,
// }) async {
//   String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
//   String typeIds = ctypeId.isNotEmpty ? 'type_id=$ctypeId&' : '';

//   String searchPara = search.isNotEmpty ? 'search=$search&' : '';
//   String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
//   String isPriceMinPara =
//       isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
//   String isPriceMaxPara =
//       isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
//   String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
//   String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
//   String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
//   String subCategorys = subCategory.validate().isNotEmpty
//       ? subCategory != "-1"
//           ? 'subcategory_id=$subCategory&'
//           : ''
//       : '';
//   String pages = 'page=$page&';
//   String perPages = 'per_page=$PER_PAGE_ITEM';

//   return ServiceResponse.fromJson(await handleResponse(
//     await buildHttpResponse(
//         'search-list?$categoryIds$typeIds$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
//   ));
// }

// Future<JobResponse> getSearchListJob({
//   String categoryId = '',
//   String companyId = '',
//   String handymanId = '',
//   String search = '',
//   String latitude = '',
//   String longitude = '',
//   String isFeatured = '',
//   String subCategory = '',
//   int page = 1,
// }) async {
//   String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
//   String searchPara = search.isNotEmpty ? 'search=$search&' : '';
//   String providerIds = companyId.isNotEmpty ? 'company_id=$companyId&' : '';

//   String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
//   String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
//   String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
//   String subCategorys = subCategory.validate().isNotEmpty
//       ? subCategory != "-1"
//           ? 'subcategory_id=$subCategory&'
//           : ''
//       : '';
//   String pages = 'page=$page&';
//   String perPages = 'per_page=$PER_PAGE_ITEM';

//   return JobResponse.fromJson(await handleResponse(
//     await buildHttpResponse(
//         'job-list?$categoryIds$providerIds$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
//   ));
// }

// Future<ServiceResponse> getServiceList(int page,
//     {bool isCurrentLocation = false,
//     String? searchTxt,
//     bool isSearch = false,
//     int? categoryId,
//     bool isCategoryWise = false,
//     int? customerId,
//     double? lat,
//     double? long}) async {
//   if (isCategoryWise) {
//     if (isCurrentLocation) {
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long',
//           method: HttpMethod.GET)));
//     } else {
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&customer_id=$customerId',
//           method: HttpMethod.GET)));
//     }
//   } else if (isSearch) {
//     if (isCurrentLocation)
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&search=$searchTxt&latitude=$lat&longitude=$long',
//           method: HttpMethod.GET)));
//     else
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&search=$searchTxt',
//           method: HttpMethod.GET)));
//   } else {
//     if (isCurrentLocation)
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long',
//           method: HttpMethod.GET)));
//     else
//       return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
//           'service-list?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId',
//           method: HttpMethod.GET)));
//   }
// }
// //endregion

// //region Category Api
// Future<CategoryResponse> getCategoryList(String page, [String? offer]) async {
//   String offeride = offer.validate().isNotEmpty ? 'is_offer=1&' : '';

//   return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse(
//       'category-list?${offeride}page=$page&per_page=$PER_PAGE_ITEM',
//       method: HttpMethod.GET)));
// }

// Future<ExperienceResponse> getExperienceList(String page,
//     [String? offer]) async {
//   String offeride = offer.validate().isNotEmpty ? 'is_offer=1&' : '';

//   return ExperienceResponse.fromJson(await handleResponse(
//       await buildHttpResponse(
//           'experience-list?${offeride}page=$page&per_page=$PER_PAGE_ITEM',
//           method: HttpMethod.GET)));
// }

// Future<EtudeResponse> getEtudeList(String page, [String? offer]) async {
//   String offeride = offer.validate().isNotEmpty ? 'is_offer=1&' : '';

//   return EtudeResponse.fromJson(await handleResponse(await buildHttpResponse(
//       'etude-list?${offeride}page=$page&per_page=$PER_PAGE_ITEM',
//       method: HttpMethod.GET)));
// }

// Future<ProviderTypeResponse> getProviderTypeList(String page,
//     [String? offer]) async {
//   String offeride = offer.validate().isNotEmpty ? 'is_offer=1&' : '';

//   return ProviderTypeResponse.fromJson(await handleResponse(
//       await buildHttpResponse(
//           'providertype-list?${offeride}page=$page&per_page=$PER_PAGE_ITEM',
//           method: HttpMethod.GET)));
// }

// Future<ContratResponse> getContratList(String page, [String? offer]) async {
//   String offeride = offer.validate().isNotEmpty ? 'is_offer=1&' : '';

//   return ContratResponse.fromJson(await handleResponse(await buildHttpResponse(
//       'contrat-list?${offeride}page=$page&per_page=$PER_PAGE_ITEM',
//       method: HttpMethod.GET)));
// }
// //endregion

// //region SubCategory Api
// Future<CategoryResponse> getSubCategoryList({required int catId}) async {
//   return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse(
//       'subcategory-list?category_id=$catId&per_page=all',
//       method: HttpMethod.GET)));
// }

// Future<CategoryResponse2> getSubCategoryList2({required int catId}) async {
//   return CategoryResponse2.fromJson(await handleResponse(
//       await buildHttpResponse(
//           'subcategory-list?category_id=$catId&per_page=all&format_type=2',
//           method: HttpMethod.GET)));
// }
// //endregion

// //region Provider Api
// Future<ProviderInfoResponse> getProviderDetail(int id) async {
//   return ProviderInfoResponse.fromJson(await handleResponse(
//       await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
// }

// Future<ProviderListResponse> getProvider(
//     {String? userType = "provider"}) async {
//   return ProviderListResponse.fromJson(await handleResponse(
//       await buildHttpResponse('user-list?user_type=$userType&per_page=all',
//           method: HttpMethod.GET)));
// }
// //endregion

// //region Handyman Api
// Future<UserData> getHandymanDetail(int id) async {
//   return UserData.fromJson(await handleResponse(
//       await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
// }

// Future<BaseResponseModel> handymanRating(Map request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('save-handyman-rating',
//           request: request, method: HttpMethod.POST)));
// }
// //endregion

// //region Booking Api
// Future<List<BookingData>> getBookingList(int page,
//     {var perPage = PER_PAGE_ITEM,
//     String status = '',
//     required List<BookingData> bookings,
//     Function(bool)? lastPageCallback}) async {
//   appStore.setLoading(true);
//   BookingListResponse res;

//   if (status == BOOKING_TYPE_ALL) {
//     res = BookingListResponse.fromJson(await handleResponse(
//         await buildHttpResponse('booking-list?&per_page=$perPage&page=$page',
//             method: HttpMethod.GET)));
//   } else {
//     res = BookingListResponse.fromJson(await handleResponse(
//         await buildHttpResponse(
//             'booking-list?status=$status&per_page=$perPage&page=$page',
//             method: HttpMethod.GET)));
//   }

//   if (page == 1) bookings.clear();
//   bookings.addAll(res.data.validate());
//   lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

//   appStore.setLoading(false);

//   return bookings;
// }

// Future<BookingDetailResponse> getBookingDetail(Map request) async {
//   BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
//       await handleResponse(await buildHttpResponse('booking-detail',
//           request: request, method: HttpMethod.POST)));
//   calculateTotalAmount(
//     serviceDiscountPercent: bookingDetailResponse.service!.discount.validate(),
//     qty: bookingDetailResponse.bookingDetail!.quantity!.toInt(),
//     detail: bookingDetailResponse.service,
//     servicePrice: bookingDetailResponse.service!.price.validate(),
//     taxes: bookingDetailResponse.bookingDetail!.taxes.validate(),
//     couponData: bookingDetailResponse.couponData,
//   );
//   return bookingDetailResponse;
// }

// Future<BaseResponseModel> updateBooking(Map request) async {
//   BaseResponseModel baseResponse = BaseResponseModel.fromJson(
//       await handleResponse(await buildHttpResponse('booking-update',
//           request: request, method: HttpMethod.POST)));
//   LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);

//   return baseResponse;
// }

// Future bookTheServices(Map request) async {
//   return await handleResponse(await buildHttpResponse('booking-save',
//       request: request, method: HttpMethod.POST));
// }

// Future<List<BookingStatusResponse>> bookingStatus() async {
//   Iterable res = await (handleResponse(
//       await buildHttpResponse('booking-status', method: HttpMethod.GET)));
//   return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
// }
// //endregion

// //region Payment Api
// Future<BaseResponseModel> savePayment(Map request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('save-payment',
//           request: request, method: HttpMethod.POST)));
// }
// //endregion

// //region Notification Api
// Future<NotificationListResponse> getNotification(Map request,
//     {int? page = 1}) async {
//   return NotificationListResponse.fromJson(await handleResponse(
//       await buildHttpResponse(
//           'notification-list?customer_id=${appStore.userId}',
//           request: request,
//           method: HttpMethod.POST)));
// }
// //endregion

// //region Review Api
// Future<BaseResponseModel> updateReview(Map request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('save-booking-rating',
//           request: request, method: HttpMethod.POST)));
// }

// Future<List<RatingData>> serviceReviews(Map request) async {
//   ServiceReviewResponse res = ServiceReviewResponse.fromJson(
//       await handleResponse(await buildHttpResponse(
//           'service-reviews?per_page=all',
//           request: request,
//           method: HttpMethod.POST)));
//   return res.ratingList.validate();
// }

// Future<List<RatingData>> handymanReviews(Map request) async {
//   ServiceReviewResponse res = ServiceReviewResponse.fromJson(
//       await handleResponse(await buildHttpResponse(
//           'handyman-reviews?per_page=all',
//           request: request,
//           method: HttpMethod.POST)));
//   return res.ratingList.validate();
// }

// Future<BaseResponseModel> deleteReview({required int id}) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('delete-booking-rating',
//           request: {"id": id}, method: HttpMethod.POST)));
// }

// Future<BaseResponseModel> deleteHandymanReview({required int id}) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('delete-handyman-rating',
//           request: {"id": id}, method: HttpMethod.POST)));
// }
// //endregion

// //region WishList Api
// Future<List<ServiceData>> getWishlist(int page,
//     {var perPage = PER_PAGE_ITEM,
//     required List<ServiceData> services,
//     Function(bool)? lastPageCallBack}) async {
//   appStore.setLoading(true);

//   ServiceResponse serviceResponse = ServiceResponse.fromJson(
//       await (handleResponse(await buildHttpResponse(
//           'user-favourite-service?per_page=$perPage&page=$page',
//           method: HttpMethod.GET))));

//   if (page == 1) services.clear();
//   services.addAll(serviceResponse.serviceList.validate());

//   lastPageCallBack
//       ?.call(serviceResponse.serviceList.validate().length != PER_PAGE_ITEM);

//   appStore.setLoading(false);
//   return services;
// }

// Future<BaseResponseModel> addWishList(request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('save-favourite',
//           method: HttpMethod.POST, request: request)));
// }

// Future<BaseResponseModel> removeWishList(request) async {
//   return BaseResponseModel.fromJson(await handleResponse(
//       await buildHttpResponse('delete-favourite',
//           method: HttpMethod.POST, request: request)));
// }
//endregion
