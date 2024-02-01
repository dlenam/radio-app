// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioStation _$RadioStationFromJson(Map<String, dynamic> json) => RadioStation(
      id: json['id'] as String,
      name: json['name'] as String?,
      country: json['country'] as String,
      streamUrl: json['streamUrl'] as String,
      iconUrl: json['iconUrl'] as String,
    );

Map<String, dynamic> _$RadioStationToJson(RadioStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'streamUrl': instance.streamUrl,
      'iconUrl': instance.iconUrl,
    };
