import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_detail_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/receiving_session_banner.dart';
import '../../../core/user_storage.dart';
import '../../../shared/presentation/widgets/primary_button.dart';
import '../../auth/models/user.dart';
import '../../variant/screen/create_variant_screen.dart';
import '../bloc/company_item_detail/company_item_detail_cubit.dart';
import '../../variant/screen/variant_detail_screen.dart';
import 'edit_company_item_screen.dart';

class CompanyItemDetailScreen extends StatefulWidget {
  final String companyItemId;

  const CompanyItemDetailScreen({super.key, required this.companyItemId});

  @override
  State<CompanyItemDetailScreen> createState() =>
      _CompanyItemDetailScreenState();
}

class _CompanyItemDetailScreenState extends State<CompanyItemDetailScreen> {
  late final CompanyItemDetailCubit _cubit;
  bool _hasShownRackDialog = false;

  @override
  void initState() {
    super.initState();
    final repo = context.read<InventoryRepository>();
    _cubit = CompanyItemDetailCubit(repo);
    _cubit.watchDetail(widget.companyItemId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<CompanyItemDetailCubit, CompanyItemDetailState>(
        listener: (context, state) {
          if (state is CompanyItemDetailLoaded &&
              !_hasShownRackDialog &&
              state.detail.defaultRackId == null) {
            _hasShownRackDialog = true;
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                _showRackSetupDialog(context, state.detail);
              }
            });
          }
        },
        child: BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
          builder: (context, sessionState) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (sessionState.isActive) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PurchaseOrderDetailScreen(
                          poCode: sessionState.poNumber!,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  }

