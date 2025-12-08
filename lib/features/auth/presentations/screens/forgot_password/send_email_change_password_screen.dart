import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/loading_overlay.dart';
import '../../../../../shared/presentation/widgets/primary_button.dart';
import '../../../../../shared/presentation/widgets/text_field_widget.dart';
import '../../../usecases/send_email_change_password.dart';

class SendEmailChangePasswordScreen extends StatefulWidget {
  const SendEmailChangePasswordScreen({super.key});

  @override
  State<SendEmailChangePasswordScreen> createState() =>
      _SendEmailChangePasswordScreenState();
}

class _SendEmailChangePasswordScreenState
    extends State<SendEmailChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password'), centerTitle: true),
      body: Form(
        key: _form,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFieldWidget(
                    label: 'Email',
                    hintText: 'Masukkan email anda',
                    controller: _emailController,
                    required: true,
                  ),
                  const SizedBox(height: 10),
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
                      storeSendEmailChangePassword();
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

  Future<void> storeSendEmailChangePassword() async {
    if (!_form.currentState!.validate()) return;
    LoadingOverlay.show(context);
    SendEmailChangePassword sendEmail = SendEmailChangePassword();
    sendEmail(_emailController.text).then((result) {
      LoadingOverlay.hide();
      if (result.isSuccess) {
        CustomToast.success(context, description: result.resultValue?.message);
        context.push(
          Uri(
            path: RouteName.checkTokenChangePassword,
            queryParameters: {'email': _emailController.text},
          ).toString(),
        );
      } else {
        CustomToast.warning(context, description: result.errorMessage);
      }
    });
  }
}
