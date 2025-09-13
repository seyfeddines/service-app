import 'package:equatable/equatable.dart';
import '../../data/models/location_info_model.dart';

class LocationInfo extends Equatable {
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime time;
  final double heading;

  const LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.time,
    required this.heading,
  });

  /// تحويل من Entity لـ Model
  LocationInfoModel toModel() {
    return LocationInfoModel(
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      time: time,
      heading: heading,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, speed, time, heading];

  @override
  bool? get stringify => true;
}
