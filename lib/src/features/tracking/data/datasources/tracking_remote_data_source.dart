import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:services_app/src/features/tracking/data/models/tracking_info_model.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../models/location_info_model.dart';

abstract class TrackingRemoteDataSource {
  Stream<TrackingInfoModel> getTrackingLive(String orderId);
  Future<TrackingInfoModel> getTrackingOnce(String orderId);
}

class TrackingFirestoreImpl extends TrackingRemoteDataSource {
  @override
  Stream<TrackingInfoModel> getTrackingLive(String orderId) async* {
    try {
      final trackingStream = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('tracking')
          .doc(orderId)
          .snapshots();

      await for (final trackingDoc in trackingStream) {
        if (trackingDoc.exists && trackingDoc.data() != null) {
          yield TrackingInfoModel.fromJson(trackingDoc.data()!);
        } else {
          yield const TrackingInfoModel(
            isServiceGiverSharingLocation: false,
            lastSeenLocation: null,
            previousLocations: [],
          );
        }
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<TrackingInfoModel> getTrackingOnce(String orderId) async {
    try {
      final trackingDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('tracking')
          .doc(orderId)
          .get();

      if (trackingDoc.exists && trackingDoc.data() != null) {
        return TrackingInfoModel.fromJson(trackingDoc.data()!);
      } else {
        return const TrackingInfoModel(
          isServiceGiverSharingLocation: false,
          lastSeenLocation: null,
          previousLocations: [],
        );
      }
    } catch (error) {
      throw ServerException();
    }
  }
}
class FakeTrackingRemoteDataSource implements TrackingRemoteDataSource {
  @override
  Stream<TrackingInfoModel> getTrackingLive(String orderId) async* {
    // simulate live updates every 3 seconds
    final controller = StreamController<TrackingInfoModel>();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      final fakeLocation = LocationInfoModel(
        latitude: 33.5731 + (timer.tick * 0.0001), // simulate movement
        longitude: -7.5898 + (timer.tick * 0.0001),
        speed: 10.0,
        heading: 90.0,
        time: DateTime.now(),
      );

      controller.add(
        TrackingInfoModel(
          isServiceGiverSharingLocation: true,
          lastSeenLocation: fakeLocation,
          previousLocations: [fakeLocation],
        ),
      );

      // stop after 5 updates
      if (timer.tick >= 5) {
        timer.cancel();
        controller.close();
      }
    });

    yield* controller.stream;
  }

  @override
  Future<TrackingInfoModel> getTrackingOnce(String orderId) async {
    // Return one-time fake data
    final fakeLocation = LocationInfoModel(
      latitude: 33.5731,
      longitude: -7.5898,
      speed: 12.0,
      heading: 85.0,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    );

    return TrackingInfoModel(
      isServiceGiverSharingLocation: true,
      lastSeenLocation: fakeLocation,
      previousLocations: [
        fakeLocation,
        LocationInfoModel(
          latitude: 33.5740,
          longitude: -7.5905,
          speed: 11.5,
          heading: 100.0,
          time: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ],
    );
  }
}

