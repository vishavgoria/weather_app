import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/state/weather/weather_state.dart';
import '../../data/repository/weather_repository.dart';
import '../../domain/weather_models.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState());

  WeatherRepository _overrideRepository() {
    final container = ProviderContainer();
    return container.read(repository);
  }

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    state = state.copyWith(status: WeatherStatus.loading);

    final weatherProv = _overrideRepository();

    try {
      final weather = WeatherModels.fromRepository(
        await weatherProv.getWeather(city),
      );
      final value = weather.temperature.value;
      final unit = weather.temperature.unit;

      state = state.copyWith(
        status: WeatherStatus.success,
        weatherModels: weather.copyWith(temperature: Temperature(value: value, unit: unit)),
      );
    } on Exception {
      state = state.copyWith(status: WeatherStatus.failure);
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weatherModels == WeatherModels.empty) return;

    //Inject WeatherRepository()
    final weatherProv = _overrideRepository();

    try {
      final weather = WeatherModels.fromRepository(
        // await _weatherRepository.getWeather(state.weatherModels.location),
        await weatherProv.getWeather(state.weatherModels.location),
      );
      // final units = state.temperatureUnits;
      // final value = units.isFahrenheit
      //     ? weather.temperature.value.toFahrenheit()
      //     : weather.temperature.value;
      final value = weather.temperature.value;
      final unit = weather.temperature.unit;

      state = state.copyWith(
        status: WeatherStatus.success,
        // temperatureUnits: units,
        weatherModels: weather.copyWith(temperature: Temperature(value: value, unit: unit)),
      );
    } on Exception {
      state = state;
    }
  }

  // void toggleUnits() {
  //   // final units = state.temperatureUnits.isFahrenheit
  //   //     ? TemperatureUnits.celsius
  //   //     : TemperatureUnits.fahrenheit;
  //   // state = state.copyWith(status: WeatherStatus.success);
  //   if (!state.status.isSuccess) {
  //     state = state.copyWith(temperatureUnits: units);
  //     return;
  //   }
  //
  //   final weather = state.weatherModels;
  //   if (weather != WeatherModels.empty) {
  //     final temperature = weather.temperature;
  //     final value = units.isCelsius
  //         ? temperature.value.toCelsius()
  //         : temperature.value.toFahrenheit();
  //     final unit = weather.temperature.unit;
  //     state = state.copyWith(
  //       temperatureUnits: units,
  //       weatherModels: weather.copyWith(temperature: Temperature(value: value, unit: unit)),
  //     );
  //     //  );
  //   }
  // }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;

  double toCelsius() => (this - 32) * 5 / 9;
}

final weatherNotifier = StateNotifierProvider<WeatherNotifier, WeatherState>(
    (ref) => WeatherNotifier());

final futureWeatherNotifier = FutureProvider((ref) {
  final futureWeather = ref.watch(weatherNotifier);
  // futureWeather.fetchWeather(city);
  return futureWeather;
});

//Inject WeatherRepository
final repository = Provider<WeatherRepository>((ref) => WeatherRepository());
