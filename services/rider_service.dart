import '../database/app_database.dart';
import '../models/rider.dart';
import '../models/bike.dart';
import '../models/daily_log.dart';

class RiderService {
  final AppDatabase _db = AppDatabase();

  bool riderExists(String riderId) => _db.riders.containsKey(riderId);
  bool bikeExists(String plate) => _db.bikes.containsKey(plate);

  Rider getRider(String riderId) => _db.riders[riderId]!;
  Bike getBike(String plate) => _db.bikes[plate]!;

  List<Rider> getAllRiders() => _db.riders.values.toList();
  List<Bike> getAllBikes() => _db.bikes.values.toList();
  List<DailyLog> getAllLogs() => _db.logs;

  Rider? authenticateRider(String query, String password) {
    Rider? target;
    if (_db.riders.containsKey(query)) {
      target = _db.riders[query];
    } else if (_db.bikes.containsKey(query)) {
      Bike b = _db.bikes[query]!;
      target = _db.riders[b.riderId];
    }
    if (target != null && target.password == password) {
      return target;
    }
    return null;
  }

  String registerRiderWithBike({
    required String riderId,
    required String fullName,
    required String phone,
    required String license,
    required String zone,
    required String password,
    required String plate,
    required String model,
  }) {
    if (_db.riders.containsKey(riderId)) {
      return 'ERROR: Rider ID already registered.';
    }
    if (_db.bikes.containsKey(plate)) {
      return 'ERROR: Bike plate number already registered.';
    }

    _db.riders[riderId] = Rider(
      riderId: riderId,
      fullName: fullName,
      phoneNumber: phone,
      licenseNumber: license,
      zoneStation: zone,
      password: password,
    );

    _db.bikes[plate] = Bike(
      plateNumber: plate,
      riderId: riderId,
      model: model,
      isInspected: true,
      totalDuesPaid: 0.0,
    );

    return 'SUCCESS: Rider and motorcycle registered successfully.';
  }

  String recordDailyPayment({
    required String plate,
    required double amount,
    required String feeType,
  }) {
    if (!_db.bikes.containsKey(plate)) {
      return 'ERROR: Bike plate number not found in database.';
    }
    if (amount <= 0) {
      return 'ERROR: Invalid payment amount.';
    }

    Bike bike = _db.bikes[plate]!;
    bike.totalDuesPaid += amount;

    String logId = 'LOG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    _db.logs.add(DailyLog(
      logId: logId,
      plateNumber: plate,
      amount: amount,
      feeType: feeType,
    ));

    return 'SUCCESS: Paid Le ${amount.toStringAsFixed(2)} ($feeType) for $plate successfully.';
  }
}
