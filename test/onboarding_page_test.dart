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

  testWidgets('navigates from onboarding to the marketplace', (tester) async {
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

    expect(find.text('Perfect for you'), findsOneWidget);
    expect(find.text('Amazing T-shirt'), findsOneWidget);
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

  testWidgets('opens product detail, bag and checkout payment', (tester) async {
    tester.view.physicalSize = const Size(589, 1275);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Amazing T-shirt').first);
    await tester.pumpAndSettle();

    expect(find.text('€ 12.00'), findsOneWidget);
    expect(find.text('+  Add to bag'), findsOneWidget);

    await tester.tap(find.text('+  Add to bag'));
    await tester.pumpAndSettle();

    expect(find.text('Your bag'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a payment method'), findsOneWidget);
    expect(find.text('Mastercard'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('runs the store flow on a Pixel 9 viewport', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Perfect for you'), findsOneWidget);

    await tester.tap(find.text('Amazing T-shirt').first);
    await tester.pumpAndSettle();

    expect(find.text('+  Add to bag'), findsOneWidget);

    await tester.tap(find.text('+  Add to bag'));
    await tester.pumpAndSettle();

    expect(find.text('Your bag'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a payment method'), findsOneWidget);
  });
}
