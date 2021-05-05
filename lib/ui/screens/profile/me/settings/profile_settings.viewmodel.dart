import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:tk8/navigation/app_routes.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/services/services_injection.dart';

class ProfileSettingsViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _auth = getIt<AuthService>();

  PackageInfo packageInfo = PackageInfo(appName: "", packageName: "", version: "", buildNumber: "");

  ProfileSettingsViewModel() {
    _fetchPackageInfo();
  }

  void openWebView({String url, String title}) {
    _navigator.openWebViewScreen(url, title);
  }

  void _fetchPackageInfo() {
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
      notifyListeners();
    }).catchError((error) {
      debugPrint("packageInfo catch: $error");
    });
  }

  void copyVersionToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: "v ${packageInfo.version} (${packageInfo.buildNumber})")).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Copied to clipboard'),
        ),
      );
    });
  }

  void logOut() {
    _auth.signOut().then((value) =>_navigator.popBackUntil(AppRoutes.root));
  }
}