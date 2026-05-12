import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_experinece_app/main.dart';

void main() {
  testWidgets('shows the intro button on a Pixel 9 viewport', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Personalise your\nexperience'), findsOneWidget);
  });

  testWidgets('navigates to interests and then to a blank screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(589, 1275);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    expect(
      find.text('Create a prototype in just\na few minutes'),
      findsOneWidget,
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Personalise your\nexperience'), findsOneWidget);
    expect(find.text('Design Systems'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Next'), findsNothing);
    expect(find.text('Personalise your\nexperience'), findsNothing);
  });

  testWidgets('selects and unselects multiple interests', (tester) async {
    tester.view.physicalSize = const Size(589, 1275);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsNWidgets(4));

    await tester.tap(find.text('User Experience'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsNWidgets(5));

    await tester.tap(find.text('User Interface'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsNWidgets(4));
  });
}
