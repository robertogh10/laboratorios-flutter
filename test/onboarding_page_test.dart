import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_experinece_app/main.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows the intro button on a Pixel 9 viewport', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMainApp(tester);

    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Personalise your\nexperience'), findsOneWidget);
  });

  testWidgets('navigates from onboarding to login', (tester) async {
    tester.view.physicalSize = const Size(589, 1275);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMainApp(tester);

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

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byKey(const ValueKey('auth-email-field')), findsOneWidget);
    expect(find.text('Personalise your\nexperience'), findsNothing);
  });

  testWidgets('selects and unselects multiple interests', (tester) async {
    tester.view.physicalSize = const Size(589, 1275);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMainApp(tester);

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

    await pumpMainApp(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('auth-demo-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Amazing T-shirt').first);
    await tester.pumpAndSettle();

    expect(find.text('€ 20.00'), findsOneWidget);
    expect(find.text('+  Add to bag'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('product-size-XL')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('product-color-ff202129')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('+  Add to bag'));
    await tester.pumpAndSettle();

    expect(find.text('Your bag'), findsOneWidget);
    expect(find.text('Black / XL'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('remove-bag-item-amazing-shirt-XL-ff202129')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Black / XL'), findsNothing);
    expect(find.text('Total'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a payment method'), findsOneWidget);
    expect(find.text('Mastercard'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('add-new-card-button')));
    await tester.pumpAndSettle();

    expect(find.text('Add card'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('cardholder-name-field')),
      'Roberto Giron',
    );
    await tester.enterText(
      find.byKey(const ValueKey('card-number-field')),
      '378282246310005',
    );
    await tester.enterText(
      find.byKey(const ValueKey('expiry-date-field')),
      '12/29',
    );
    await tester.enterText(find.byKey(const ValueKey('cvv-field')), '1234');
    await tester.tap(find.text('Save card'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a payment method'), findsOneWidget);
    expect(find.text('Amex'), findsOneWidget);
    expect(
      find.text('xxxx xxxx xxxx 0005 - Roberto Giron - 12/29'),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('runs the store flow on a Pixel 9 viewport', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMainApp(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('auth-demo-button')));
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

Future<void> pumpMainApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        storeLocalDataSourceProvider.overrideWith(
          (ref) => StoreLocalDataSource(sharedPreferences: prefs),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
