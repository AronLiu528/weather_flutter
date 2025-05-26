class Rain {
  final double h1;

  Rain({required this.h1});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      h1: (json['1h'] as num).toDouble(),
    );
  }
}
