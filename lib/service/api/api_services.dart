// import 'dart:async';

// import 'package:better_help/service/api/api.dart';
// import 'package:better_help/service/storage_services/storage_services.dart';
// import 'package:core_kit/core_kit.dart';
// import 'package:core_kit/network/request_input.dart';

// class ApiServices {
//   ///////////////
//   ApiServices._privateConstructor();

//   static final ApiServices _instance = ApiServices._privateConstructor();

//   static ApiServices get instance => _instance;

//   //////////  object
//   final api = AppApi();
//   final storageServices = StorageService();

//   // Future<ResponseState<dynamic>> apiPostServices({
//   //   required String url,
//   //   dynamic body,
//   //   Map<String, String>? header,
//   //   // Options? options,
//   // }) async {
//   //   return DioService.instance.request(
//   //     input: RequestInput(
//   //       endpoint: url,
//   //       jsonBody: body,
//   //       headers: header,
//   //       method: .POST,
//   //     ),
//   //     responseBuilder: (response) {
//   //       return response;
//   //     },
//   //   );
//   // }

//   Future<ResponseState<dynamic>> apiGetServices(
//     String url, {
//     int statusCode = 200,
//   }) async {
//     return DioService.instance.request(
//       input: RequestInput(endpoint: url, method: .GET),
//       responseBuilder: (response) {
//         return response;
//       },
//     );
//   }

//   // Future<dynamic> apiPatchServices({
//   //   required String url,
//   //   Map<String, dynamic>? body,
//   //   int statusCode = 200,
//   //   Map<String, dynamic>? query,
//   //   Options? options,
//   // }) async {
//   //   return DioService.instance.request(
//   //     input: RequestInput(
//   //       endpoint: url,
//   //       jsonBody: body,
//   //       queryParams: query,
//   //       headers: options?.headers?.map(
//   //         (key, value) => MapEntry(key, value.toString()),
//   //       ),
//   //       method: .PATCH,
//   //     ),
//   //     responseBuilder: (response) {
//   //       return response;
//   //     },
//   //   );
//   // }

//   Future<dynamic> apiDeleteServices({
//     required String url,
//     Object? body,
//     int statusCode = 200,
//     Map<String, dynamic>? query,
//     // Options? options,
//     // String? token,
//   }) async {
//     return DioService.instance.request(
//       input: RequestInput(endpoint: url, queryParams: query, method: .DELETE),
//       responseBuilder: (response) {
//         return response;
//       },
//     );
//   }
// }
