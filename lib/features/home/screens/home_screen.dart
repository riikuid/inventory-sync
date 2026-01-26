import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
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
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    String _userRole = _user?.role?.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1),
        ),
        title: Hero(
          tag: 'mp-title',
          child: Material(
            child: const Text(
              'MP Inventory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.focusRing,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                    
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
                  Text(
                    'MENU UTAMA',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PurchaseOrderListScreen(
                                      userSectionIds:
                                          (user.sections != null &&
                                              user.sections!.isNotEmpty)
                                          ? user.sections!
                                                .map((e) => e.id)
                                                .whereType<
                                                  String
                                                >() // buang null
                                                .toList()
                                          : [],
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
}
