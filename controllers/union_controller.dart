import '../services/rider_service.dart';
import '../models/rider.dart';

class UnionController {
  final RiderService _riderService;

  UnionController(this._riderService);

  String handleRegistration({
    required String riderId,
    required String name,
    required String phone,
    required String license,
    required String zone,
    required String password,
    required String plate,
    required String model,
  }) {
    if (riderId.isEmpty || name.isEmpty || phone.isEmpty || plate.isEmpty || password.isEmpty) {
      return 'ERROR: All mandatory fields including password must be filled.';
    }
    return _riderService.registerRiderWithBike(
      riderId: riderId,
      fullName: name,
      phone: phone,
      license: license,
      zone: zone,
      password: password,
      plate: plate,
      model: model,
    );
  }

  Rider? verifyLogin(String query, String password) {
    return _riderService.authenticateRider(query, password);
  }

  Map<String, dynamic> fetchAnalytics() {
    List<Rider> riders = _riderService.getAllRiders();
    var bikes = _riderService.getAllBikes();
    double totalRevenue = bikes.fold(0.0, (sum, b) => sum + b.totalDuesPaid);
    int inspectedCount = bikes.where((b) => b.isInspected).length;

    return {
      'ridersCount': riders.length,
      'bikesCount': bikes.length,
      'totalRevenue': totalRevenue,
      'inspectedCount': inspectedCount,
    };
  }
}
