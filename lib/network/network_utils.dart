import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart' hide isNetworkAvailable;
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';

isNetworkAvailable() async {
  return await Rks().netChecker();
}

Map<String, String> buildHeaderTokens({bool isStripePayment = false, Map? request}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (appStore.isLoggedIn && isStripePayment) {
    //String formBody = Uri.encodeQueryComponent(jsonEncode(request));
    //List<int> bodyBytes = utf8.encode(formBody);

    header.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => 'Bearer $getStringAsync("StripeKeyPayment")');
  } else {
    header.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  }

  //log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

  return url;
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET,
    Map? request,
    bool isStripePayment = false}) async {
  print(endPoint);
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(isStripePayment: isStripePayment, request: request);
    Uri url = buildBaseUrl(endPoint);
    Response response;

    if (method == HttpMethod.POST) {
      ;
      // myprintnet('Request: $request');
      print(url);
      print(headers);
      response = await http.post(
        url,
        body: jsonEncode(request),
        headers: headers,
        encoding: isStripePayment ? Encoding.getByName("utf-8") : null,
      );
      print(response.body);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    return response;
  } else {
    toast(errorInternetNotAvailable.tr());

    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  print("responce handle.........");
  print(response.body);
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);
    throw 'Token Expired';
  }
  String? uri_path = response.request?.url.path;
  final Map<String, dynamic> decoded = jsonDecode(response.body);
  if (response.statusCode == 400 || response.statusCode == 404) {
    const formErrors = [
      "/api/register",
      "/api/login",
    ];

    if (formErrors.contains(uri_path)) {
      final Map<String, dynamic> errors = decoded;
      errors.forEach((key, value) {
        showToast(value,
            context: Rks.context,
            animation: StyledToastAnimation.slideFromLeft,
            reverseAnimation: StyledToastAnimation.slideToTop,
            fullWidth: true,
            position: StyledToastPosition.top,
            animDuration: Duration(seconds: 1),
            duration: Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.linear,
            textStyle: TextStyle(
                color: Rks.toastcolor!.containsKey("c")
                    ? Rks.toastcolor!["c"]
                    : primaryColor),
            backgroundColor:
                Rks.toastcolor!.containsKey("b") ? Rks.toastcolor!["b"] : whiteColor);
      });
    }
  }

  if (decoded.containsKey('message') &&
      !([
        "/api/message",
      ].contains(uri_path))) {
    showToast(decoded['message'],
        context: Rks.context,
        animation: StyledToastAnimation.slideFromLeft,
        reverseAnimation: StyledToastAnimation.slideToTop,
        fullWidth: true,
        position: StyledToastPosition.top,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        textStyle: TextStyle(
            color:
                Rks.toastcolor!.containsKey("c") ? Rks.toastcolor!["c"] : primaryColor),
        backgroundColor:
            Rks.toastcolor!.containsKey("b") ? Rks.toastcolor!["b"] : whiteColor);
  }
  if (response.statusCode.isSuccessful()) {
    return decoded;
  } else {
    try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e, stack) {
      log(e);
      log(stack);

      throw errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess,
      Function(dynamic)? onError,
      Function(int bytes, int totalBytes)? onProgress}) async
{
  final client = http.Client();
  try {
    // Calculate boundary and total bytes
    final boundary = '----${DateTime.now().millisecondsSinceEpoch}';
    final encoder = utf8.encoder;
    int totalBytes = 0;

    // Calculate fields size
    for (final field in multiPartRequest.fields.entries) {
      totalBytes += encoder.convert('--$boundary\r\n').length;
      totalBytes += encoder.convert('Content-Disposition: form-data; name="${field.key}"\r\n\r\n').length;
      totalBytes += encoder.convert(field.value).length;
      totalBytes += encoder.convert('\r\n').length;
    }

    // Calculate files size
    for (final file in multiPartRequest.files) {
      totalBytes += encoder.convert('--$boundary\r\n').length;
      totalBytes += encoder.convert('Content-Disposition: form-data; name="${file.field}"; filename="${file.filename}"\r\n').length;
      totalBytes += encoder.convert('Content-Type: ${file.contentType}\r\n\r\n').length;
      totalBytes += file.length;
      totalBytes += encoder.convert('\r\n').length;
    }
    totalBytes += encoder.convert('--$boundary--\r\n').length;

    // Create request
    final request = http.StreamedRequest(
      multiPartRequest.method,
      multiPartRequest.url,
    )..headers.addAll({
      ...multiPartRequest.headers,
      'Content-Type': 'multipart/form-data; boundary=$boundary',
      'Content-Length': totalBytes.toString(),
    });

    // Track progress
    int bytesUploaded = 0;
    final bytesStream = StreamController<List<int>>();

    // Helper function to add data and track progress
    void addData(List<int> data) {
      bytesUploaded += data.length;
      if (onProgress != null) onProgress(bytesUploaded, totalBytes);
      request.sink.add(data);
    }

    // Add fields
    for (final field in multiPartRequest.fields.entries) {
      final part = encoder.convert(
          '--$boundary\r\n'
              'Content-Disposition: form-data; name="${field.key}"\r\n\r\n'
              '${field.value}\r\n'
      );
      addData(part);
    }

    // Add files
    for (final file in multiPartRequest.files) {
      final header = encoder.convert(
          '--$boundary\r\n'
              'Content-Disposition: form-data; name="${file.field}"; filename="${file.filename}"\r\n'
              'Content-Type: ${file.contentType}\r\n\r\n'
      );
      addData(header);

      // Add file content
      final fileStream = file.finalize();
      await for (final chunk in fileStream) {
        addData(chunk);
      }

      // Add footer
      addData(encoder.convert('\r\n'));
    }

    // Add final boundary
    addData(encoder.convert('--$boundary--\r\n'));

    // Close the request sink
    request.sink.close();

    // Send the request
    final response = await client.send(request);

    // Process response
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode.isSuccessful()) {
      onSuccess?.call(responseBody);
    } else {
      onError?.call(errorSomethingWentWrong);
    }
  } catch (e) {
    onError?.call(e.toString());
  } finally {
    client.close();
  }
}


