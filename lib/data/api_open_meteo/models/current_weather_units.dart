import 'package:json_annotation/json_annotation.dart';

part 'current_weather_units.g.dart';

@JsonSerializable()
class CurrentWeatherUnits {
  @JsonKey(name: 'time') final String time;
  @JsonKey(name: 'interval') final String interval;
  @JsonKey(name: 'temperature') final String temperature;
  @JsonKey(name: 'windspeed') final String windspeed;
  @JsonKey(name: 'winddirection') final String winddirection;
  @JsonKey(name: 'is_day') final String isDay;
  @JsonKey(name: 'weathercode') final String weathercode;

  const CurrentWeatherUnits(
      {required this.time,
        required this.interval,
        required this.temperature,
        required this.windspeed,
        required this.winddirection,
        required this.isDay,
        required this.weathercode});

  factory CurrentWeatherUnits.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherUnitsFromJson(json);
}