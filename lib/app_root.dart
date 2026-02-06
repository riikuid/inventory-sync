import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/shared/presentation/screen/databse_critical_error_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/error_screen.dart';

import 'features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';
import 'features/auth/presentations/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'start_up_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthAndStartup();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (_, state) {
        if (state is AuthInitial || state is AuthLoading) {
          double p = 0.0;
          String m = "Loading...";

          if (state is AuthLoading) {
            m = state.message;
            p = state.progress;
          }

          return StartupScreen(message: m, progress: p);
        }

        if (state is UnAuthorized) return const LoginScreen();
        if (state is Authorized) return const HomeScreen();
        // if (state is AuthorizedOffline) return const HomeScreen();

        // 3. Error Handling - CRITICAL DB (Rescue & Reset)
        if (state is AuthDatabaseCriticalError) {
          return DatabaseCriticalErrorScreen(errorMessage: state.message);
        }

        if (state is AuthError) {
          return ErrorScreen(
            message: state.message,
            onRetry: () => context.read<AuthCubit>().checkAuthAndStartup(),
          );
        }

        return const SizedBox();
      },
    );
  }
}
