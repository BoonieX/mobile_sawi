class SamplePoint {
  final DateTime t;
  final double ph;
  final double temp;
  final double humid;
  final double soil;
  final double height;

  SamplePoint(
      this.t,
      this.ph,
      this.temp,
      this.humid,
      this.soil,
      this.height,
      );

  factory SamplePoint.fromJson(Map<String, dynamic> json) {
    return SamplePoint(
      DateTime.parse(json['t'] as String),
      (json['ph'] as num).toDouble(),
      (json['temp'] as num).toDouble(),
      (json['humid'] as num).toDouble(),
      (json['soil'] as num).toDouble(),
      (json['height'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      't': t.toIso8601String(),
      'ph': ph,
      'temp': temp,
      'humid': humid,
      'soil': soil,
      'height': height,
    };
  }
}
