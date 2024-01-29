class RadioStation {
  final String id;
  final String name;
  final String country;
  final String streamUrl;
  final String iconUrl;

  const RadioStation._({
    required this.id,
    required this.name,
    required this.country,
    required this.streamUrl,
    required this.iconUrl,
  });

  factory RadioStation.fromApiJson(Map<String, dynamic> json) => RadioStation._(
        id: json['stationuuid'],
        name: json['name'],
        country: json['countrycode'],
        streamUrl: json['url'],
        iconUrl: json['favicon'],
      );
}
