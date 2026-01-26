import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/dio_call.dart';
import 'package:inventory_sync_apps/core/result.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/usecases/get_purchase_orders/get_purchase_orders.dart';

class PurchaseOrderService {
  Future<Result<List<PurchaseOrder>>> getPurchaseOrders(
    GetPurchaseOrdersParams params,
  ) async {
    final result = await dioCall<List<PurchaseOrder>>(
      (dio) {
        final queryParams = {
          'limit': params.limit.toString(),
          'page': params.page.toString(),
          if (params.status != null) 'status': params.status,
          // if (params.sectionIds != null && params.sectionIds!.isNotEmpty)
          //   'section_id[]': params.sectionIds,
          if (params.search != null && params.search!.isNotEmpty)
            'search': params.search,
        };

        return dio.get(
          '$purchasingApiUrl/purchase-order/list', // Full URL
          queryParameters: queryParams,
          options: Options(
            headers: {
              'Authorization': 'Bearer $purchasingApiToken', // Custom Auth
            },
          ),
        );
      },
      parse: (data) {
        return (data['data'] as List)
            .map((item) => PurchaseOrder.fromJson(item))
            .toList();
      },
    );
    return result;
  }

  Future<Result<PurchaseOrder>> getDetailPurchaseOrder(String id) async {
    return dioCall<PurchaseOrder>((dio) {
      return dio.get(
        '$purchasingApiUrl/purchase-order/detail/$id', // Full URL
        options: Options(
          headers: {
            'Authorization': 'Bearer $purchasingApiToken', // Custom Auth
          },
        ),
      );
    }, parse: (data) => PurchaseOrder.fromJson(data['data']));
  }

  Future<Result<bool>> receiveItem({
    required String poCode,
    required int poDetailId,
    required int? userPurchasingId,
    required int qty, // Total quantity (Batch * Content)
    required int uomId,
  }) async {
    return dioCall<bool>(
      (dio) {
        return dio.post(
          '$purchasingApiUrl/purchase-order/receive', // Sesuaikan endpoint backend
          data: {
            'purchase_order_code': poCode,
            'purchase_order_detail_id': poDetailId,
            // 'user_purchasing_id': userId, // User purchasing ID
            'user_purchasing_id': 9, // User purchasing ID
            'quantity': qty,
            'uom_id': uomId,
          },
          options: Options(
            headers: {'Authorization': 'Bearer $purchasingApiToken'},
          ),
        );
      },
      parse: (data) {
        // Asumsi backend return { "success": true, ... }
        return true;
      },
    );
  }

  // Future<Result<List<SubmissionModel>>> getAllSubmissions(
  //   GetSubmissionsParams params,
  // ) async {
  //   final queryParams = {
  //     'per_page': params.perPage.toString(),
  //     'page': params.page.toString(),
  //     if (params.status != null) 'status': params.status,
  //     if (params.startDate != null) 'start_date': params.startDate,
  //     if (params.endDate != null) 'end_date': params.endDate,
  //   };

  //   final result = await dioCall<List<SubmissionModel>>(
  //     (dio) => dio.get('/hris/submissions', queryParameters: queryParams),
  //     parse: (data) {
  //       return (data['data'] as List)
  //           .map((item) => SubmissionModel.fromJson(item))
  //           .toList();
  //     },
  //   );
  //   return result;
  // }

  // Future<Result<List<SubmissionModel>>> getMySubmissions(
  //   GetSubmissionsParams params,
  // ) async {
  //   final result = await dioCall<List<SubmissionModel>>(
  //     (dio) => dio.get(
  //       '/hris/submissions/me?per_page=${params.perPage}&page=${params.page}',
  //     ),
  //     parse: (data) {
  //       return (data['data'] as List)
  //           .map((item) => SubmissionModel.fromJson(item))
  //           .toList();
  //     },
  //   );
  //   return result;
  // }

  // Future<Result<SubmissionModel>> approveSubmission(String id) {
  //   return dioCall<SubmissionModel>(
  //     (d) => d.patch('/service/work-order/$id/approve'),
  //     parse: (data) => SubmissionModel.fromJson(data['data']),
  //   );
  // }

  // Future<Result<SubmissionModel>> rejectSubmission(String id) {
  //   return dioCall<SubmissionModel>(
  //     (d) => d.patch('/service/work-order/$id/reject'),
  //     parse: (data) => SubmissionModel.fromJson(data['data']),
  //   );
  // }

  // Future<Result<Response>> storeSubmission(StoreSubmissionParams params) {
  //   return dioCall<Response>((d) async {
  //     final Map<String, dynamic> jsonBody = {
  //       'user_submission_id': params.typeId,
  //       'start_date': params.startDate,
  //       'end_date': params.endDate,
  //       'start_time': params.startTime,
  //       'end_time': params.endTime,
  //       'time_only': params.timeOnly,
  //       'description': params.description,
  //     }..removeWhere((p, v) => v == null);

  //     final hasFile =
  //         params.attachmentPath != null && params.attachmentPath!.isNotEmpty;

  //     if (hasFile) {
  //       final form = dio.FormData.fromMap({
  //         ...jsonBody,
  //         'attachment': await dio.MultipartFile.fromFile(
  //           params.attachmentPath!,
  //           filename: basename(params.attachmentPath!),
  //         ),
  //       });

  //       return d.post(
  //         '/hris/submissions',
  //         data: form,
  //         // , onSendProgress: (sent, total) { /* kalau perlu progress */ }
  //       );
  //     } else {
  //       return d.post('/hris/submissions', data: jsonBody);
  //     }
  //   }, parse: (data) => Response.fromJson(data));
  // }
}