                  context.read<ReceivingSessionCubit>().clearSession();
                });
              },
              child: Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: AppColors.onSurface),
                  backgroundColor: AppColors.background,
                  leading: CustomBackButton(),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(1),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  elevation: 1,
                  // leading: IconButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.onError,
                  //     shadowColor: AppColors.onSecondary,
                  //     elevation: 1,
                  //     shape: RoundedRectangleBorder(
                  //       side: BorderSide(width: 1, color: AppColors.border),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   icon: Icon(
                  //     Icons.arrow_back_ios_rounded,
                  //     size: 18,
                  //     weight: 260,
                  //     color: AppColors.onSurface,
                  //   ),
                  // ),
                  title:
                      BlocBuilder<
                        CompanyItemDetailCubit,
                        CompanyItemDetailState
                      >(
                        builder: (context, state) {
                          if (state is CompanyItemDetailLoaded) {
                            return Row(
                              children: [
                                Text(
                                  state.detail.companyCode,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.mono.copyWith(
                                    color: AppColors.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (state.detail.sectionName != null &&
                                    state.detail.sectionName!.isNotEmpty) ...[
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.border,
                                      ),
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      state.detail.sectionName!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ],
                            );
                          }
                          return const Text('Item Detail');
                        },
                      ),
                  actions: [
                    // Menu Edit untuk atur lokasi
                    // BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
                    //   builder: (context, state) {
                    //     if (state is! CompanyItemDetailLoaded) {
                    //       return const SizedBox.shrink();
                    //     }

                    //     return PopupMenuButton<String>(
                    //       icon: Icon(Icons.more_vert, color: AppColors.onSurface),
                    //       onSelected: (value) {
                    //         if (value == 'edit_rack') {
                    //           _navigateToEditRack(context, state.detail);
                    //         }
                    //       },
                    //       itemBuilder: (BuildContext context) => [
                    //         PopupMenuItem<String>(
                    //           value: 'edit_rack',
                    //           child: Row(
                    //             children: [
                    //               Icon(
                    //                 Icons.edit_location_alt_outlined,
                    //                 size: 18,
                    //                 color: AppColors.onBackground,
                    //               ),
                    //               SizedBox(width: 8),
                    //               Text(
                    //                 'Atur Lokasi',
                    //                 style: TextStyle(
                    //                   color: AppColors.onBackground,
                    //                   fontSize: 14,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
                bottomNavigationBar:
                    BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
                      builder: (context, sessionState) {
                        final bool isLocked =
                            sessionState.isActive &&
                            sessionState.qtyRemaining <= 0;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: Border(
                              top: BorderSide(
                                width: 0.2,
                                color: AppColors.border,
                              ),
                            ),
                          ),
                          child:
                              BlocBuilder<
                                CompanyItemDetailCubit,
                                CompanyItemDetailState
                              >(
                                builder: (context, state) {
                                  if (state is! CompanyItemDetailLoaded) {
                                    return const SizedBox.shrink();
                                  }
                                  return CustomButton(
                                    elevation: 0,
                                    radius: 40,
                                    height: 50,
                                    color: AppColors.primary,
                                    onPressed: isLocked
                                        ? () => CustomToast.error(
                                            context,
                                            title:
                                                'Tidak dapat membuat variant baru',
                                            description:
                                                'Kuota PO sudah terpenuhi.',
                                          )
                                        : () async {
                                            User _user =
                                                (await UserStorage.getUser())!;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateVariantScreen(
                                                      companyItemId:
                                                          widget.companyItemId,
                                                      userId: _user.id!,
                                                      companyCode: state
                                                          .detail
                                                          .companyCode,
                                                      productName: state
                                                          .detail
                                                          .productName,
                                                      defaultRackId: state
                                                          .detail
                                                          .defaultRackId,
                                                      defaultRackName: state
                                                          .detail
                                                          .defaultRackName,
                                                    ),
                                              ),
                                            );
                                          },
                                    child: Text(
                                      '+ TAMBAH VARIAN',
                                      style: TextStyle(
                                        color: AppColors.surface,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        );
                      },
                    ),
                body:
                    BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
                      builder: (context, state) {
                        if (state is CompanyItemDetailLoading ||
                            state is CompanyItemDetailInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is CompanyItemDetailError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Terjadi kesalahan:\n${state.message}',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => _cubit.watchDetail(
                                      widget.companyItemId,
                                    ),
                                    child: const Text('Coba lagi'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is CompanyItemDetailLoaded) {
                          final detail = state.detail;
                          return RefreshIndicator(
                            onRefresh: () =>
                                _cubit.loadDetail(widget.companyItemId),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  96,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (sessionState.isActive) ...[
                                      ReceivingSessionBanner(
                                        state: sessionState,
                                      ),
                                      SizedBox(height: 12),
                                    ],
                                    _buildHeaderCard(detail),
                                    const SizedBox(height: 12),
                                    _buildSetupBanner(detail),
                                    const SizedBox(height: 16),
                                    _buildSectionTitle(
                                      'Daftar Variant',
                                      '${detail.variants.length} variant',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildVariantList(detail),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                // floatingActionButton:
                //     BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
                //       builder: (context, state) {
                //         if (state is! CompanyItemDetailLoaded) {
                //           return const SizedBox.shrink();
                //         }
                //         return _buildAddVariantFab(
                //           companyCode: state.detail.companyCode,
                //           productName: state.detail.productName,
                //           defaultRackId: state.detail.defaultRackId,
                //           defaultRackName: state.detail.defaultRackName,
                //         );
                //       },
                //     ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(CompanyItemDetail detail) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppColors.border),
        color: AppColors.onError,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppStyle.defaultBoxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(width: 1.5, color: AppColors.border),
                  ),

                  alignment: Alignment.center,
                  child: Text(
                    detail.companyCode.split('-').last,
                    style: AppTextStyles.mono.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.productName,
                        style: AppTextStyles.mono.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),

                      if (detail.categoryName.isNotEmpty) ...[
                        Text(
                          'Kategori: ${detail.categoryName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],

                      // MODIFIKASI: Tampilkan button "Atur Lokasi" jika rack null
                      if (detail.defaultRackName != null)
                        // Tampilkan lokasi jika sudah diset
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(
                              Icons.room_preferences_outlined,
                              size: 14,
                              color: AppColors.onMuted,
                            ),
                            Flexible(
                              child: Text(
                                'LOKASI: ${detail.defaultRackName}'!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),

            if (detail.defaultRackName == null)
              CustomButton(
                elevation: 0,
                height: 28,
                radius: 8,
                color: AppColors.primary.withOpacity(0.1),
                borderColor: AppColors.primary,
                onPressed: () => _navigateToEditRack(context, detail),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_location_alt_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Atur Lokasi Item',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupBanner(CompanyItemDetail detail) {
    final isInitialized = detail.variants.isNotEmpty;
    if (isInitialized) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.accent.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Item ini belum di-setup. Tentukan tipe, brand, lokasi, dan foto agar bisa dilabel.',
                style: TextStyle(color: AppColors.primary.withOpacity(0.9)),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                User _user = (await UserStorage.getUser())!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateVariantScreen(
                      companyItemId: detail.companyItemId,
                      userId: _user.id!,
                    ),
                  ),
                );
              },
              // onPressed: () => _openSetupScreen(),
              child: const Text('Setup', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildVariantList(CompanyItemDetail detail) {
    if (detail.variants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Text(
            'Belum ada variant untuk item ini.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      );
    }

    return Column(
      children: detail.variants.map((v) => _buildVariantCard(v)).toList(),
    );
  }

  Widget _buildVariantCard(VariantSummary v) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [AppStyle.defaultBoxShadow],
        color: AppColors.surface,
        border: Border.all(width: 1.2, color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          // buka detail variant (jika ada)
          User _user = (await UserStorage.getUser())!;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VariantDetailScreen(
                variantId: v.variantId,
                userId: _user.id!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.name,
                      style: AppTextStyles.mono.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (v.manufCode != null && v.manufCode!.isNotEmpty) ...[
                          Text(
                            v.manufCode!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                        if ((v.manufCode != null) && (v.brandName != null)) ...[
                          const SizedBox(width: 6),
                          Text(
                            '•',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (v.brandName != null && v.brandName!.isNotEmpty) ...[
                          Text(
                            v.brandName!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (v.rackName != null && v.rackName!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.room_preferences_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${v.rackName}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: AppColors.border),
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${v.stock} Unit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Tambahkan method untuk show modal warning
  void _showRackSetupDialog(BuildContext context, CompanyItemDetail detail) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Lokasi/Rak Belum Diatur",
          style: AppTextStyles.mono.copyWith(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Lokasi/Rak untuk item ini belum diatur. Silakan atur lokasi default untuk memudahkan pembuatan variant.",
          style: TextStyle(
            color: AppColors.onBackground,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Nanti Saja",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToEditRack(context, detail);
            },
            child: Text(
              "Atur Sekarang",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Method untuk navigate ke edit rack
  void _navigateToEditRack(BuildContext context, CompanyItemDetail detail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCompanyItemScreen(
          companyItemId: detail.companyItemId,
          companyCode: detail.companyCode,
          productName: detail.productName,
        ),
      ),
    ).then((result) {
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lokasi item berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload detail
        _cubit.watchDetail(widget.companyItemId);
      }
    });
  }

  // Widget _buildAddVariantFab({
  //   String? defaultRackId,
  //   String? defaultRackName,
  //   required String productName,
  //   required String companyCode,
  // }) {
  //   return CustomButton(
  //     radius: 1000,
  //     color: AppColors.primary,
  //     width: 150,
  //     child: Text(
  //       '+  Tambah Variant',
  //       style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.w600),
  //     ),
  //     onPressed: () => {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CreateVariantScreen(
  //             companyItemId: widget.companyItemId,
  //             userId: 'USER-1',
  //             productName: productName,
  //             companyCode: companyCode,
  //             defaultRackId: defaultRackId,
  //             defaultRackName: defaultRackName,
  //           ),
  //         ),
  //       ),
  //     },
  //   );
  // }

  // void _openSetupScreen() async {
  //   // open existing SetupCompanyItemScreen using SetupCompanyItemCubit
  //   final inventoryRepo = context.read<InventoryRepository>();
  //   final labelingRepo = context.read<LabelingRepository>();

  //   final result = await Navigator.of(context).push<bool>(
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider(
  //         create: (ctx) => SetupCompanyItemCubit(
  //           inventoryRepo: inventoryRepo,
  //           labelingRepo: labelingRepo,
  //         )..loadInitial(widget.companyItemId),
  //         child: SetupCompanyItemScreen(
  //           companyItemId: widget.companyItemId,
  //           productId: '', // repo.getCompanyItemDetail provides productId, but Setup screen also fetches from cubit
  //           userId: 'CURRENT_USER', // replace with real user id from AuthCubit when available
  //         ),
  //       ),
  //     ),
  //   );

  //   // jika berhasil menambah variant (screen pop true), reload detail
  //   if (result == true) {
  //     _cubit.loadDetail(widget.companyItemId);
  //   }
  // }
}
