class Wind {
  final double speed;
  final int deg;
  final double? gust;

  Wind({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] as num).toDouble(),
      deg: json['deg'],
      gust: json['gust'] != null ? (json['gust'] as num).toDouble() : null,
    );
  }
}
