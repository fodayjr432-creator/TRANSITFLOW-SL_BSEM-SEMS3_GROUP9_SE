import 'dart:io';
import '../controllers/union_controller.dart';
import '../services/rider_service.dart';
import '../config/theme.dart';
import 'rider_dashboard.dart';
import '../models/rider.dart';
import '../models/bike.dart';

class TerminalUI {
  final UnionController _unionController;
  final RiderService _riderService;
  final RiderDashboard _riderDashboard;

  TerminalUI(RiderService riderService)
      : _riderService = riderService,
        _unionController = UnionController(riderService),
        _riderDashboard = RiderDashboard(riderService);

  void start() {
    while (true) {
      print('\x1B[2J\x1B[01;01H');
      print('${AppTheme.cyan}${AppTheme.bold}${AppTheme.divider()}');
      print('          TRANSITFLOW SL: COMMERCIAL BIKE UNION MANAGEMENT (SDG 11)          ');
      print('${AppTheme.divider()}${AppTheme.reset}');
      print('${AppTheme.yellow}1.${AppTheme.reset} Register New Rider & Motorcycle');
      print('${AppTheme.yellow}2.${AppTheme.reset} Rider Login Portal (Password Secure)');
      print('${AppTheme.yellow}3.${AppTheme.reset} View Registered Riders Directory (Table View)');
      print('${AppTheme.yellow}4.${AppTheme.reset} View Union Analytics & Revenue Summary');
      print('${AppTheme.yellow}5.${AppTheme.reset} Exit Application');
      stdout.write('\n${AppTheme.blue}Select an option (1-5): ${AppTheme.reset}');

      String? choice = stdin.readLineSync()?.trim();

      switch (choice) {
        case '1':
          _menuRegisterRider();
          break;
        case '2':
          _menuAccessPortal();
          break;
        case '3':
          _menuListRidersTable();
          break;
        case '4':
          _menuAnalytics();
          break;
        case '5':
          print('\n${AppTheme.green}Thank you for using TransitFlow SL. Shutting down...${AppTheme.reset}');
          return;
        default:
          print('\n${AppTheme.red}[Error] Invalid selection. Press Enter to retry.${AppTheme.reset}');
          stdin.readLineSync();
      }
    }
  }

  void _menuRegisterRider() {
    print('\x1B[2J\x1B[01;01H');
    print('${AppTheme.cyan}${AppTheme.bold}--- REGISTER NEW BIKE RIDER ---${AppTheme.reset}');
    stdout.write('Enter Unique Rider ID (e.g., R003): ');
    String riderId = stdin.readLineSync()!.trim();

    stdout.write('Enter Full Name: ');
    String name = stdin.readLineSync()!.trim();

    stdout.write('Enter Phone Number: ');
    String phone = stdin.readLineSync()!.trim();

    stdout.write('Enter License Number: ');
    String license = stdin.readLineSync()!.trim();

    stdout.write('Enter Station Zone (e.g., Lumley): ');
    String zone = stdin.readLineSync()!.trim();

    stdout.write('Set Portal Password: ');
    String password = stdin.readLineSync()!.trim();

    stdout.write('Enter Bike Plate Number (e.g., BKE-303): ');
    String plate = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write('Enter Bike Model (e.g., TVS Star): ');
    String model = stdin.readLineSync()!.trim();

    String result = _unionController.handleRegistration(
      riderId: riderId,
      name: name,
      phone: phone,
      license: license,
      zone: zone,
      password: password,
      plate: plate,
      model: model,
    );

    if (result.startsWith('SUCCESS')) {
      print('\n${AppTheme.green}$result${AppTheme.reset}');
    } else {
      print('\n${AppTheme.red}$result${AppTheme.reset}');
    }
    _pause();
  }

  void _menuAccessPortal() {
    print('\x1B[2J\x1B[01;01H');
    print('${AppTheme.cyan}${AppTheme.bold}--- RIDER LOGIN PORTAL ---${AppTheme.reset}');
    stdout.write('Enter Rider ID or Bike Plate: ');
    String query = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write('Enter Password: ');
    String password = stdin.readLineSync()!.trim();

    Rider? rider = _unionController.verifyLogin(query, password);
    if (rider == null) {
      print('${AppTheme.red}[Error] Invalid credentials or incorrect password.${AppTheme.reset}');
      _pause();
      return;
    }

    Bike bike = _riderService.getAllBikes().firstWhere((b) => b.riderId == rider.riderId);

    print('\n${AppTheme.green}[Success] Password verified. Welcome ${rider.fullName}!${AppTheme.reset}');
    _pause();
    _riderDashboard.showPortal(rider, bike);
  }

  void _menuListRidersTable() {
    print('\x1B[2J\x1B[01;01H');
    print('${AppTheme.cyan}${AppTheme.bold}--- REGISTERED RIDERS DIRECTORY ---${AppTheme.reset}');
    var riders = _riderService.getAllRiders();
    var bikes = _riderService.getAllBikes();

    if (riders.isEmpty) {
      print('No riders registered yet.');
    } else {
      print('+--------+----------------------+---------------+-----------------+-------------------+-------------+');
      print('| ID     | FULL NAME            | PHONE NUMBER  | ZONE STATION    | BIKE PLATE (MODEL)| DUES PAID   |');
      print('+--------+----------------------+---------------+-----------------+-------------------+-------------+');
      for (var r in riders) {
        Bike b = bikes.firstWhere((element) => element.riderId == r.riderId);
        String idCol = r.riderId.padRight(6);
        String nameCol = r.fullName.padRight(20);
        String phoneCol = r.phoneNumber.padRight(13);
        String zoneCol = r.zoneStation.padRight(15);
        String bikeCol = '${b.plateNumber}'.padRight(17);
        String duesCol = 'Le ${b.totalDuesPaid.toStringAsFixed(0)}'.padRight(11);

        print('| $idCol | $nameCol | $phoneCol | $zoneCol | $bikeCol | $duesCol |');
      }
      print('+--------+----------------------+---------------+-----------------+-------------------+-------------+');
    }
    _pause();
  }

  void _menuAnalytics() {
    print('\x1B[2J\x1B[01;01H');
    print('${AppTheme.cyan}${AppTheme.bold}--- UNION ANALYTICS & REVENUE SUMMARY (SDG 11) ---${AppTheme.reset}');
    var stats = _unionController.fetchAnalytics();
    print('Total Registered Riders : ${stats['ridersCount']}');
    print('Total Registered Bikes  : ${stats['bikesCount']}');
    print('Inspected Motorbikes    : ${stats['inspectedCount']}');
    print('Total Union Revenue     : Le ${stats['totalRevenue'].toStringAsFixed(2)}');
    _pause();
  }

  void _pause() {
    stdout.write('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}
