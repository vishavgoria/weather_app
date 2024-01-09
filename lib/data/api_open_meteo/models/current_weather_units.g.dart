// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_weather_units.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeatherUnits _$CurrentWeatherUnitsFromJson(Map<String, dynamic> json) =>
    CurrentWeatherUnits(
      time: json['time'] as String,
      interval: json['interval'] as String,
      temperature: json['temperature'] as String,
      windspeed: json['windspeed'] as String,
      winddirection: json['winddirection'] as String,
      isDay: json['is_day'] as String,
      weathercode: json['weathercode'] as String,
    );

Map<String, dynamic> _$CurrentWeatherUnitsToJson(
        CurrentWeatherUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'interval': instance.interval,
      'temperature': instance.temperature,
      'windspeed': instance.windspeed,
      'winddirection': instance.winddirection,
      'is_day': instance.isDay,
      'weathercode': instance.weathercode,
    };
