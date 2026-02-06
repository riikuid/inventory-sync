import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_date_format.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import 'package:inventory_sync_apps/features/unit/bloc/unit_detail_cubit.dart';
import 'package:inventory_sync_apps/features/variant/screen/variant_detail_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UnitDetailScreen extends StatelessWidget {
  final String unitId;
  const UnitDetailScreen({super.key, required this.unitId});

  @override
  Widget build(BuildContext context) {
    final labelingRepo = context.read<LabelingRepository>();

    return BlocProvider(
      create: (_) {
        final cubit = UnitDetailCubit(labelingRepo: labelingRepo);
        cubit.watchDetail(unitId);
        return cubit;
      },
      child: _UnitDetailView(),
    );
  }
}

class _UnitDetailView extends StatefulWidget {
  const _UnitDetailView({super.key});

  @override
  State<_UnitDetailView> createState() => __UnitDetailViewState();
}

class __UnitDetailViewState extends State<_UnitDetailView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitDetailCubit, UnitDetailState>(
      listener: (ctx, state) {
        if (state is UnitDetailLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state is UnitDetailError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      builder: (ctx, state) {
        if (state is UnitDetailLoading || state is UnitDetailInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is UnitDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        if (state is UnitDetailLoaded) {
          final d = state.detail;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              iconTheme: IconThemeData(color: AppColors.onSurface),
              backgroundColor: AppColors.background,
              leading: CustomBackButton(),
              title: Text(
                'Detail Unit',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              foregroundColor: Colors.transparent,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, thickness: 1),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(width: 1.2, color: AppColors.border),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [AppStyle.defaultBoxShadow],
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: AppColors.primary,
                          strokeWidth: 1,
                          dashPattern: [8, 4],
                          radius: Radius.circular(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: PrettyQrView.data(data: d.unit.qrValue),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // top row: code and badge stock
                            Row(
                              spacing: 3,
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: AppColors.primary,
                                  size: 14,
                                ),
                                Expanded(
                                  child: Text(
                                    'Kode Label',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 6),
                            Text(
                              d.unit.id,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: getUnitStatusColor(
                                  d.unit.status,
                                ).withAlpha(50),
                                border: Border.all(
                                  width: 0.5,
                                  color: getUnitStatusColor(d.unit.status),
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                getUnitStatus(d.unit.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: getUnitStatusColor(d.unit.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // VARINAT SECTION
                CustomButton(
                  padding: EdgeInsets.all(16),
                  elevation: 0.5,
                  color: Colors.white,
                  borderColor: AppColors.border,
                  radius: 20,
                  borderWidth: 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: AppColors.onSecondary,
                          ),
                          Text(
                            'Variant',
                            style: TextStyle(
                              color: AppColors.onSecondary,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: AppColors.onSurface,
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Column(
                        // spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.companyItem?.companyCode ?? '-',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            d.variant?.name ?? '-',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),

                          // SizedBox(height: 5),
                          if (d.variant?.manufCode != null &&
                              d.variant!.manufCode!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 2,
                              ),
                              margin: EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                border: Border.all(
                                  width: 1.0,
                                  color: AppColors.border,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                d.variant?.manufCode ?? '-',
                                // "d.variant?.manufCode ?? '-'",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  onPressed: () async {
                    User _user = (await UserStorage.getUser())!;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VariantDetailScreen(
                          variantId: d.unit.variantId!,
                          userId: _user.id!,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                // QUANTITY SECTION
                Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [AppStyle.defaultBoxShadow],
                        ),
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // top row: code and badge stock
                            Row(
                              spacing: 3,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  'Quantity',
                                  style: TextStyle(
                                    color: AppColors.onSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text: d.unit.quantity.toString(),
                                style: AppTextStyles.mono.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' ${d.uom.name}',
                                    style: AppTextStyles.mono.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [AppStyle.defaultBoxShadow],
                        ),
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // top row: code and badge stock
                            Row(
                              spacing: 3,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  'Lokasi',
                                  style: TextStyle(
                                    color: AppColors.onSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text: d.rack?.name ?? '-',
                                style: AppTextStyles.mono.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),

                            // const SizedBox(height: 6),
                            // Text(
                            //   d.unit.quantity.toString(),
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.w700,
                            //     color: AppColors.onSurface,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(width: 1.2, color: AppColors.border),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [AppStyle.defaultBoxShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Label',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 20),
                      informationRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Dibuat',
                        value:
                            CustomDateFormat.toYmdHis(d.unit.createdAt) ?? '-',
                      ),
                      SizedBox(height: 5),
                      informationRow(
                        icon: Icons.receipt_long_outlined,
                        label: 'Nomor PO',
                        value: d.unit.poNumber ?? '-',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold(body: Center(child: Text('Terjadi Kesalahan!')));
      },
    );
  }

  Widget informationRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Icon(icon, size: 14, color: AppColors.onMuted),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.onSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.onSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Divider(height: 25, color: AppColors.border, thickness: 0.7),
      ],
    );
  }

  Color getUnitStatusColor(int status) {
    switch (status) {
      case pendingStatus:
        return Colors.orange;
      case activeStatus:
        return Colors.green;
      case consumedStatus || deletedStatus:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getUnitStatus(int status) {
    switch (status) {
      case pendingStatus:
        return 'PENDING';
      case activeStatus:
        return 'AKTIF';
      case consumedStatus:
        return 'DIGUNAKAN';
      case deletedStatus:
        return 'DIHAPUS';
      default:
        return '-';
    }
  }
}
