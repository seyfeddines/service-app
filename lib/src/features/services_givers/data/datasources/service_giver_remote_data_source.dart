import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../models/service_giver_model.dart';

abstract class ServiceGiverRemoteDataSource {
  Future<List<ServiceGiverModel>> getAllServiceGivers(String serviceId);
}


class FakeServiceGiverRemoteDataSource implements ServiceGiverRemoteDataSource {
  FakeServiceGiverRemoteDataSource();

  static final List<ServiceGiverModel> _fakeServiceGivers = [
    ServiceGiverModel(
      id: '1',
      name: 'سيف الدين بوبكري',
      image: 'https://picsum.photos/200/300?random=10',
      phoneNumber: '+213661111111',
      services: ['1', '2', '3', '4'],
      rating: 4.5,
      cost: 50.0,
      city: 'تيزي وزو',
      area: 'وسط المدينة',
      location: const LatLng(36.7169, 4.0497), // تيزي وزو مركز
      registrationDate: DateTime(2023, 1, 1),
    ),
    ServiceGiverModel(
      id: '2',
      name: 'فاطمة الزهراء عمري',
      image: 'https://picsum.photos/200/300?random=11',
      phoneNumber: '+213662222222',
      services: ['2'],
      rating: 4.8,
      cost: 70.0,
      city: 'أزفون',
      area: 'حي البحر',
      location: const LatLng(36.8890, 4.4040), // أزفون
      registrationDate: DateTime(2023, 3, 15),
    ),
    ServiceGiverModel(
      id: '3',
      name: 'محمد أمين قروي',
      image: 'https://picsum.photos/200/300?random=12',
      phoneNumber: '+213663333333',
      services: ['1'],
      rating: 4.2,
      cost: 40.0,
      city: 'ذراع بن خدة',
      area: 'حي الجامع',
      location: const LatLng(36.7160, 3.9000), // ذراع بن خدة
      registrationDate: DateTime(2022, 11, 20),
    ),
    ServiceGiverModel(
      id: '4',
      name: 'خديجة بن عمر',
      image: 'https://picsum.photos/200/300?random=13',
      phoneNumber: '+213664444444',
      services: ['3', '4'],
      rating: 4.9,
      cost: 80.0,
      city: 'تيقزيرت',
      area: 'حي الميناء',
      location: const LatLng(36.8940, 4.1300), // تيقزيرت
      registrationDate: DateTime(2023, 5, 10),
    ),
    ServiceGiverModel(
      id: '5',
      name: 'عبد القادر شريف',
      image: 'https://picsum.photos/200/300?random=14',
      phoneNumber: '+213665555555',
      services: ['1', '5'],
      rating: 4.3,
      cost: 60.0,
      city: 'بوزقان',
      area: 'وسط المدينة',
      location: const LatLng(36.6500, 4.4167), // بوزقان
      registrationDate: DateTime(2022, 9, 25),
    ),
    ServiceGiverModel(
      id: '6',
      name: 'مريم بوزيد',
      image: 'https://picsum.photos/200/300?random=15',
      phoneNumber: '+213666666666',
      services: ['2', '3'],
      rating: 4.7,
      cost: 90.0,
      city: 'عين الحمام',
      area: 'حي السوق',
      location: const LatLng(36.5667, 4.2833), // عين الحمام
      registrationDate: DateTime(2023, 6, 5),
    ),
    ServiceGiverModel(
      id: '7',
      name: 'يوسف علاوي',
      image: 'https://picsum.photos/200/300?random=16',
      phoneNumber: '+213667777777',
      services: ['4'],
      rating: 4.1,
      cost: 35.0,
      city: 'بوغني',
      area: 'لمسان',
      location: const LatLng(36.5333, 4.0833), // بوغني
      registrationDate: DateTime(2021, 12, 30),
    ),


  ];

  @override
  Future<List<ServiceGiverModel>> getAllServiceGivers(String serviceId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      return _fakeServiceGivers
          .where((giver) => giver.services.contains(serviceId))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }
}
