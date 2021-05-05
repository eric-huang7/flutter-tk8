import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/screens/profile/me/settings/profile_settings.viewmodel.dart';
import 'package:tk8/ui/screens/profile/me/settings/resources/profile_settings_urls.dart';

class ProfileSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileSettingsViewModel(),
      child: _ProfileSettingsScreenView(),
    );
  }
}

class _ProfileSettingsScreenView extends StatelessWidget {
  static const _titleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotham",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
  );
  static const _settingsItemPadding = EdgeInsets.only(
    top: 10.0, 
    bottom: 10.0, 
    left: 16.0, 
    right: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSettingsViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    const SizedBox(height: 20),
                    _buildSettingsItem(
                      label: translate('screens.myProfile.settings.termsAndConditions'),
                      firstSectionItem: true,
                      onPressed: () {
                        model.openWebView(url: ProfileSettingsURLs.termsAndConditions, title: translate('screens.myProfile.settings.termsAndConditions'));
                      },
                    ),
                    _buildSettingsItem(
                      label: translate('screens.myProfile.settings.dataPrivacy'),
                      onPressed: () {
                        model.openWebView(url: ProfileSettingsURLs.dataPrivacy, title: translate('screens.myProfile.settings.dataPrivacy'));
                      },
                    ),
                    _buildSettingsItem(
                      label: translate('screens.myProfile.settings.helpAndFAQ'),
                      lastSectionItem: true,
                      onPressed: () {
                        model.openWebView(url: ProfileSettingsURLs.help, title: translate('screens.myProfile.settings.helpAndFAQ'));
                      },
                    ),
                    _buildEmptySpace(),
                    _buildSettingsItem(
                      label: translate('screens.myProfile.settings.logout'),
                      firstSectionItem: true,
                      lastSectionItem: true,
                      hideTrailingIcon: true,
                      onPressed: () {
                        model.logOut();
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          model.copyVersionToClipboard(context);
                        }, 
                        child: Text(
                          "v ${model.packageInfo.version} (${model.packageInfo.buildNumber})", 
                          style: _titleTextStyle.copyWith(color: TK8Colors.ocean),
                        ),
                      ),
                    ] 
                  ),
                ),
              ],
            ),
          ),
        );    
      }
    );
  }

  Widget _buildEmptySpace() {
    return Padding(
      padding: _settingsItemPadding,
      child: Container(height: 24),
    );
  }

  Widget _buildSettingsItem({String label, VoidCallback onPressed, bool firstSectionItem = false, bool lastSectionItem = false, bool hideTrailingIcon = false}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          if (firstSectionItem) const Divider(height: 0) 
            else const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Divider(height: 0),
           ),
          Padding(
            padding: _settingsItemPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: _titleTextStyle,
                  ),
                ),
                if (hideTrailingIcon) Container(height: 24)
                  else const Icon(Icons.keyboard_arrow_right, color: TK8Colors.ocean), 
              ],
            ),
          ),
          if (lastSectionItem) const Divider(height: 0),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(translate('screens.myProfile.settings.title')),
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
