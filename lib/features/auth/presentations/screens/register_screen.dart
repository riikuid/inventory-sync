import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/custom_toast.dart';
import '../../../../core/utils/loading_overlay.dart';
import '../../usecases/register_with_email_password/register_with_email_password.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    dev.log('masuk register screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _form,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == '') {
                        return 'The name field is required.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(label: Text('Name')),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == '') {
                        return 'The email field is required.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == '') {
                        return 'The password field is required.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => storeRegister(),
                      child: const Text('Register'),
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

  Future<void> storeRegister() async {
    if (!_form.currentState!.validate()) return;
    LoadingOverlay.show(context);
    RegisterWithEmailPassword register = RegisterWithEmailPassword();
    register(
      RegisterParam(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    ).then((result) {
      LoadingOverlay.hide();
      if (result.isSuccess) {
        CustomToast.success(context, description: result.resultValue?.message);
        context.pop();
      } else {
        CustomToast.warning(context, description: result.errorMessage);
      }
    });
  }
}
