import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../view_model/settings_view_model.dart';
import 'privacy_view.dart';

class SettingsView extends ConsumerStatefulWidget {
  final VoidCallback? onBackToProfile;
  final VoidCallback? onNavigateToPrivacy;

  const SettingsView(
      {super.key, this.onBackToProfile, this.onNavigateToPrivacy});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsViewModelProvider);
    final settingsViewModel = ref.read(settingsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (widget.onBackToProfile != null) {
              widget.onBackToProfile!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size8),
        children: [
          // Settings items
          ...settingsState.settingsItems.map((item) => ListTile(
                leading: Icon(
                  item.icon,
                  color: Colors.grey[700],
                  size: Sizes.size24,
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: Sizes.size20,
                ),
                onTap: () {
                  if (item.id == "privacy") {
                    if (widget.onNavigateToPrivacy != null) {
                      // Navigate to privacy using callback
                      widget.onNavigateToPrivacy!();
                    } else if (widget.onBackToProfile != null) {
                      // Fallback: Navigate to privacy in home view
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrivacyView(
                            onBackToProfile: widget.onBackToProfile,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyView(),
                        ),
                      );
                    }
                  } else {
                    item.onTap?.call();
                  }
                },
              )),
          // Separator
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: Sizes.size60,
          ),
          // Logout button
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red[600],
              size: Sizes.size24,
            ),
            title: Text(
              'Log out',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: settingsState.isLoggingOut
                ? null
                : () => _showLogoutDialog(context, settingsViewModel),
            trailing: settingsState.isLoggingOut
                ? SizedBox(
                    width: Sizes.size16,
                    height: Sizes.size16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red[600]!,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, dynamic viewModel) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      _showCupertinoLogoutDialog(context, viewModel);
    } else {
      _showMaterialLogoutDialog(context, viewModel);
    }
  }

  void _showCupertinoLogoutDialog(BuildContext context, dynamic viewModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Log Out'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context, viewModel);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMaterialLogoutDialog(BuildContext context, dynamic viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Log Out'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context, viewModel);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context, dynamic viewModel) async {
    final success = await viewModel.logout();

    if (success && context.mounted) {
      // Show success message or navigate to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
          backgroundColor: Colors.green,
        ),
      );

      // TODO: Navigate to login screen or home screen
      // For now, just pop back
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else if (context.mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Logout failed: ${ref.read(settingsViewModelProvider).error ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
