import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/repository/model/models_repository.dart';

void main() {
  group('Weather', () {
    test('can be (de)serialized', () {
      const weather = WeatherSrcRepository(
        condition: WeatherCondition.cloudy,
        temperature: 10.2,
        temperatureUnit: '°C',
        windspeed: 3.2,
        windspeedUnit: 'km/h',
        location: 'Chicago',
      );
      expect(WeatherSrcRepository.fromJson(weather.toJson()), equals(weather));
    });
  });
}
