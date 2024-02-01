import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'radio_station.g.dart';

typedef RadioList = List<RadioStation>;

@JsonSerializable()
class RadioStation extends Equatable {
  final String id;
  final String? name;
  final String country;
  final String streamUrl;
  final String iconUrl;

  const RadioStation({
    required this.id,
    required this.name,
    required this.country,
    required this.streamUrl,
    required this.iconUrl,
  });

  factory RadioStation.fromApiJson(Map<String, dynamic> json) => RadioStation(
        id: json['stationuuid'],
        name: json['name'] != null && (json['name'] as String).trim() != ''
            ? (json['name'] as String).trim()
            : null,
        country: json['countrycode'],
        streamUrl: json['url'],
        iconUrl: json['favicon'],
      );

  factory RadioStation.fromJson(Map<String, dynamic> json) =>
      _$RadioStationFromJson(json);

  Map<String, dynamic> toJson() => _$RadioStationToJson(this);

  // Generates a deterministic color from the name of the radio
  // Taken from https://anoop4real.medium.com/flutter-generate-color-hash-uicolor-from-string-names-fb2ac75bde6b
  Color get color {
    if (name == null) {
      return Colors.white;
    }
    var hash = 0;
    for (var i = 0; i < name!.length; i++) {
      hash = name!.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final finalHash = hash.abs() % (256 * 256 * 256);
    final red = ((finalHash & 0xFF0000) >> 16);
    final blue = ((finalHash & 0xFF00) >> 8);
    final green = ((finalHash & 0xFF));
    final color = Color.fromRGBO(red, green, blue, 1);
    return color;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        streamUrl,
        iconUrl,
      ];
}
