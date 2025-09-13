import 'dart:async';
import '../models/order_model.dart';
import '../../domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  Future<List<Order>> getAllUserOrders(String userId);
  Future<String> addOrder(Order order);
  Future<void> updateImage(String docId, String newImage);
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel);
  Future<void> removeOrder(String orderId);
}

/// Fake Implementation
class FakeOrderRemoteDataSource implements OrderRemoteDataSource {
  final List<Order> _orders = [];

  FakeOrderRemoteDataSource() {
    _orders.addAll([
      OrderModel(
        id: '1',
        serviceGiverId: 'sg_001',
        serviceGiverName: 'Ali Service',
        serviceGiverImage: 'https://picsum.photos/200',
        serviceGiverPhoneNumber: '+213600000001',
        userId: 'user_123',
        userName: 'Seyf',
        userImage: 'https://picsum.photos/300',
        userPhoneNumber: '+213600000002',
        serviceName: 'House Cleaning',
        cost: 1500,
        quantity: 2,
        description: 'Cleaning service for 2 rooms',
        image: 'https://picsum.photos/400',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'pending',
      ),
      OrderModel(
        id: '2',
        serviceGiverId: 'sg_002',
        serviceGiverName: 'Karim Service',
        serviceGiverImage: 'https://picsum.photos/201',
        serviceGiverPhoneNumber: '+213600000003',
        userId: 'user_123',
        userName: 'Seyf',
        userImage: 'https://picsum.photos/301',
        userPhoneNumber: '+213600000002',
        serviceName: 'Plumbing',
        cost: 2500,
        quantity: 1,
        description: 'Fixing water leak',
        image: 'https://picsum.photos/401',
        date: DateTime.now(),
        status: 'completed',
        dateOfFinishedOrCanceled: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<List<Order>> getAllUserOrders(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // OrderModel extends Order => يرجعوا عادي كـ List<Order>
    return _orders.where((o) => o.userId == userId).toList();
  }

  @override
  Future<String> addOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newId = 'fake_${DateTime.now().millisecondsSinceEpoch}';

    // الحل: نحول Order إلى OrderModel
    final model = OrderModel.fromOrder(order).copyWith(id: newId);

    _orders.add(model);
    return newId;
  }

  @override
  Future<void> updateImage(String docId, String newImage) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _orders.indexWhere((o) => o.id == docId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(image: newImage);
    }
  }

  @override
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: 'canceled',
        reasonIfCanceled: reasonOfCancel,
        dateOfFinishedOrCanceled: dateOfCancel,
      );
    }
  }

  @override
  Future<void> removeOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _orders.removeWhere((o) => o.id == orderId);
  }
}

extension on OrderModel {
  OrderModel copyWith({
    String? id,
    String? image,
    String? status,
    String? reasonIfCanceled,
    DateTime? dateOfFinishedOrCanceled,
  }) {
    return OrderModel(
      id: id ?? this.id,
      serviceGiverId: serviceGiverId,
      serviceGiverName: serviceGiverName,
      serviceGiverImage: serviceGiverImage,
      serviceGiverPhoneNumber: serviceGiverPhoneNumber,
      userId: userId,
      userName: userName,
      userImage: userImage,
      userPhoneNumber: userPhoneNumber,
      serviceName: serviceName,
      cost: cost,
      quantity: quantity,
      description: description,
      image: image ?? this.image,
      date: date,
      status: status ?? this.status,
      reasonIfCanceled: reasonIfCanceled ?? this.reasonIfCanceled,
      dateOfFinishedOrCanceled:
      dateOfFinishedOrCanceled ?? this.dateOfFinishedOrCanceled,
    );
  }
}
