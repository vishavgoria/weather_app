// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/repository/model/models_repository.dart';
import 'package:weather_app/domain/weather_models.dart';
import 'package:weather_app/presentation/weather_page/widgets/weather_populated_new.dart';
import 'package:weather_app/state/weather/weather_state.dart';

class Listener extends Mock {
  void call(WeatherState? previous, WeatherState value);
}

void main() {
  group('WeatherPopulated', () {
    final weather = WeatherModels(
      condition: WeatherCondition.clear,
      temperature: Temperature(value: 42, unit: '°C'),
      windspeed: const WindSpeed(value: 0, unit: 'km/h'),
      location: 'Chicago',
      lastUpdated: DateTime(2020),
    );

    testWidgets('renders correct emoji (clear)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          // parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: WeatherPopulatedNew(
                weatherModels: weather,
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('☀️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (rainy)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          //  parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: WeatherPopulatedNew(
                weatherModels:
                    weather.copyWith(condition: WeatherCondition.rainy),
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('🌧️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (cloudy)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          //   parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: WeatherPopulatedNew(
                weatherModels:
                    weather.copyWith(condition: WeatherCondition.cloudy),
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('☁️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (snowy)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WeatherPopulatedNew(
                weatherModels:
                    weather.copyWith(condition: WeatherCondition.snowy),
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('🌨️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (unknown)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WeatherPopulatedNew(
                weatherModels:
                    weather.copyWith(condition: WeatherCondition.unknown),
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('❓'), findsOneWidget);
    });
  });
}