// Future<void> sendMultiPartRequest(
//   MultipartRequest multiPartRequest, {
//   Function(dynamic)? onSuccess,
//   Function(dynamic)? onError,
//   Function(int bytes, int totalBytes)? onProgress}) async
// {
//   final client = http.Client();
//   try {
//     // Create a streamed response
//     final streamedResponse = await multiPartRequest.send();
//
//     // Track progress
//     int totalBytes = multiPartRequest.contentLength;
//     int receivedBytes = 0;
//
//     streamedResponse.stream.listen(
//       (List<int> chunk) {
//         receivedBytes += chunk.length;
//         if (totalBytes != -1) {
//           double progress = receivedBytes / totalBytes;
//           print("Upload progress: ${(progress * 100).toStringAsFixed(1)}%");
//           onProgress?.call(progress); // Call progress callback
//         }
//       },
//       onDone: () async {
//         // Get the response
//         final response = await http.Response.fromStream(streamedResponse);
//
//         if (response.statusCode.isSuccessful()) {
//           onSuccess?.call(response.body);
//         } else {
//           onError?.call(errorSomethingWentWrong);
//         }
//       },
//       onError: (error) {
//         onError?.call(error.toString());
//       },
//     );
//   } catch (e) {
//     onError?.call(e.toString());
//   }
// }





// Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
//     {Function(dynamic)? onSuccess,
//     Function(dynamic)? onError,
//     Function(double)? onProgress}) async {
//   http.Response response = await http.Response.fromStream(await multiPartRequest.send());
//   print("Result: ${response.statusCode}");
//
//   if (response.statusCode.isSuccessful()) {
//     onSuccess?.call(response.body);
//   } else {
//     onError?.call(errorSomethingWentWrong);
//   }
// }

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }
//endregion
