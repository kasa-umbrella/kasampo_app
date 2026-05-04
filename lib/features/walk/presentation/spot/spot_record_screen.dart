import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/walk_session_notifier.dart';

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
    await ref.read(walkSessionProvider.notifier).addSpot(
          photo: _photo!,
          description: _descriptionController.text.trim(),
        );
    if (mounted) context.go('/session');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スポットを記録')),
      body: Padding(
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
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '説明'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go('/session'),
                    child: const Text('キャンセル'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _photo != null && !_isSaving ? _save : null,
                    child: _isSaving
                        ? const CircularProgressIndicator()
                        : const Text('保存'),
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
