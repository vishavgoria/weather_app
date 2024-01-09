import 'package:json_annotation/json_annotation.dart';

part 'current_weather.g.dart';

@JsonSerializable()
class CurrentWeather {
  @JsonKey(name: 'time') final String time;
  @JsonKey(name: 'interval') final int interval;
  @JsonKey(name: 'temperature') final double temperature;
  @JsonKey(name: 'windspeed') final double windspeed;
  @JsonKey(name: 'winddirection') final int winddirection;
  @JsonKey(name: 'is_day') final int isDay;
  @JsonKey(name: 'weathercode') final double weathercode;

  const CurrentWeather(
      {required this.time,
        required this.interval,
        required this.temperature,
        required this.windspeed,
        required this.winddirection,
        required this.isDay,
        required this.weathercode});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
}