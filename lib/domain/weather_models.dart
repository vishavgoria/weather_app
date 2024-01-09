import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../data/repository/model/models_repository.dart' as weather_repository;
import '../data/repository/model/models_repository.dart';

part 'weather_models.g.dart';

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value, required this.unit});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;
  final String unit;

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  @override
  List<Object> get props => [value, unit];
}

@JsonSerializable()
class WindSpeed extends Equatable {
  const WindSpeed({required this.value, required this.unit});

  factory WindSpeed.fromJson(Map<String, dynamic> json) =>
      _$WindSpeedFromJson(json);

  final double value;
  final String unit;

  Map<String, dynamic> toJson() => _$WindSpeedToJson(this);

  @override
  List<Object> get props => [value, unit];
}

@JsonSerializable()
class WeatherModels extends Equatable {
  const WeatherModels({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
    required this.windspeed,
  });

  factory WeatherModels.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelsFromJson(json);

  factory WeatherModels.fromRepository(
      weather_repository.WeatherSrcRepository weather) {
    return WeatherModels(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature, unit: weather.temperatureUnit),
      windspeed: WindSpeed(value: weather.windspeed, unit: weather.windspeedUnit),
    );
  }

  static final empty = WeatherModels(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: const Temperature(value: 0, unit: '°C'),
    windspeed: const WindSpeed(value: 0, unit: 'km/h'),
    location: '--',
  );

  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  final WindSpeed windspeed;

  @override
  List<Object> get props => [condition, lastUpdated, location, temperature, windspeed];

  Map<String, dynamic> toJson() => _$WeatherModelsToJson(this);

  WeatherModels copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
    WindSpeed? windspeed,
  }) {
    return WeatherModels(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      windspeed: windspeed ?? this.windspeed,
    );
  }
}
