import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../models/privacy_setting_model.dart';
import '../view_model/privacy_view_model.dart';

class PrivacyView extends ConsumerStatefulWidget {
  final VoidCallback? onBackToProfile;

  const PrivacyView({super.key, this.onBackToProfile});

  @override
  ConsumerState<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends ConsumerState<PrivacyView> {
  @override
  Widget build(BuildContext context) {
    final privacyState = ref.watch(privacyViewModelProvider);
    final privacyViewModel = ref.read(privacyViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            if (widget.onBackToProfile != null) {
              widget.onBackToProfile!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Privacy',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: privacyState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : privacyState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.4),
                        size: 64,
                      ),
                      const SizedBox(height: Sizes.size16),
                      Text(
                        'Error loading privacy settings',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: Sizes.size8),
                      Text(
                        privacyState.error!,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.5),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.size16),
                      ElevatedButton(
                        onPressed: () {
                          privacyViewModel.clearError();
                          privacyViewModel.loadPrivacySettings();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.size8),
                  children: [
                    // General Privacy Settings
                    ..._buildGeneralPrivacySettings(
                        privacyState, privacyViewModel),

                    // Separator
                    Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                      indent: Sizes.size16,
                      endIndent: Sizes.size16,
                    ),

                    // Other Privacy Settings
                    ..._buildOtherPrivacySettings(
                        privacyState, privacyViewModel),
                  ],
                ),
    );
  }

  List<Widget> _buildGeneralPrivacySettings(
    dynamic privacyState,
    dynamic privacyViewModel,
  ) {
    final generalSettings = privacyViewModel.getGeneralPrivacySettings();

    return generalSettings.map<Widget>((setting) {
      return _buildPrivacySettingTile(setting, privacyViewModel);
    }).toList();
  }

  List<Widget> _buildOtherPrivacySettings(
    dynamic privacyState,
    dynamic privacyViewModel,
  ) {
    final otherSettings = privacyViewModel.getOtherPrivacySettings();

    return [
      // Section header
      Padding(
        padding: const EdgeInsets.all(Sizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other privacy settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: Sizes.size8),
            Text(
              privacyState.sectionDescriptions['other_privacy'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
      // Settings list
      ...otherSettings.map<Widget>((setting) {
        return _buildPrivacySettingTile(setting, privacyViewModel);
      }).toList(),
    ];
  }

  Widget _buildPrivacySettingTile(
    PrivacySettingModel setting,
    dynamic privacyViewModel,
  ) {
    switch (setting.type) {
      case PrivacySettingType.toggle:
        return SwitchListTile(
          title: Row(
            children: [
              Icon(
                setting.icon,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                size: Sizes.size24,
              ),
              const SizedBox(width: Sizes.size12),
              Text(
                setting.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          value: setting.isEnabled,
          onChanged: (value) {
            privacyViewModel.updatePrivacySetting(setting.id, value);
          },
          activeThumbColor: Theme.of(context).primaryColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Sizes.size16,
            vertical: Sizes.size4,
          ),
        );

      case PrivacySettingType.select:
        return ListTile(
          leading: Icon(
            setting.icon,
            color: Colors.grey[700],
            size: Sizes.size24,
          ),
          title: Text(
            setting.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                setting.value ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: Sizes.size4),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
                size: Sizes.size20,
              ),
            ],
          ),
          onTap: () {
            // TODO: Show selection dialog
            _showSelectionDialog(context, setting, privacyViewModel);
          },
        );

      case PrivacySettingType.navigation:
        return ListTile(
          leading: Icon(
            setting.icon,
            color: Colors.grey[700],
            size: Sizes.size24,
          ),
          title: Text(
            setting.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: Sizes.size20,
          ),
          onTap: () {
            // TODO: Navigate to sub-screen
            _showComingSoonDialog(context, setting.title);
          },
        );

      case PrivacySettingType.external:
        return ListTile(
          leading: Icon(
            setting.icon,
            color: Colors.grey[700],
            size: Sizes.size24,
          ),
          title: Text(
            setting.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            Icons.open_in_new,
            color: Colors.grey[400],
            size: Sizes.size20,
          ),
          onTap: () {
            // TODO: Open external link or show external content
            _showComingSoonDialog(context, setting.title);
          },
        );
    }
  }

  void _showSelectionDialog(
    BuildContext context,
    PrivacySettingModel setting,
    dynamic privacyViewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(setting.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Everyone',
              'People you follow',
              'Nobody',
            ].map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: setting.value,
                onChanged: (value) {
                  if (value != null) {
                    privacyViewModel.updatePrivacySetting(setting.id, value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: Text('$feature feature will be available soon.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
