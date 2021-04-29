import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';

class DynamicLinksService {
  final NavigationService _navigator = getIt<NavigationService>();

  Future handleDynamicLinks() async {
    // Initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    // Link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  // Handling described on assumption that link will look like:
  // https://url/invite?code=......
  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('Handling deeplink: $deepLink');

      final isInvite = deepLink.pathSegments.contains('invite');

      if (isInvite) {
        final invitationCode = deepLink.queryParameters['code'];

        if (invitationCode != null) {
          // Open proper sign up destination and pass invitation code
          _navigator.openEditUserProfile();
        }
      }
    }
  }
}
