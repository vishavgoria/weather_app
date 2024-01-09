import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/repository/model/models_repository.dart';
import 'package:weather_app/domain/weather_models.dart';
import 'package:weather_app/state/theme/theme_state.dart';

// ignore: must_be_immutable

class MockWeather extends Mock implements WeatherSrcRepository {
  MockWeather(this._condition);

  final WeatherCondition _condition;

  @override
  WeatherCondition get condition => _condition;
}

class Listener extends Mock {
  void call(Color? previous, Color value);
}

void main() {
  //initHydratedStorage();
  final container = ProviderContainer();
  // addTearDown(container.dispose);
  final listener = Listener();

  // Observe a provider and spy the changes.
  container.listen(
    themeState,
    listener,
    fireImmediately: true,
  );

  group('ThemeCubit', () {
    test('initial state is correct', () {
      final stateColor =
          container.readProviderElement(themeState).getState()!.requireState;
      // expect(ThemeCubit().state, ThemeCubit.defaultColor);
      expect(stateColor, ThemeState.defaultColor);
    });

  });
}
