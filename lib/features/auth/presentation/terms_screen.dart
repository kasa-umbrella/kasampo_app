import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';
import 'terms_content.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('利用規約')),
      body: Column(
        children: [
          const Expanded(child: TermsContent()),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Checkbox(
                  value: _agreed,
                  activeColor: AppColors.primary,
                  onChanged: (value) => setState(() => _agreed = value ?? false),
                ),
                const Expanded(
                  child: Text('利用規約に同意する'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: AppButton(
              label: '同意して次へ',
              onPressed: _agreed ? () => context.go('/register') : null,
            ),
          ),
        ],
      ),
    );
  }
}