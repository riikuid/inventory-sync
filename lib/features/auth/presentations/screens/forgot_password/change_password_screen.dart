import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/loading_overlay.dart';
import '../../../../../shared/presentation/widgets/text_field_widget.dart';
import '../../../usecases/change_passsword/change_password.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String token;
  const ChangePasswordScreen({super.key, required this.token});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscurePasssword = true;
  bool _isObscureConfirmPasssword = true;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Password'), centerTitle: true),
      body: Form(
        key: _form,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFieldWidget(
                    label: 'Password Baru',
                    controller: _passwordController,
                    obscureText: _isObscurePasssword,
                    required: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscurePasssword = !_isObscurePasssword;
                        });
                      },
                      icon: Icon(
                        !_isObscurePasssword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: defaultColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    required: false,
                    label: 'Konfirmasi Password',
                    controller: _confirmPasswordController,
                    obscureText: _isObscureConfirmPasssword,
                    validator: (value) {
                      if (value == '') {
                        return 'Konfirmasi password wajib diisi.';
                      }
                      if (value != _passwordController.text) {
                        return 'Konfirmasi password tidak cocok';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscureConfirmPasssword =
                              !_isObscureConfirmPasssword;
                        });
                      },
                      icon: Icon(
                        !_isObscureConfirmPasssword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: defaultColor,
                      ),
                    ),
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
                      storeChangePassword();
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

  Future<void> storeChangePassword() async {
    if (!_form.currentState!.validate()) return;
    LoadingOverlay.show(context);
    ChangePassword changePassword = ChangePassword();
    changePassword(
      ChangePasswordParams(
        token: widget.token,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    ).then((result) {
      LoadingOverlay.hide();
      if (result.isSuccess) {
        CustomToast.success(context, description: result.resultValue?.message);
        context.pop();
        context.pop();
        context.pop();
      } else {
        CustomToast.warning(context, description: result.errorMessage);
      }
    });
  }
}
