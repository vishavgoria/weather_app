// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };

WindSpeed _$WindSpeedFromJson(Map<String, dynamic> json) => WindSpeed(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$WindSpeedToJson(WindSpeed instance) => <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };

WeatherModels _$WeatherModelsFromJson(Map<String, dynamic> json) =>
    WeatherModels(
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      location: json['location'] as String,
      temperature:
          Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
      windspeed: WindSpeed.fromJson(json['windspeed'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherModelsToJson(WeatherModels instance) =>
    <String, dynamic>{
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'location': instance.location,
      'temperature': instance.temperature,
      'windspeed': instance.windspeed,
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};
