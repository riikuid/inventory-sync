import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/app_firebase.dart';
import 'package:inventory_sync_apps/features/home/presentation/screens/home_screen.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/product_list_screen.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/search_item_screen.dart';

import 'core/routes/route_names.dart';
import 'core/styles/sizes.dart';
import 'features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

// import 'utils/location_service.dart';

class Layout extends StatefulWidget {
  final int? selectedIndex;
  const Layout({super.key, this.selectedIndex});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProductListScreen(),
    // const VisitLayout(),
    // const CustomerScreen(),
    // const ComplainScreen(),
    // const ProfileScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    // LocationService.checkAndRequestLocationPermission();
    dev.log('masuk layout');

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppFirebase.setupInteractedMessage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthorized) {
          context.go(RouteName.loginScreen);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is Authorized) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Center(child: _widgetOptions.elementAt(_selectedIndex)),
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              selectedFontSize: 10,
                              unselectedFontSize: 10,
                              unselectedItemColor: Colors.white,
                              selectedItemColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              selectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              iconSize: 28,
                              // unselectedLabelStyle: TextStyle(color: Colors.black),
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home_rounded),
                                  label: 'Beranda',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.explore_outlined),
                                  label: 'Kunjungan',
                                ),
                                // BottomNavigationBarItem(
                                //   icon: Icon(Icons.store),
                                //   label: 'Pelanggan',
                                // ),
                                // BottomNavigationBarItem(
                                //   icon: Icon(Icons.comment_outlined),
                                //   label: 'Komplain',
                                // ),
                                // BottomNavigationBarItem(
                                //   icon: Icon(Icons.account_circle_outlined),
                                //   label: 'Profil',
                                // ),
                              ],
                              currentIndex: _selectedIndex,
                              // selectedItemColor: bInfo,
                              // unselectedItemColor: bDark,
                              onTap: _onItemTapped,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AuthError) {
            return Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Terjadi kesalahan, silahkan refresh kembali',
                      style: TextStyle(fontSize: Sizes.l),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xffF4F1EC),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).authCheck();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: const Text(
                          'Refresh',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
