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
      // (dio) {
      //   final queryParams = {
      //     'limit': params.limit.toString(),
      //     'page': params.page.toString(),
      //     if (params.status != null) 'status': params.status,
      //     if (params.sectionIds != null && params.sectionIds!.isNotEmpty)
      //       'section_id[]': params.sectionIds,
      //     if (params.search != null && params.search!.isNotEmpty)
      //       'search': params.search,
      //   };

      //   return dio.get(
      //     '$purchasingApiUrl/purchase-order/list',
      //     queryParameters: queryParams,
      //     options: Options(
      //       headers: {
      //         'Authorization': 'Bearer $purchasingApiToken', // Custom Auth
      //       },
      //     ),
      //   );
      // },
      (dio) {
        final queryParams = {
          'limit': params.limit.toString(),
          'page': params.page.toString(),
          if (params.status != null) 'status': params.status,
          if (params.sectionIds != null && params.sectionIds!.isNotEmpty)
            'section_id[]': params.sectionIds,
          if (params.search != null && params.search!.isNotEmpty)
            'search': params.search,
        };
        return dio.get('/purchase-order/list', queryParameters: queryParams);
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
      // return dio.get(
      //   '$purchasingApiUrl/purchase-order/detail/$id', // Full URL
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Bearer $purchasingApiToken', // Custom Auth
      //     },
      //   ),
      // );
      return dio.get('/purchase-order/detail/$id');
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
        // return dio.post(
        //   '$purchasingApiUrl/purchase-order/receive', // Sesuaikan endpoint backend
        //   data: {
        //     'purchase_order_code': poCode,
        //     'purchase_order_detail_id': poDetailId,
        //     // 'user_purchasing_id': userId, // User purchasing ID
        //     'user_purchasing_id': userPurchasingId, // User purchasing ID
        //     'quantity': qty,
        //     'uom_id': uomId,
        //   },
        //   options: Options(
        //     headers: {'Authorization': 'Bearer $purchasingApiToken'},
        //   ),
        // );
        return dio.post(
          '/purchase-order/receive',
          data: {
            'purchase_order_code': poCode,
            'purchase_order_detail_id': poDetailId,
            'user_purchasing_id': userPurchasingId,
            'quantity': qty,
            'uom_id': uomId,
          },
        );
      },
      parse: (data) {
        // Asumsi backend return { "success": true, ... }
        return true;
      },
    );
  }
}
