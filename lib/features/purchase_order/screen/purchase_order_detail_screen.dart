import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart';
import 'package:inventory_sync_apps/features/company_item/screen/company_item_detail_screen.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_list_screen.dart';
import 'package:inventory_sync_apps/features/purchase_order/usecases/get_detail_purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/widget/purchase_item_card.dart';
import 'package:inventory_sync_apps/features/variant/screen/create_variant_screen.dart';

class PurchaseOrderDetailScreen extends StatefulWidget {
  final String poCode;
  const PurchaseOrderDetailScreen({super.key, required this.poCode});

  @override
  State<PurchaseOrderDetailScreen> createState() =>
      _PurchaseOrderDetailScreenState();
}

class _PurchaseOrderDetailScreenState extends State<PurchaseOrderDetailScreen> {
  bool _isLoading = true;
  PurchaseOrder? _purchaseOrder;

  @override
  void initState() {
    super.initState();
    fetchDetailPurchaseOrder();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(_purchaseOrder?.poDate ?? DateTime.now());

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
      builder: (context, sessionState) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            final user = await UserStorage.getUser();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => PurchaseOrderListScreen(
                  userSectionIds:
                      (user!.sections != null && user.sections!.isNotEmpty)
                      ? user.sections!
                            .map((e) => e.idSectionPurchasing.toString())
                            .whereType<String>() // buang null
                            .toList()
                      : [],
                ),
              ),
              (route) => route.isFirst,
            );
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 1,
              leading: CustomBackButton(),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, thickness: 1),
              ),
              title: Text(
                'Detail Pembelian',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(width: 1.0, color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _purchaseOrder?.purchaseOrderCode ?? '',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      _purchaseOrder?.supplierName ?? '',
                                      style: TextStyle(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    RichText(
                                      text: TextSpan(
                                        style: AppTextStyles.mono.copyWith(
                                          fontSize: 11,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Tanggal PO:  ',
                                            style: TextStyle(
                                              color: AppColors.onMuted,
                                            ),
                                          ),
                                          TextSpan(
                                            text: formattedDate,
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: AppTextStyles.mono.copyWith(
                                          fontSize: 11,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Pengiriman:  ',
                                            style: TextStyle(
                                              color: AppColors.onMuted,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                _purchaseOrder?.delivery ?? '-',
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${_purchaseOrder?.totalItemReceived ?? 0}/${_purchaseOrder?.totalItem ?? 0}',
                                    style: TextStyle(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'ITEM',
                                    style: TextStyle(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value:
                                (_purchaseOrder?.totalItemReceived ?? 0) /
                                (_purchaseOrder?.totalItem ?? 0),
                            color: AppColors.success,
                            backgroundColor: Colors.grey[300],
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      'ITEM UNTUK DIPROSES',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      spacing: 10,
                      children: [
                        SizedBox(height: 2),
                        if (_purchaseOrder?.items != null)
                          for (var item in _purchaseOrder!.items!)
                            PurchaseItemCard(
                              item: item,
                              onTap: () async {
                                User _user = (await UserStorage.getUser())!;
                                if ((item.sisa ?? 0) <= 0) {
                                  CustomToast.warning(
                                    context,
                                    title:
                                        'Item ini sudah diterima sepenuhnya.',
                                  );
                                  return;
                                }

                                // 2. Tampilkan Loading saat cek DB lokal (Optional tapi bagus utk UX)
                                LoadingOverlay.show(context);

                                final companyItem = await context
                                    .read<InventoryRepository>()
                                    .getCompanyItemByCompanyCode(
                                      item.itemCode ?? '',
                                    );

                                LoadingOverlay.hide();

                                if (companyItem != null) {
                                  // 3. ITEM ADA -> Start Session
                                  context
                                      .read<ReceivingSessionCubit>()
                                      .startSession(
                                        poNumber: item
                                            .purchaseOrderCode!, // Pastikan field ini ada di PurchaseOrderItem
                                        poDetailId: item.purchaseOrderDetailId!,
                                        itemCode: item.itemCode!,
                                        itemName: item.itemName!,
                                        qtyRemaining: item.sisa!,
                                        purchasingUomId: item.uomId!,
                                        purchasingUomName: item.uomName!,
                                        setPrice: item.price!,
                                      );

                                  dev.log('po uom id: ${item.uomId}');

                                  // 4. Navigate ke Company Item Detail (Bypass search screen)
                                  if (companyItem.totalVariants > 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompanyItemDetailScreen(
                                              companyItemId:
                                                  companyItem.companyItemId,
                                            ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateVariantScreen(
                                              userId: _user.id!,
                                              companyItemId:
                                                  companyItem.companyItemId,
                                              isSetUp: true,
                                              companyCode:
                                                  companyItem.companyCode,
                                              productName:
                                                  companyItem.productName,
                                              defaultRackId:
                                                  companyItem.defaultRackId,
                                              defaultRackName:
                                                  companyItem.defaultRackName,
                                              purchasingUomId: item.uomId
                                                  .toString(),
                                            ),
                                      ),
                                    );
                                  }
                                } else {
                                  // 4. ITEM TIDAK ADA
                                  CustomToast.error(
                                    context,
                                    title: 'Item Tidak Ditemukan',
                                    description:
                                        'Item ${item.itemCode} belum disinkronisasi. Silakan sync data master.',
                                  );
                                }
                              },
                            ),
                        // PurchaseItemCard(
                        //   itemCode: 'TEC-M-SP-0089',
                        //   itemName: 'Bearing',
                        //   total: 12,
                        //   current: 10,
                        //   uom: 'pcs',
                        // ),
                        // PurchaseItemCard(
                        //   itemCode: 'TEC-M-SP-0089',
                        //   itemName: 'Bearing',
                        //   total: 12,
                        //   current: 10,
                        //   uom: 'pcs',
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchDetailPurchaseOrder() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    GetDetailPurchaseOrder useCase = GetDetailPurchaseOrder();
    await useCase(widget.poCode).then((result) {
      if (result.isSuccess) {
        _isLoading = false;

        _purchaseOrder = result.resultValue;
      } else {
        CustomToast.warning(context, description: result.errorMessage);
        Navigator.pop(context);
      }
    });

    if (mounted) {
      setState(() {});
    }
  }
}
