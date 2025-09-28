class Destination {
  final String title;
  final String city;
  final String country;
  final String countryCode;
  final String description;
  final List<String> inclusions;
  final String price;
  final List<String> images;
  double? temperatureC;
  String? weatherMain;

  bool isFavorite;

  Destination({
    required this.title,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.description,
    required this.inclusions,
    required this.price,
    required this.images,
    this.temperatureC,
    this.weatherMain,
    this.isFavorite = false,
  });
}