import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';

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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '利用規約',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'かさんぽ（以下「本アプリ」）をご利用いただく前に、以下の利用規約をよくお読みください。',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  _section('第1条（適用）', '本規約は、本アプリの利用に関する条件を定めるものです。ユーザーは本規約に同意した上で本アプリを利用するものとします。'),
                  _section('第2条（利用登録）', '本アプリの利用を希望する方は、本規約に同意の上、所定の方法によって利用登録を申請するものとします。'),
                  _section('第3条（位置情報の取得）', '本アプリは散歩記録のために位置情報を取得します。取得した位置情報はアプリの機能提供のみに使用し、第三者への提供は行いません。'),
                  _section('第4条（禁止事項）', '本アプリを利用するにあたり、法令または公序良俗に違反する行為、他のユーザーへの迷惑行為、その他運営が不適切と判断する行為を禁止します。'),
                  _section('第5条（免責事項）', '本アプリの利用によって生じた損害について、当方は一切の責任を負いません。'),
                  _section('第6条（規約の変更）', '本規約は必要に応じて変更することがあります。変更後の規約はアプリ内にて通知します。'),
                ],
              ),
            ),
          ),
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

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
