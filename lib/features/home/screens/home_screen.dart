import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart';
import 'package:inventory_sync_apps/features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';
import 'package:inventory_sync_apps/features/company_item/screen/company_item_list_screen.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_list_screen.dart';
import 'package:inventory_sync_apps/features/rack/screen/rack_list_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _version = '1.0.0';
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    String _userRole = _user?.role?.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // toolbarHeight: 10,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1),
        ),
        title: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MP Inventory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Version $_version',
              style: AppTextStyles.mono.copyWith(
                color: AppColors.onMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 36,
            child: CustomButton(
              elevation: 0.2,
              color: AppColors.surface,
              borderColor: AppColors.border,
              borderWidth: 1,
              radius: 12,
              width: 33,
              height: 33,
              padding: EdgeInsets.zero,

              onPressed: () {
                _onTapLogout(context);
              },
              child: Icon(
                Icons.logout,
                size: 15,
                weight: 260,
                color: AppColors.onSurface,
              ),
            ),
          ),
          SizedBox(width: 18),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x25000000),
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff3D70D2), Color(0xff7BA8FE)],
                  ),
                ),
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 3,
                      children: [
                        Text(
                          '${getIcon()} ',
                          style: const TextStyle(
                            color: AppColors.surface,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          getFormattedDate(),
                          style: const TextStyle(
                            color: AppColors.surface,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      'Selamat ${getGreeting()}, ${_user?.name?.split(' ').first}!',
                      style: const TextStyle(
                        color: AppColors.surface,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Sistem pelabelan dan penerimaan barang',
                      style: const TextStyle(
                        color: AppColors.surface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Menu Utama',
                  //   style: TextStyle(
                  //     // letterSpacing: 1,
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  if (_userRole != null)
                    Column(
                      spacing: 15,
                      children: [
                        if (_userRole == adminRole ||
                            _userRole == developerRole ||
                            _userRole == storekeeperRole)
                          _buildMainButton(
                            title: 'Labeling Item',
                            subtitle: 'Generate & cetak label untuk barang',
                            icon: Icons.local_offer_outlined,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CompanyItemListScreen(),
                              ),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3e7af4), Color(0xFF4d4de7)],
                            ),
                          ),
                        if (_userRole == adminRole ||
                            _userRole == developerRole ||
                            _userRole == storekeeperRole)
                          _buildMainButton(
                            title: 'Labeling Rak',
                            subtitle: 'Buat dan cetak label rak',
                            icon: Icons.grid_on_outlined,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RackListScreen(),
                              ),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF06b681), Color(0xFF109787)],
                            ),
                          ),
                        if (_userRole == adminRole ||
                            _userRole == developerRole ||
                            _userRole == purchasingRole)
                          _buildMainButton(
                            title: 'Terima Barang',
                            subtitle: 'Penerimaan barang dari Purchase Order',
                            icon: Icons.content_paste_outlined,
                            onPressed: () async {
                              User user = (await UserStorage.getUser())!;
                              List<String> userSectionIds =
                                  (user.sections != null &&
                                      user.sections!.isNotEmpty)
                                  ? user.sections!
                                        .map(
                                          (e) =>
                                              e.idSectionPurchasing.toString(),
                                        )
                                        .whereType<String>() // buang null
                                        .toList()
                                  : [];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PurchaseOrderListScreen(
                                      userSectionIds: userSectionIds,
                                    );
                                  },
                                ),
                              );
                            },
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFf39707), Color(0xFFec5f09)],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  String getIcon() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return '🌤️';
    } else if (hour >= 11 && hour < 15) {
      return '☀️';
    } else if (hour >= 15 && hour < 18) {
      return '🌥️';
    } else {
      return '🌙';
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    return formatter.format(now);
  }

  Future<void> _loadUser() async {
    final user = await UserStorage.getUser();
    setState(() {
      _user = user;
    });
  }

  Widget _buildMainButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    required LinearGradient gradient,
  }) {
    return CustomButton(
      padding: EdgeInsets.all(16),
      elevation: 0,
      color: AppColors.surface,
      borderColor: AppColors.border,
      radius: 24,
      onPressed: onPressed,
      child: Row(
        spacing: 20,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
              gradient: gradient,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: Colors.white, size: 40.0),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.border.withAlpha(70),
            child: Icon(Icons.arrow_forward_ios, size: 14),
          ),
        ],
      ),
    );
  }

  void _onTapLogout(BuildContext context) {
    // Jika punya komponen TAPI jumlahnya cuma 1 -> Tampilkan Warning
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Konfirmasi Keluar",
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Apakah anda yakin ingin keluar?",
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
              "Tidak",
              style: TextStyle(
                color: AppColors.onMuted,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              LoadingOverlay.show(context);
              context.read<AuthCubit>().logout().then(
                (value) => LoadingOverlay.hide(),
              );
            },
            child: const Text(
              "Ya",
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
