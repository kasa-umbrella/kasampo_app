import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/sheets/app_bottom_sheet.dart';
import '../../../walk/presentation/result/walk_result_screen.dart';
import '../../../walk/providers/walk_session_notifier.dart';

class WalkSessionOverlay extends ConsumerStatefulWidget {
  const WalkSessionOverlay({super.key});

  @override
  ConsumerState<WalkSessionOverlay> createState() => _WalkSessionOverlayState();
}

class _WalkSessionOverlayState extends ConsumerState<WalkSessionOverlay> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = ref.read(walkSessionProvider);
      if (session.isPaused) return;
      final startedAt = session.startedAt;
      if (startedAt != null) {
        setState(() => _elapsed = DateTime.now().difference(startedAt) -
            Duration(seconds: session.pausedDurationSeconds));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
    return '${meters.toStringAsFixed(0)}m';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walkSessionProvider);

    ref.listen(walkSessionProvider.select((s) => s.error), (_, error) {
      if (error != null && context.mounted) {
        showSnackBar(context, error);
      }
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                child: _InfoItem(
                  label: '経過時間',
                  value: _formatDuration(_elapsed),
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 80,
                child: _InfoItem(
                  label: '距離',
                  value: _formatDistance(state.distanceMeters),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => context.go('/session/spot'),
                icon: const Icon(Icons.camera_alt_outlined),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _StopButton(
                label: state.isPaused ? '再開' : '終了',
                color: state.isPaused ? AppColors.primary : AppColors.error,
                onPressed: state.isPaused
                    ? () => ref.read(walkSessionProvider.notifier).resume()
                    : () async {
                        final result = await AppBottomSheet.show<String>(
                          context,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                '散歩を終了しますか？',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              AppButton(
                                label: '終了する',
                                onPressed: () => Navigator.of(context).pop('finish'),
                                variant: AppButtonVariant.danger,
                              ),
                              const SizedBox(height: 8),
                              AppButton(
                                label: '一時停止',
                                onPressed: () => Navigator.of(context).pop('pause'),
                                variant: AppButtonVariant.outlined,
                              ),
                              const SizedBox(height: 8),
                              AppButton(
                                label: 'キャンセル',
                                onPressed: () => Navigator.of(context).pop('cancel'),
                                variant: AppButtonVariant.outlined,
                              ),
                            ],
                          ),
                        );
                        if (!context.mounted) return;
                        if (result == 'pause') {
                          await ref.read(walkSessionProvider.notifier).pause();
                          return;
                        }
                        if (result != 'finish') return;
                        final current = ref.read(walkSessionProvider);
                        final resultData = WalkResultData(
                          routePoints: current.routePoints,
                          distanceMeters: current.distanceMeters,
                          durationSeconds: _elapsed.inSeconds,
                        );
                        await ref.read(walkSessionProvider.notifier).finish();
                        if (context.mounted) {
                          context.go('/result', extra: resultData);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
