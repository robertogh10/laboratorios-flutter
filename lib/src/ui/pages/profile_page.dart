import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/user_profile.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/auth_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/profile_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final firebaseEnabled = ref.watch(firebaseEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver a la tienda',
          onPressed: () => context.go(AppRoutes.storeHome),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Perfil y configuracion'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ProfileError(
            message: error.toString(),
            onRetry: () => ref.invalidate(profileControllerProvider),
          ),
          data: (value) => ListView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
            children: [
              _ProfileHeader(
                profile: value,
                canEdit: firebaseEnabled,
                onEditPhoto: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .updatePhoto();

                  if (!context.mounted) {
                    return;
                  }

                  final error = ref
                      .read(profileControllerProvider)
                      .whenOrNull(error: (error, stackTrace) => error);

                  if (error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.toString())));
                  }
                },
              ),
              const SizedBox(height: 34),
              _SettingsTile(
                icon: Icons.receipt_long_outlined,
                title: 'Mis compras',
                subtitle: 'Consulta las ventas en tiempo real',
                onTap: () => context.go(AppRoutes.storeSales),
              ),
              _SettingsTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Solicitud de credito',
                subtitle: 'Abre la calculadora didactica de enyoi',
                onTap: () => context.go(AppRoutes.storeCredit),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                subtitle: firebaseEnabled
                    ? 'FCM activo; el token se vincula a tu usuario'
                    : 'Disponible al ejecutar con Firebase',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        firebaseEnabled
                            ? 'Las notificaciones estan configuradas.'
                            : 'Configura Firebase para activar notificaciones.',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  ref.invalidate(profileControllerProvider);

                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.canEdit,
    required this.onEditPhoto,
  });

  final UserProfile profile;
  final bool canEdit;
  final VoidCallback onEditPhoto;

  @override
  Widget build(BuildContext context) {
    final photoUrl = profile.photoUrl;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFFEAF4FF),
              foregroundImage: photoUrl == null || photoUrl.isEmpty
                  ? null
                  : NetworkImage(photoUrl),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF0A7CFF),
                size: 52,
              ),
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: IconButton.filled(
                tooltip: canEdit
                    ? 'Cambiar foto de perfil'
                    : 'No disponible en modo demo',
                onPressed: canEdit ? onEditPhoto : null,
                icon: const Icon(Icons.edit_outlined, size: 19),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          profile.displayName,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(profile.email, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAF4FF),
        child: Icon(icon, color: const Color(0xFF0A7CFF)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
