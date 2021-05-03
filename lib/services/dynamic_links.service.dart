import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tk8/util/log.util.dart';

class DynamicLinksService {
  final _invitationCodeSubject = BehaviorSubject<String>();

  String get invitationCode => _invitationCodeSubject.value;
  Stream<String> get invitationCodeStream => _invitationCodeSubject.stream;

  Future<void> handleDynamicLinks() async {
    // Initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    // Link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: _handleDeepLink,
      onError: (OnLinkErrorException e) async {
        debugLogError('Dynamic Link Failed', e);
      },
    );
  }

  // Handling described on assumption that link will look like:
  // https://url/invite?code=......
  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      debugLog('Handling deeplink: $deepLink');

      final isInvite = deepLink.pathSegments.contains('invite');

      if (isInvite) {
        _invitationCodeSubject.add(deepLink.queryParameters['code']);
      }
    }
  }
}
