import 'package:flutter/material.dart';
import 'terms_content.dart';

class TermsViewScreen extends StatelessWidget {
  const TermsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('利用規約')),
      body: const TermsContent(),
    );
  }
}