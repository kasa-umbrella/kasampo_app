import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_auth_state.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/tiles/app_list_tile.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/providers/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userAuthStateProvider).asData?.value;
    final appUser = authState is UserAuthRegistered ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          _ProfileSection(
            displayName: appUser?.displayName ?? '',
            avatarUrl: appUser?.avatarUrl ?? '',
          ),
          const _NotificationTile(),
          const Divider(height: 1, indent: 16, endIndent: 16),
          AppListTile(
            icon: Icons.location_on_outlined,
            title: '位置情報の権限確認',
            onTap: () => Geolocator.openAppSettings(),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const AppListTile(
            icon: Icons.info_outline,
            title: 'アプリバージョン',
            trailing: Text(
              '1.0.0',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          AppListTile(
            icon: Icons.description_outlined,
            title: '利用規約',
            onTap: () => context.push('/terms-view'),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          AppListTile(
            icon: Icons.article_outlined,
            title: 'ライセンス',
            onTap: () => context.push('/licenses'),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AppButton(
              label: 'サインアウト',
              variant: AppButtonVariant.danger,
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.displayName, required this.avatarUrl});

  final String displayName;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.settingGray,
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? const Icon(Icons.person, size: 32, color: AppColors.settingGray)
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatefulWidget {
  const _NotificationTile();

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_outlined),
      title: const Text('通知'),
      value: _enabled,
      activeThumbColor: AppColors.primary,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
