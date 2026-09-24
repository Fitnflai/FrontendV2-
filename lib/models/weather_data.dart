import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final String temp;
  final String icon;
  final String text;
  final DateTime timestamp;

  WeatherData({
    required this.temp,
    required this.icon,
    required this.text,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  bool get isExpired => DateTime.now().difference(timestamp).inHours >= 1;
}
