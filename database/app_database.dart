// System database
import '../models/rider.dart';
import '../models/bike.dart';
import '../models/daily_log.dart';

class AppDatabase {
  final Map<String, Rider> riders = {
    'R001': Rider(
      riderId: 'R001',
      fullName: 'Alhaji Bah',
      phoneNumber: '076123456',
      licenseNumber: 'SL-LIC-9981',
      zoneStation: 'Lumley Junction',
      password: 'pass123',
    ),
    'R002': Rider(
      riderId: 'R002',
      fullName: 'Siddiq Kamara',
      phoneNumber: '088987654',
      licenseNumber: 'SL-LIC-4432',
      zoneStation: 'Central Station',
      password: 'pass123',
    ),
  };

  final Map<String, Bike> bikes = {
    'BKE-101': Bike(
      plateNumber: 'BKE-101',
      riderId: 'R001',
      model: 'Bajaj Boxer 150',
      isInspected: true,
      totalDuesPaid: 75000.0,
    ),
    'BKE-202': Bike(
      plateNumber: 'BKE-202',
      riderId: 'R002',
      model: 'TVS Star HLX',
      isInspected: false,
      totalDuesPaid: 45000.0,
    ),
  };

  final List<DailyLog> logs = [
    DailyLog(
      logId: 'LOG-001',
      plateNumber: 'BKE-101',
      amount: 25000.0,
      feeType: 'Daily Levy',
    ),
    DailyLog(
      logId: 'LOG-002',
      plateNumber: 'BKE-202',
      amount: 15000.0,
      feeType: 'Safety Fine',
    ),
  ];
}
