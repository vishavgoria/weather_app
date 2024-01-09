import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/presentation/app.dart';
import 'package:weather_app/presentation/weather_page/weather_page.dart';
import 'package:weather_app/state/shared_notifier.dart';
import 'package:weather_app/state/theme/theme_state.dart';
import '../shared_pref_init.dart';

class Listener extends Mock {
  void call(Color? previous, Color value);
}


void main() async {
  SharedPreferences sharedPref = await initShared();

  final container = ProviderContainer();
  final listener = Listener();

  container.listen(
    themeState,
    listener,
    fireImmediately: true,
  );

  group('WeatherApp', () {
    testWidgets('renders WeatherApp', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPref),
        ], child: const WeatherApp()),
      );
      expect(find.byType(WeatherApp), findsOneWidget);
    });
  });

  group('WeatherApp', () {
    testWidgets('renders WeatherPage', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPref),
        ],
        child: const WeatherApp(),
      ));
      expect(find.byType(WeatherPage), findsOneWidget);
    });

    testWidgets('has correct theme primary color', (tester) async {
      const color = Color(0xFFD2D2D2);
      final focus = container.readProviderElement(themeState);
      focus.setState(color);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPref),
        ],
        parent: container,
        child: const WeatherApp(),
      ));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.primaryColor, color);
    });
  });
}
