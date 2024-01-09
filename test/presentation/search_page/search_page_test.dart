import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/presentation/search_page/search_page.dart';
import 'package:weather_app/state/shared_notifier.dart';
import 'package:weather_app/state/weather/weather_state.dart';

import '../../shared_pref_init.dart';

class Listener extends Mock {
  void call(WeatherState? previous, WeatherState value);
}

void main() async {
  SharedPreferences sharedPref = await initShared();

  final container = ProviderContainer();

  group('SearchPage', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPref),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                                  context) =>
                              const SearchPage(),
                        ));
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('returns selected text when popped', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPref),
        ],
        parent: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                },
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Chicago');

      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsNothing);
      String? location = await sharedPref.getString('city');
      expect(location, 'Chicago');
    });

    testWidgets(
        'returns selected text when popped and String must be Chicago or previus value ',
        (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPref),
        ],
        parent: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                },
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      await tester.enterText(find.byType(TextField), '');

      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsNothing);
      String? location = await sharedPref.getString('city');
      await tester.pumpAndSettle();
      expect(location, 'Chicago');
    });
  });
}
