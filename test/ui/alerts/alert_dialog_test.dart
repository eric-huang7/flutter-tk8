import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

import '../../_helpers/service_injection.dart';

void main() {
  initializeServiceInjectionForTesting();

  group('alert dialog', () {
    testWidgets('should build alert dialog', (tester) async {
      // arrange
      final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
      getIt.registerLazySingleton<NavigationService>(
          () => NavigationService(navigator));
      const expectedValue = 42;

      // act
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: const Material(
            child: Center(
              child: Text('Go'),
            ),
          ),
        ),
      );

      final Future<int> result = showAlertDialog(
        navigator.currentContext,
        AlertInfo(title: 'title', text: 'text', actions: [
          AlertAction(
              title: 'action',
              onPressed: () {
                navigator.currentState.pop(expectedValue);
              })
        ]),
      );

      // assert
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('title'), findsOneWidget);
      expect(find.text('text'), findsOneWidget);
      expect(find.text('action'), findsOneWidget);
      await tester.tap(find.text('action'));

      expect(await result, equals(expectedValue));
    });
  });
}
