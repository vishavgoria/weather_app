import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/repository/model/models_repository.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/domain/weather_models.dart';
import 'package:weather_app/presentation/search_page/search_page.dart';
import 'package:weather_app/presentation/weather_page/weather_page.dart';
import 'package:weather_app/presentation/weather_page/widgets/weather_empty.dart';
import 'package:weather_app/presentation/weather_page/widgets/weather_populated_new.dart';
import 'package:weather_app/state/shared_notifier.dart';
import 'package:weather_app/state/weather/weather_notifier.dart';
import 'package:weather_app/state/weather/weather_state.dart';
import '../../shared_pref_init.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class Listener extends Mock {
  void call(WeatherState? previous, WeatherState value);
}

void main() async {
  SharedPreferences sharedPref = await initShared();
  MockWeatherRepository mockWeatherRepository = MockWeatherRepository();
  final container = ProviderContainer();

  final listener = Listener();

  group('WeatherPage', () {
    //late WeatherRepository weatherRepository;

    setUp(() {
      // weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherView', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPref),
            repository.overrideWithValue(mockWeatherRepository),
          ],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );
      expect(find.byType(WeatherPage), findsOneWidget);
    });
  });

  group('WeatherView', () {
    final weather = WeatherModels(
      temperature: const Temperature(value: 4.2, unit: '°C'),
      windspeed: const WindSpeed(value: 0, unit: 'km/h'),
      condition: WeatherCondition.cloudy,
      lastUpdated: DateTime(2020),
      location: 'London',
    );

    testWidgets('renders WeatherEmpty for WeatherStatus.initial',
            (tester) async {
          final focus = container.readProviderElement(weatherNotifier);
          focus.setState(
            WeatherState(status: WeatherStatus.initial),
          );
          await tester.pumpWidget(
            ProviderScope(
              parent: container,
              overrides: [
                sharedPreferencesProvider.overrideWithValue(sharedPref),
                repository.overrideWithValue(mockWeatherRepository),
              ],
              child: const MaterialApp(home: WeatherPage()),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(WeatherEmpty), findsOneWidget);
        });

    testWidgets('renders WeatherLoading for WeatherStatus.loading',
            (tester) async {
          final focus = container.readProviderElement(weatherNotifier);
          focus.setState(WeatherState(status: WeatherStatus.loading));

          await tester.pumpWidget(ProviderScope(
            parent: container,
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPref),
              repository.overrideWithValue(mockWeatherRepository),
            ],

            child: const MaterialApp(home: WeatherPage()),
          ));
          await tester.pumpAndSettle();
          final status =
              container.readProviderElement(weatherNotifier).requireState.status;
          expect(status, WeatherStatus.loading);
        });
    //
    testWidgets('renders WeatherPopulated for WeatherStatus.success',
            (tester) async {
          final focus = container.readProviderElement(weatherNotifier);
          focus.setState(WeatherState(status: WeatherStatus.success));
          await tester.pumpWidget(ProviderScope(
            parent: container,
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPref),
              repository.overrideWithValue(mockWeatherRepository),
            ],
            child: const MaterialApp(home: WeatherPage()),
          ));
          await tester.pumpAndSettle();
          expect(find.byType(WeatherPopulatedNew), findsOneWidget);
        });

    testWidgets('renders WeatherError for WeatherStatus.failure',
            (tester) async {
          final focus = container.readProviderElement(weatherNotifier);
          focus.setState(WeatherState(status: WeatherStatus.failure));
          await tester.pumpWidget(ProviderScope(
            parent: container,
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPref),
              repository.overrideWithValue(mockWeatherRepository),
            ],
            child: const MaterialApp(home: WeatherPage()),
          ));
          await tester.pumpAndSettle();
          final status =
              container.readProviderElement(weatherNotifier).requireState.status;
          expect(status, WeatherStatus.failure);
        });


    testWidgets('navigates to SearchPage when search button is tapped',
            (tester) async {
          await tester.pumpWidget(ProviderScope(
            parent: container,
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPref),
              repository.overrideWithValue(mockWeatherRepository),
            ],
            child: const MaterialApp(home: WeatherPage()),
          ));
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          expect(find.byType(SearchPage), findsOneWidget);
        });
  });
}