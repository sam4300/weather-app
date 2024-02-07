import 'dart:convert';

import 'package:flutter/foundation.dart';

class WeatherModel {
  final double currentTemperature;
  final String currentSky;
  final int currentHumidity;
  final int currentPressure;
  final double currentWind;
  final Map<String, dynamic> hourlyData;
  WeatherModel({
    required this.currentTemperature,
    required this.currentSky,
    required this.currentHumidity,
    required this.currentPressure,
    required this.currentWind,
    required this.hourlyData,
  });

  WeatherModel copyWith({
    double? currentTemperature,
    String? currentSky,
    int? currentHumidity,
    int? currentPressure,
    double? currentWind,
    Map<String, dynamic>? hourlyData,
  }) {
    return WeatherModel(
      currentTemperature: currentTemperature ?? this.currentTemperature,
      currentSky: currentSky ?? this.currentSky,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      currentPressure: currentPressure ?? this.currentPressure,
      currentWind: currentWind ?? this.currentWind,
      hourlyData: hourlyData ?? this.hourlyData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentTemperature': currentTemperature,
      'currentSky': currentSky,
      'currentHumidity': currentHumidity,
      'currentPressure': currentPressure,
      'currentWind': currentWind,
      'hourlyData': hourlyData,
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    final weatherData = map['list'][0];
    return WeatherModel(
        currentTemperature: weatherData['main']['temp'],
        currentSky: weatherData['weather'][0]['main'],
        currentHumidity: weatherData['main']['humidity'],
        currentPressure: weatherData['main']['pressure'],
        currentWind: weatherData['wind']['speed'],
        hourlyData: map);
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherModel(currentTemperature: $currentTemperature, currentSky: $currentSky, currentHumidity: $currentHumidity, currentPressure: $currentPressure, currentWind: $currentWind, hourlyData: $hourlyData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherModel &&
        other.currentTemperature == currentTemperature &&
        other.currentSky == currentSky &&
        other.currentHumidity == currentHumidity &&
        other.currentPressure == currentPressure &&
        other.currentWind == currentWind &&
        mapEquals(other.hourlyData, hourlyData);
  }

  @override
  int get hashCode {
    return currentTemperature.hashCode ^
        currentSky.hashCode ^
        currentHumidity.hashCode ^
        currentPressure.hashCode ^
        currentWind.hashCode ^
        hourlyData.hashCode;
  }
}
