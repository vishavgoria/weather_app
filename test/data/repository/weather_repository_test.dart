import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/api_open_meteo/models/current_weather.dart';
import 'package:weather_app/data/api_open_meteo/models/current_weather_units.dart';
import 'package:weather_app/data/api_open_meteo/models/location.dart';
import 'package:weather_app/data/api_open_meteo/models/weather_data.dart';
import 'package:weather_app/data/api_open_meteo/open_meteo_api_client.dart'
    as open_meteo_api;
import 'package:weather_app/data/repository/model/models_repository.dart';
import 'package:weather_app/data/repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements Location {}

class MockWeather extends Mock implements WeatherData {}
class MockCurrentWeather extends Mock implements CurrentWeather {}
class MockCurrentWeatherUnits extends Mock implements CurrentWeatherUnits {}

void main() {
  group('WeatherRepository', () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal weather api client when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group('getWeather', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('calls locationSearch with correct city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => weatherApiClient.locationSearch(city)).called(1);
      });

      test('throws when locationSearch fails', () async {
        final exception = Exception('oops');
        when(() => weatherApiClient.locationSearch(any())).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('calls getWeather with correct latitude/longitude', () async {
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(
          () => weatherApiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);
      });

      test('throws when getWeather fails', () async {
        final exception = Exception('oops');
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('returns correct weather on success (clear)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        // "current_weather": {
        // "time": "2024-01-08T12:45",
        // "interval": 900,
        // "temperature": 42.42,
        // "windspeed": 3.2,
        // "winddirection": 117,
        // "is_day": 0,
        // "weathercode": 0
        // }

        final currentWeather = MockCurrentWeather();
        when(() => currentWeather.time).thenReturn('2024-01-08T12:45');
        when(() => currentWeather.interval).thenReturn(900);
        when(() => currentWeather.temperature).thenReturn(42.42);
        when(() => currentWeather.windspeed).thenReturn(3.2);
        when(() => currentWeather.winddirection).thenReturn(117);
        when(() => currentWeather.isDay).thenReturn(0);
        when(() => currentWeather.weathercode).thenReturn(0);

        // "current_weather_units": {
        // "time": "iso8601",
        // "interval": "seconds",
        // "temperature": "°C",
        // "windspeed": "km/h",
        // "winddirection": "°",
        // "is_day": "",
        // "weathercode": "wmo code"
        // },
        final currentWeatherUnits = MockCurrentWeatherUnits();
        when(() => currentWeatherUnits.time).thenReturn("iso8601");
        when(() => currentWeatherUnits.interval).thenReturn("seconds");
        when(() => currentWeatherUnits.temperature).thenReturn("°C");
        when(() => currentWeatherUnits.windspeed).thenReturn("km/h");
        when(() => currentWeatherUnits.winddirection).thenReturn("°");
        when(() => currentWeatherUnits.isDay).thenReturn("");
        when(() => currentWeatherUnits.weathercode).thenReturn("wmo code");

        when(() => weather.currentWeather).thenReturn(currentWeather);
        when(() => weather.currentWeatherUnits).thenReturn(currentWeatherUnits);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const WeatherSrcRepository(
            temperature: 42.42,
            temperatureUnit: '°C',
            windspeed: 3.2,
            windspeedUnit: 'km/h',
            location: city,
            condition: WeatherCondition.clear,
          ),
        );
      });

      test('returns correct weather on success (cloudy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        // "current_weather": {
        // "time": "2024-01-08T12:45",
        // "interval": 900,
        // "temperature": 42.42,
        // "windspeed": 3.2,
        // "winddirection": 117,
        // "is_day": 0,
        // "weathercode": 1
        // }

        final currentWeather = MockCurrentWeather();
        when(() => currentWeather.time).thenReturn('2024-01-08T12:45');
        when(() => currentWeather.interval).thenReturn(900);
        when(() => currentWeather.temperature).thenReturn(42.42);
        when(() => currentWeather.windspeed).thenReturn(3.2);
        when(() => currentWeather.winddirection).thenReturn(117);
        when(() => currentWeather.isDay).thenReturn(0);
        when(() => currentWeather.weathercode).thenReturn(1);

        // "current_weather_units": {
        // "time": "iso8601",
        // "interval": "seconds",
        // "temperature": "°C",
        // "windspeed": "km/h",
        // "winddirection": "°",
        // "is_day": "",
        // "weathercode": "wmo code"
        // },
        final currentWeatherUnits = MockCurrentWeatherUnits();
        when(() => currentWeatherUnits.time).thenReturn("iso8601");
        when(() => currentWeatherUnits.interval).thenReturn("seconds");
        when(() => currentWeatherUnits.temperature).thenReturn("°C");
        when(() => currentWeatherUnits.windspeed).thenReturn("km/h");
        when(() => currentWeatherUnits.winddirection).thenReturn("°");
        when(() => currentWeatherUnits.isDay).thenReturn("");
        when(() => currentWeatherUnits.weathercode).thenReturn("wmo code");

        when(() => weather.currentWeather).thenReturn(currentWeather);
        when(() => weather.currentWeatherUnits).thenReturn(currentWeatherUnits);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const WeatherSrcRepository(
            temperature: 42.42,
            temperatureUnit: '°C',
            windspeed: 3.2,
            windspeedUnit: 'km/h',
            location: city,
            condition: WeatherCondition.cloudy,
          ),
        );
      });

      test('returns correct weather on success (rainy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        // "current_weather": {
        // "time": "2024-01-08T12:45",
        // "interval": 900,
        // "temperature": 42.42,
        // "windspeed": 3.2,
        // "winddirection": 117,
        // "is_day": 0,
        // "weathercode": 51
        // }

        final currentWeather = MockCurrentWeather();
        when(() => currentWeather.time).thenReturn('2024-01-08T12:45');
        when(() => currentWeather.interval).thenReturn(900);
        when(() => currentWeather.temperature).thenReturn(42.42);
        when(() => currentWeather.windspeed).thenReturn(3.2);
        when(() => currentWeather.winddirection).thenReturn(117);
        when(() => currentWeather.isDay).thenReturn(0);
        when(() => currentWeather.weathercode).thenReturn(51);

        // "current_weather_units": {
        // "time": "iso8601",
        // "interval": "seconds",
        // "temperature": "°C",
        // "windspeed": "km/h",
        // "winddirection": "°",
        // "is_day": "",
        // "weathercode": "wmo code"
        // },
        final currentWeatherUnits = MockCurrentWeatherUnits();
        when(() => currentWeatherUnits.time).thenReturn("iso8601");
        when(() => currentWeatherUnits.interval).thenReturn("seconds");
        when(() => currentWeatherUnits.temperature).thenReturn("°C");
        when(() => currentWeatherUnits.windspeed).thenReturn("km/h");
        when(() => currentWeatherUnits.winddirection).thenReturn("°");
        when(() => currentWeatherUnits.isDay).thenReturn("");
        when(() => currentWeatherUnits.weathercode).thenReturn("wmo code");

        when(() => weather.currentWeather).thenReturn(currentWeather);
        when(() => weather.currentWeatherUnits).thenReturn(currentWeatherUnits);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const WeatherSrcRepository(
            temperature: 42.42,
            temperatureUnit: '°C',
            windspeed: 3.2,
            windspeedUnit: 'km/h',
            location: city,
            condition: WeatherCondition.rainy,
          ),
        );
      });

      test('returns correct weather on success (snowy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        // "current_weather": {
        // "time": "2024-01-08T12:45",
        // "interval": 900,
        // "temperature": 42.42,
        // "windspeed": 3.2,
        // "winddirection": 117,
        // "is_day": 0,
        // "weathercode": 71
        // }

        final currentWeather = MockCurrentWeather();
        when(() => currentWeather.time).thenReturn('2024-01-08T12:45');
        when(() => currentWeather.interval).thenReturn(900);
        when(() => currentWeather.temperature).thenReturn(42.42);
        when(() => currentWeather.windspeed).thenReturn(3.2);
        when(() => currentWeather.winddirection).thenReturn(117);
        when(() => currentWeather.isDay).thenReturn(0);
        when(() => currentWeather.weathercode).thenReturn(71);

        // "current_weather_units": {
        // "time": "iso8601",
        // "interval": "seconds",
        // "temperature": "°C",
        // "windspeed": "km/h",
        // "winddirection": "°",
        // "is_day": "",
        // "weathercode": "wmo code"
        // },
        final currentWeatherUnits = MockCurrentWeatherUnits();
        when(() => currentWeatherUnits.time).thenReturn("iso8601");
        when(() => currentWeatherUnits.interval).thenReturn("seconds");
        when(() => currentWeatherUnits.temperature).thenReturn("°C");
        when(() => currentWeatherUnits.windspeed).thenReturn("km/h");
        when(() => currentWeatherUnits.winddirection).thenReturn("°");
        when(() => currentWeatherUnits.isDay).thenReturn("");
        when(() => currentWeatherUnits.weathercode).thenReturn("wmo code");

        when(() => weather.currentWeather).thenReturn(currentWeather);
        when(() => weather.currentWeatherUnits).thenReturn(currentWeatherUnits);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const WeatherSrcRepository(
            temperature: 42.42,
            temperatureUnit: '°C',
            windspeed: 3.2,
            windspeedUnit: 'km/h',
            location: city,
            condition: WeatherCondition.snowy,
          ),
        );
      });

      test('returns correct weather on success (unknown)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        // "current_weather": {
        // "time": "2024-01-08T12:45",
        // "interval": 900,
        // "temperature": 42.42,
        // "windspeed": 3.2,
        // "winddirection": 117,
        // "is_day": 0,
        // "weathercode": -1
        // }

        final currentWeather = MockCurrentWeather();
        when(() => currentWeather.time).thenReturn('2024-01-08T12:45');
        when(() => currentWeather.interval).thenReturn(900);
        when(() => currentWeather.temperature).thenReturn(42.42);
        when(() => currentWeather.windspeed).thenReturn(3.2);
        when(() => currentWeather.winddirection).thenReturn(117);
        when(() => currentWeather.isDay).thenReturn(0);
        when(() => currentWeather.weathercode).thenReturn(-1);

        // "current_weather_units": {
        // "time": "iso8601",
        // "interval": "seconds",
        // "temperature": "°C",
        // "windspeed": "km/h",
        // "winddirection": "°",
        // "is_day": "",
        // "weathercode": "wmo code"
        // },
        final currentWeatherUnits = MockCurrentWeatherUnits();
        when(() => currentWeatherUnits.time).thenReturn("iso8601");
        when(() => currentWeatherUnits.interval).thenReturn("seconds");
        when(() => currentWeatherUnits.temperature).thenReturn("°C");
        when(() => currentWeatherUnits.windspeed).thenReturn("km/h");
        when(() => currentWeatherUnits.winddirection).thenReturn("°");
        when(() => currentWeatherUnits.isDay).thenReturn("");
        when(() => currentWeatherUnits.weathercode).thenReturn("wmo code");

        when(() => weather.currentWeather).thenReturn(currentWeather);
        when(() => weather.currentWeatherUnits).thenReturn(currentWeatherUnits);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const WeatherSrcRepository(
            temperature: 42.42,
            temperatureUnit: '°C',
            windspeed: 3.2,
            windspeedUnit: 'km/h',
            location: city,
            condition: WeatherCondition.unknown,
          ),
        );
      });
    });
  });
}
