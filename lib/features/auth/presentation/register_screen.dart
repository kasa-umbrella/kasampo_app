import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../../../core/models/user_auth_state.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/inputs/app_text_form_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(userAuthStateProvider).asData?.value;
    if (authState is! UserAuthUnregistered) return;

    await ref.read(registerControllerProvider.notifier).register(
          uid: authState.firebaseUser.uid,
          displayName: _controller.text.trim(),
          avatarUrl: authState.firebaseUser.photoURL ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント登録')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ユーザー名を入力してください',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'ユーザー名',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ユーザー名を入力してください';
                  }
                  if (value.trim().length > 20) {
                    return '20文字以内で入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: '登録する',
                onPressed: _submit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
