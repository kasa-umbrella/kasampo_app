import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/walk_session_notifier.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';

class SpotRecordScreen extends ConsumerStatefulWidget {
  const SpotRecordScreen({super.key});

  @override
  ConsumerState<SpotRecordScreen> createState() => _SpotRecordScreenState();
}

class _SpotRecordScreenState extends ConsumerState<SpotRecordScreen> {
  File? _photo;
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _save() async {
    if (_photo == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(walkSessionProvider.notifier).addSpot(
            photo: _photo!,
            description: _descriptionController.text.trim(),
          );
      if (mounted) context.go('/home');
    } catch (e, st) {
      debugPrint('spot save error: $e\n$st');
      if (mounted) {
        setState(() => _isSaving = false);
        showSnackBar(context, '保存に失敗しました。もう一度お試しください。');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スポットを記録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: _photo != null
                    ? Image.file(_photo!, fit: BoxFit.cover)
                    : const Icon(Icons.camera_alt, size: 48),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '説明'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'キャンセル',
                    onPressed: () => context.go('/home'),
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: '保存',
                    onPressed: _photo != null ? _save : null,
                    isLoading: _isSaving,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
