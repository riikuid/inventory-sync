import 'package:flutter/material.dart';

class ForbiddenScreen extends StatelessWidget {
  const ForbiddenScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Anda tidak punya akses (403).')),
    );
  }
}
