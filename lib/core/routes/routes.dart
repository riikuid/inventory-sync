// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:inventory_sync_apps/core/routes/route_names.dart';
// import 'package:inventory_sync_apps/core/routes/router_refresh.dart';
// import 'package:inventory_sync_apps/features/inventory/presentation/screens/search_item_screen.dart';

// import '../../features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';
// import '../../features/auth/presentations/blocs/permission_cubit/permission_cubit.dart';
// import '../../features/auth/presentations/screens/forgot_password/change_password_screen.dart';
// import '../../features/auth/presentations/screens/forgot_password/check_token_change_password_screen.dart';
// import '../../features/auth/presentations/screens/forgot_password/send_email_change_password_screen.dart';
// import '../../features/auth/presentations/screens/login_screen.dart';
// import '../../features/auth/presentations/screens/register_screen.dart';
// import '../../features/home/presentation/screens/home_screen.dart';
// import '../../features/inventory/presentation/screens/company_item_detail_screen.dart';
// import '../../layout.dart';
// import '../../shared/widgets/forbidden_screen.dart';

// enum PermMode { any, all }

// String? routeGuard(
//   BuildContext context,
//   GoRouterState state, {
//   bool requireAuth = false,
//   List<String> perms = const [],
//   PermMode mode = PermMode.any,
// }) {
//   final authState = context.read<AuthCubit>().state;
//   final isLoggedIn = authState is Authorized;

//   if (requireAuth && !isLoggedIn) {
//     return RouteName.loginScreen;
//   }

//   if (isLoggedIn && perms.isNotEmpty) {
//     final permSet = context.read<PermissionCubit>().state.set;
//     final ok = switch (mode) {
//       PermMode.any => permSet.anyOf(perms),
//       PermMode.all => permSet.allOf(perms),
//     };
//     if (!ok) return RouteName.forbiddenScreen;
//   }

//   return null;
// }

// GoRouter buildRouter(BuildContext context) {
//   final auth = context.read<AuthCubit>();
//   final perm = context.read<PermissionCubit>();

//   return GoRouter(
//     initialLocation: RouteName.homeScreen,

//     // redirect() dipanggil ulang saat auth/permission berubah
//     refreshListenable: RouterRefresh([auth.stream, perm.stream]),

//     routes: [
//       // GoRoute(
//       //   path: RouteName.layoutScreen,
//       //   redirect: (ctx, s) => routeGuard(ctx, s, requireAuth: true),
//       //   builder: (context, state) {
//       //     final param = state.uri.queryParameters['selectedIndex'];
//       //     final selectedIndex = param != null ? int.tryParse(param) : null;
//       //     return Layout(selectedIndex: selectedIndex);
//       //   },
//       // ),

//       GoRoute(
//         path: RouteName.homeScreen,
//         redirect: (ctx, s) => routeGuard(ctx, s, requireAuth: true),
//         builder: (context, state) => const HomeScreen(),
//       ),

//       // === Auth (public) ===
//       GoRoute(
//         path: RouteName.loginScreen,
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: RouteName.registerScreen,
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       GoRoute(
//         path: RouteName.sendMailChangePasswordScreen,
//         builder: (context, state) => const SendEmailChangePasswordScreen(),
//       ),
//       GoRoute(
//         path: RouteName.checkTokenChangePassword,
//         builder: (context, state) {
//           final email = state.uri.queryParameters['email'].toString();
//           return CheckTokenChangePasswordScreen(email: email);
//         },
//       ),
//       GoRoute(
//         path: RouteName.changePasswordScreen,
//         builder: (context, state) {
//           final token = state.uri.queryParameters['token'].toString();
//           return ChangePasswordScreen(token: token);
//         },
//       ),

//       GoRoute(
//         path: RouteName.lsitCompanyItemScreen,
//         builder: (context, state) {
//           return SearchItemScreen();
//         },
//         routes: [
//           GoRoute(
//             path: '${RouteName.detailCompanyItemScreen}/:id',
//             builder: (context, state) {
//               final id = state.uri.queryParameters['id']!;
//               return CompanyItemDetailScreen(companyItemId: id);
//             },
//           ),
//         ],
//       ),

//       // === Contoh halaman yang butuh permission spesifik ===
//       GoRoute(
//         path: '/roles',
//         redirect: (ctx, s) => routeGuard(
//           ctx,
//           s,
//           requireAuth: true,
//           perms: const ['role>read'],
//           mode: PermMode.any,
//         ),
//         builder: (context, state) =>
//             const Placeholder(), // ganti dengan RolesScreen()
//       ),

//       GoRoute(
//         path: '/presence-export',
//         redirect: (ctx, s) => routeGuard(
//           ctx,
//           s,
//           requireAuth: true,
//           perms: const ['presence>export'],
//         ),
//         builder: (context, state) =>
//             const Placeholder(), // ganti PresenceExportScreen()
//       ),

//       // 403 Forbidden
//       GoRoute(
//         path: RouteName.forbiddenScreen,
//         builder: (context, state) => const ForbiddenScreen(),
//       ),
//     ],
//   );
// }
