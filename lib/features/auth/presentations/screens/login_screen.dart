// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/styles/sizes.dart';
import '../../../../core/utils/app_screen.dart';
import '../../../../core/utils/custom_toast.dart';
import '../../../../core/utils/loading_overlay.dart';
import '../../../../shared/widgets/text_field_widget.dart';
import '../../usecases/login_with_email_password/login_with_email_password.dart';
import '../blocs/auth_cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit _authCubit;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  String _version = '0.0.0';
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    dev.log('masuk login screen');
    super.initState();
    _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: DecorationImage(
          opacity: 0.4,
          image: NetworkImage(
            "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _form,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: AppScreen.width() * 0.3,
                    // child: Image.asset('assets/logos/mp_logo.png'),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: Sizes.xxl,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Login Disini Sekarang',
                    style: TextStyle(fontSize: Sizes.xl, color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  TextFieldWidget(
                    label: 'Email/Telp',
                    labelColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.white),
                    hintText: 'Masukkan email atau nomor telepon anda',
                    controller: _emailController,
                    required: true,
                    suffixIcon: const SizedBox(),
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    label: 'Password',
                    labelColor: Colors.white,
                    controller: _passwordController,
                    obscureText: _isObscure,
                    errorStyle: TextStyle(color: Colors.white),
                    required: true,
                    hintText: 'Masukkan password anda',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                        !_isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // context.push(RouteName.sendMailChangePasswordScreen);
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => storeLoginWithEmail(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text('Log In'),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Text(
                      'Versi $_version',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> storeLoginWithEmail() async {
    if (!_form.currentState!.validate()) return;
    LoadingOverlay.show(context);
    LoginWithEmailPassword login = LoginWithEmailPassword();
    login(
      LoginWithEmailPasswordParams(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    ).then((result) async {
      if (result.isSuccess) {
        await _authCubit.checkAuthAndStartup();
        LoadingOverlay.hide();
        CustomToast.success(context, description: result.resultValue?.message);
        context.pushReplacement(RouteName.layoutScreen);
      } else {
        LoadingOverlay.hide();

        CustomToast.warning(context, description: result.errorMessage);
      }
    });
  }
}
