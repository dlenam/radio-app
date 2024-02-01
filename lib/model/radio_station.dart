import 'package:equatable/equatable.dart';
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

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        streamUrl,
        iconUrl,
      ];
}
