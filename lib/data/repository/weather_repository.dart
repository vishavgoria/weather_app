import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import '../api_open_meteo/open_meteo_api_client.dart' hide Weather;
import 'model/models_repository.dart';

class WeatherRepository {
  WeatherRepository({OpenMeteoApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient();

  final OpenMeteoApiClient _weatherApiClient;

  Future<WeatherSrcRepository> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final weather = await _weatherApiClient.getWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    debugPrint('weather = ${weather.toString()}');
    debugPrint('location = ${location.name}');

    return WeatherSrcRepository(
      temperature: weather.currentWeather.temperature,
      temperatureUnit: weather.currentWeatherUnits.temperature,
      windspeed: weather.currentWeather.windspeed,
      windspeedUnit: weather.currentWeatherUnits.windspeed,
      location: location.name,
      condition: weather.currentWeather.weathercode.toInt().toCondition,
    );
  }

  Future<WeatherSrcRepository> getWeatherFromLocationData(LocationData locationData, String cityName) async {
    final weather = await _weatherApiClient.getWeather(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );

    debugPrint('weather = ${weather.toString()}');

    return WeatherSrcRepository(
      temperature: weather.currentWeather.temperature,
      temperatureUnit: weather.currentWeatherUnits.temperature,
      windspeed: weather.currentWeather.windspeed,
      windspeedUnit: weather.currentWeatherUnits.windspeed,
      location: cityName,
      condition: weather.currentWeather.weathercode.toInt().toCondition,
    );
  }
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
