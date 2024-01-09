import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/repository/model/models_repository.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/domain/weather_models.dart';
import 'package:weather_app/state/weather/weather_notifier.dart';
import 'package:weather_app/state/weather/weather_state.dart';

const weatherLocation = 'London';
const weatherCondition = WeatherCondition.rainy;
const weatherTemperature = 9.8;

//final weatherNotifierProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) => WeatherNotifier());


class Listener extends Mock {
  void call(WeatherState? previous, WeatherState value);
}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeather extends Mock implements WeatherSrcRepository {}

void main() {
  group('WeatherCubit', () {
    late WeatherSrcRepository weather;
    late WeatherRepository weatherRepository;
    //  late final weatherNotifier;

    final container = ProviderContainer();
    // addTearDown(container.dispose);
    final listener = Listener();

    // Observe a provider and spy the changes.
    container.listen(
      weatherNotifier,
      listener,
      fireImmediately: true,
    );


    setUp(() async {
      weather = MockWeather();
      weatherRepository = MockWeatherRepository();
      when(() => weather.condition).thenReturn(weatherCondition);
      when(() => weather.location).thenReturn(weatherLocation);
      when(() => weather.temperature).thenReturn(weatherTemperature);
      when(
        () => weatherRepository.getWeather(any()),
      ).thenAnswer((_) async => weather);
      //weatherNotifier = container.read(weatherNotifierProvider);
    });

    test('initial state is correct', () {
      final state = container.read(weatherNotifier);
      //final weatherNotifier = container.read(weatherNotifierProvider.notifier);
      expect(state, WeatherState());
    });

    var weatherState = WeatherState(
        status: WeatherStatus.initial,
        // temperatureUnits: TemperatureUnits.celsius,
        weatherModels: WeatherModels(
          condition: WeatherCondition.unknown,
          lastUpdated: DateTime(0),
          temperature: const Temperature(value: 0, unit: '°C'),
          windspeed: const WindSpeed(value: 0, unit: 'km/h'),
          location: '--',
        ));

    test('fetchWeather', () {
      final state = container.read(weatherNotifier.notifier);
      final fetchWeather = state.fetchWeather(null);
      expect(state.state, weatherState);
    });

    test('emits nothing when city is empty', () {
      final state = container.read(weatherNotifier.notifier);
      final fetchWeather = state.fetchWeather('');
      expect(state.state, weatherState);
    });

    test('calls getWeather with correct city', () async {
      // weatherState.weatherModels.location = weatherLocation;
      //  weatherState = WeatherState(
      //      status: WeatherStatus.success,
      //      temperatureUnits: TemperatureUnits.celsius,
      //      weatherModels: WeatherModels(
      //        condition: WeatherCondition.cloudy,
      //        lastUpdated: DateTime(0),
      //        temperature: const Temperature(value: 0),
      //        location: weatherLocation,
      //      ));
      final state = container.read(weatherNotifier.notifier);
      final fetchWeather =
          await state.fetchWeather(weatherLocation).then((value) {
        // print(state.state);
        // verify(() => weatherRepository.getWeather(weatherLocation)).called(1);
      });
    });
    //     blocTest<WeatherCubit, WeatherState>(
    //       'calls getWeather with correct city',
    //       build: () => weatherCubit,
    //       act: (cubit) => cubit.fetchWeather(weatherLocation),
    //       verify: (_) {
    //         verify(() => weatherRepository.getWeather(weatherLocation)).called(1);
    //       },
    //     );

    test('emits nothing when city is empty', () {
      final state = container.read(weatherNotifier.notifier);

      // final fetchWeather =  state.fetchWeather('').then((value){},  onError: (onError) {
      //   return Exception('oops');
      // } ).onError((error, stackTrace) =>  );
      //print(state.state);
      // Timer(const Duration(seconds: 2), () => print(state.state));

      // printOnFailure('Fail');
      //Timer(const Duration(seconds: 2), () => print(state.state));

      // expect(state.state, weatherState);
    });

  });
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;

  double toCelsius() => (this - 32) * 5 / 9;
}
