import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/loading_overlay.dart';
import '../../../../../shared/presentation/widgets/text_field_widget.dart';
import '../../../usecases/send_email_change_password.dart';

class CheckTokenChangePasswordScreen extends StatefulWidget {
  final String email;
  const CheckTokenChangePasswordScreen({super.key, required this.email});

  @override
  State<CheckTokenChangePasswordScreen> createState() =>
      _CheckTokenChangePasswordScreenState();
}

class _CheckTokenChangePasswordScreenState
    extends State<CheckTokenChangePasswordScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool canResendEmail = false;
  CountdownController countdownController = CountdownController(
    autoStart: true,
  );

  int countSecond = 60;
  bool isLoading = true;

  Future<void> initCounter() async {
    await Future.delayed(const Duration(seconds: 1));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenThrottleString = prefs.getString(
      'token_forgot_password_throttle',
    );
    Map<String, dynamic> tokenThrottle = tokenThrottleString != null
        ? json.decode(tokenThrottleString)
        : {};

    if (tokenThrottle[widget.email] != null) {
      DateTime now = DateTime.now();
      DateTime time = DateFormat(
        "yyyy-MM-dd HH:mm:ss",
      ).parse(tokenThrottle[widget.email]);

      Duration difference = time.difference(now);

      if (difference.inSeconds <= 60 && difference.inSeconds >= 0) {
        countSecond = difference.inSeconds;
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initCounter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Ubah Password'),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFieldWidget(
                    label: 'Kode OTP',
                    controller: _tokenController,
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  canResendEmail
                      ? OutlinedButton(
                          onPressed: () => storeSendEmailChangePassword(),
                          child: const Text('Kirim Email Kembali'),
                        )
                      : Row(
                          children: [
                            const Text(
                              'Anda tidak bisa mengirim request setelah ',
                            ),
                            Countdown(
                              controller: countdownController,
                              seconds: countSecond,
                              build: (BuildContext context, double time) =>
                                  Text(time.toInt().toString()),
                              interval: const Duration(milliseconds: 1000),
                              onFinished: () {
                                if (mounted) {
                                  setState(() {
                                    canResendEmail = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: CustomButton(
                    color: secondaryColor,
                    height: 44,
                    onPressed: () {
                      // checkToken();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> checkToken() async {
  //   if (!_form.currentState!.validate()) return;
  //   LoadingOverlay.show(context);
  //   CheckTokenChangePassword check = CheckTokenChangePassword();
  //   check(
  //     CheckTokenChangePasswordParams(
  //       email: widget.email,
  //       token: _tokenController.text,
  //     ),
  //   ).then((result) {
  //     LoadingOverlay.hide();
  //     if (result.isSuccess) {
  //       context.push(
  //         Uri(
  //           path: RouteName.changePasswordScreen,
  //           queryParameters: {'email': _tokenController.text},
  //         ).toString(),
  //       );
  //     } else {
  //       CustomToast.warning(context, description: result.errorMessage);
  //     }
  //   });
  // }

  Future<void> storeSendEmailChangePassword() async {
    LoadingOverlay.show(context);
    SendEmailChangePassword sendEmail = SendEmailChangePassword();
    sendEmail(widget.email).then((result) {
      LoadingOverlay.hide();
      if (result.isSuccess) {
        CustomToast.success(context, description: result.resultValue?.message);
        setState(() {
          canResendEmail = false;
        });
        countdownController.restart();
      } else {
        CustomToast.warning(context, description: result.errorMessage);
      }
    });
  }
}
