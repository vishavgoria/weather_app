import 'package:json_annotation/json_annotation.dart';

import 'current_weather.dart';
import 'current_weather_units.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  @JsonKey(name: 'latitude') final double latitude;
  @JsonKey(name: 'longitude') final double longitude;
  @JsonKey(name: 'generationtime_ms') final double generationtimeMs;
  @JsonKey(name: 'utc_offset_seconds') final int utcOffsetSeconds;
  @JsonKey(name: 'timezone') final String timezone;
  @JsonKey(name: 'timezone_abbreviation') final String timezoneAbbreviation;
  @JsonKey(name: 'elevation') final double elevation;
  @JsonKey(name: 'current_weather_units') final CurrentWeatherUnits currentWeatherUnits;
  @JsonKey(name: 'current_weather') final CurrentWeather currentWeather;

  const WeatherData(
      {required this.latitude,
        required this.longitude,
        required this.generationtimeMs,
        required this.utcOffsetSeconds,
        required this.timezone,
        required this.timezoneAbbreviation,
        required this.elevation,
        required this.currentWeatherUnits,
        required this.currentWeather});


  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  @override
  String toString() =>
      'WeatherData: {latitude: $latitude, longitude: $longitude, generationtimeMs: $generationtimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, currentWeatherUnits: $currentWeatherUnits, currentWeather: $currentWeather}';
}
