import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/location_info.dart';

class LocationInfoModel extends LocationInfo {
  const LocationInfoModel({
    required double latitude,
    required double longitude,
    required double speed,
    required DateTime time,
    required double heading,
  }) : super(
    latitude: latitude,
    longitude: longitude,
    speed: speed,
    time: time,
    heading: heading,
  );

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      time: json['time'] is Timestamp
          ? (json['time'] as Timestamp).toDate()
          : DateTime.parse(json['time'].toString()),
      heading: (json['heading'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'time': Timestamp.fromDate(time),
      'heading': heading,
    };
  }

  /// handy factory for fake/mock data
  factory LocationInfoModel.fake({
    required double latitude,
    required double longitude,
  }) {
    return LocationInfoModel(
      latitude: latitude,
      longitude: longitude,
      speed: 10.0,
      time: DateTime.now(),
      heading: 90.0,
    );
  }
}
