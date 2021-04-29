import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';
import 'package:tk8/ui/widgets/widgets.dart';

class DebugScreen extends StatelessWidget {
  final _navigator = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug section')),
      body: ListView(
        children: [
          const Space.vertical(20),
          _buildSection(
            context,
            'Authentication',
            AuthDebug(),
          ),
          _buildSection(
            context,
            'Chapter Tests',
            ChapterTestsDebug(),
          ),
          _buildSection(
            context,
            'Alerts Tests',
            AlertDebug(),
          ),
          _buildSection(
            context,
            'WebView Screen',
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _navigator.openWebViewScreen(
                    'https://www.njiuko.com',
                    'WebView Screen Test',
                  );
                },
                child: const Text('Open WebView Screen'),
              ),
            ),
          ),
          _buildSection(
            context,
            'Crashlytics',
            _buildCrashlyticsTests(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        child,
        const Divider(
          height: 40,
          color: Colors.orange,
        )
      ],
    );
  }

  Widget _buildCrashlyticsTests(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            FirebaseCrashlytics.instance.log('baz');
          },
          child: const Text('Log'),
        ),
        TextButton(
          onPressed: () {
            // Use Crashlytics to throw an error. Use this for
            // confirmation that errors are being correctly reported.
            FirebaseCrashlytics.instance.crash();
          },
          child: const Text('Crash'),
        ),
        TextButton(
          onPressed: () {
            // Example of thrown error, it will be caught and sent to
            // Crashlytics.
            throw StateError('Uncaught error thrown by app.');
          },
          child: const Text('Throw Error'),
        ),
        TextButton(
          onPressed: () {
            // Example of an exception that does not get caught
            // by `FlutterError.onError` but is caught by the `onError` handler of
            // `runZoned`.
            Future<void>.delayed(const Duration(seconds: 2), () {
              final List<int> list = <int>[];
              developer.log(list[100].toString());
            });
          },
          child: const Text('Async out of bounds'),
        ),
        TextButton(
          onPressed: () {
            try {
              throw 'error_example';
            } catch (e, s) {
              // "context" will append the word "thrown" in the
              // Crashlytics console.
              FirebaseCrashlytics.instance
                  .recordError(e, s, reason: 'as an example');
            }
          },
          child: const Text('Record Error'),
        ),
      ],
    );
  }
}

class AuthDebug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final token = context.watch<AuthRepository>().token;
    final user = context.watch<UserRepository>().myProfileUser;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text('user id:'),
          Row(
            children: [
              Expanded(child: Text(user.id)),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy user id',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: user.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Id copied to clipboard'),
                    ),
                  );
                },
              ),
            ],
          ),
          const Text('Auth token:'),
          Row(
            children: [
              Expanded(child: Text('${token.tokenType} ${token.accessToken}')),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy auth token with token type',
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: '${token.tokenType} ${token.accessToken}',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Auth token and token type copied to clipboard'),
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.read<AuthService>().signOut(),
            child: const Text('Sign out'),
          )
        ],
      ),
    );
  }
}

class ChapterTestsDebug extends StatelessWidget {
  final _service = getIt<ChaptersTestsService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () {
          _service.reset();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Answered questions and completed chapters info have been reseted'),
            ),
          );
        },
        child: const Text('Reset chapter tests service'),
      ),
    );
  }
}

class AlertDebug extends StatefulWidget {
  @override
  _AlertDebugState createState() => _AlertDebugState();
}

class _AlertDebugState extends State<AlertDebug> {
  final _navigator = getIt<NavigationService>();
  int _buttonCount = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _buildSimpleAlertWithSpecialActions(),
          _buildSimpleAlertWithLongActionText(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(
              height: 40,
              color: Colors.grey,
            ),
          ),
          _buildActionButtonsCount(),
          _buildSimpleAlert(),
          _buildLongTextAlert(),
        ],
      ),
    );
  }

  ElevatedButton _buildSimpleAlert() {
    return ElevatedButton(
      onPressed: () {
        final alertInfo = AlertInfo(
          title: 'The alert title',
          text: "The alert text",
          actions: _createButtons(),
        );
        _navigator.showAlertDialog(alertInfo);
      },
      child: const Text('Simple alert'),
    );
  }

  ElevatedButton _buildSimpleAlertWithLongActionText() {
    return ElevatedButton(
      onPressed: () {
        final alertInfo = AlertInfo(
          title: 'The alert title',
          text: "The alert text\nselect one of the actions to close the alert",
          actions: const [
            AlertAction(
              title: 'A long action text will look like this',
              isDefault: true,
            ),
            AlertAction(
              title:
                  'A long action text with more than 2 lines will look like this',
              isDestructive: true,
            ),
          ],
        );
        _navigator.showAlertDialog(alertInfo);
      },
      child: const Text('Simple alert with long action text'),
    );
  }

  ElevatedButton _buildSimpleAlertWithSpecialActions() {
    return ElevatedButton(
      onPressed: () {
        final alertInfo = AlertInfo(
          title: 'The alert title',
          text: "This alert shows the different action types",
          actions: const [
            AlertAction(title: 'Normal'),
            AlertAction(title: 'Default', isDefault: true),
            AlertAction(title: 'Destructive', isDestructive: true),
          ],
        );
        _navigator.showAlertDialog(alertInfo);
      },
      child: const Text('Simple alert with special actions'),
    );
  }

  ElevatedButton _buildLongTextAlert() {
    return ElevatedButton(
      onPressed: () {
        final alertInfo = AlertInfo(
          title: 'An alert with a very long text',
          text:
              "Trysail Sail ho Corsair red ensign hulk smartly boom jib rum gangway. Case shot Shiver me timbers gangplank crack Jennys tea cup ballast Blimey lee snow crow's nest rutters. Fluke jib scourge of the seven seas boatswain schooner \naff booty Jack Tar transom spirits.",
          actions: _createButtons(),
        );
        _navigator.showAlertDialog(alertInfo);
      },
      child: const Text('Very long text'),
    );
  }

  Row _buildActionButtonsCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('alert actions:'),
        Text(
          '$_buttonCount',
          style: const TextStyle(fontSize: 20),
        ),
        ElevatedButton(
          onPressed:
              _buttonCount <= 1 ? null : () => setState(() => _buttonCount--),
          child: const Icon(Icons.exposure_minus_1),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _buttonCount++),
          child: const Icon(Icons.exposure_plus_1),
        ),
      ],
    );
  }

  List<AlertAction> _createButtons() {
    return List<AlertAction>.filled(
      _buttonCount,
      const AlertAction(title: 'Close'),
    );
  }
}
