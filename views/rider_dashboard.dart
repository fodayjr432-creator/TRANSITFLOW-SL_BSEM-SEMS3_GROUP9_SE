import 'dart:io';
import '../models/rider.dart';
import '../models/bike.dart';
import '../services/rider_service.dart';
import '../config/theme.dart';

class RiderDashboard {
  final RiderService _riderService;

  RiderDashboard(this._riderService);

  void showPortal(Rider rider, Bike bike) {
    while (true) {
      print('\x1B[2J\x1B[01;01H');
      print('${AppTheme.cyan}${AppTheme.bold}${AppTheme.divider()}');
      print('  TRANSITFLOW SL | RIDER PORTAL: ${rider.fullName} (${bike.plateNumber})');
      print('${AppTheme.divider()}${AppTheme.reset}');
      print('${AppTheme.yellow}1.${AppTheme.reset} View Profile & Bike Compliance');
      print('${AppTheme.yellow}2.${AppTheme.reset} Direct Online Payment (Levy/Fine/Permit)');
      print('${AppTheme.yellow}3.${AppTheme.reset} Payment Ledger & Audit Trail');
      print('${AppTheme.yellow}4.${AppTheme.reset} Logout to Main Menu');
      stdout.write('\n${AppTheme.blue}Choose action (1-4): ${AppTheme.reset}');

      String? choice = stdin.readLineSync()?.trim();

      switch (choice) {
        case '1':
          print('\n${AppTheme.green}${AppTheme.bold}--- COMPLIANCE PROFILE ---${AppTheme.reset}');
          print('Rider ID     : ${rider.riderId}');
          print('Full Name    : ${rider.fullName}');
          print('Phone Number : ${rider.phoneNumber}');
          print('License No   : ${rider.licenseNumber}');
          print('Station Zone : ${rider.zoneStation}');
          print('Bike Plate   : ${bike.plateNumber} (${bike.model})');
          print('Inspection   : ${bike.isInspected ? "PASSED" : "PENDING"}');
          print('Total Paid   : Le ${bike.totalDuesPaid.toStringAsFixed(2)}');
          _pause();
          break;
        case '2':
          _handleDirectPayment(bike);
          break;
        case '3':
          _handleHistoryPrompt(bike);
          break;
        case '4':
          return;
        default:
          print('\n${AppTheme.red}[Error] Invalid option. Choose 1-4.${AppTheme.reset}');
          _pause();
      }
    }
  }

  void _handleDirectPayment(Bike bike) {
    print('\n${AppTheme.cyan}${AppTheme.bold}--- DIRECT UNION PAYMENT GATEWAY ---${AppTheme.reset}');
    print('Select Payment Purpose:');
    print('1. Daily Levy (Le 25,000)');
    print('2. Safety Fine (Le 15,000)');
    print('3. Annual Permit (Le 100,000)');
    print('4. Custom Amount');
    stdout.write('Choice (1-4): ');
    String? pChoice = stdin.readLineSync()?.trim();

    double amount = 0.0;
    String feeType = 'Daily Levy';

    if (pChoice == '1') {
      amount = 25000.0;
      feeType = 'Daily Levy';
    } else if (pChoice == '2') {
      amount = 15000.0;
      feeType = 'Safety Fine';
    } else if (pChoice == '3') {
      amount = 100000.0;
      feeType = 'Annual Permit';
    } else if (pChoice == '4') {
      stdout.write('Enter Custom Amount (Le): ');
      amount = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
      feeType = 'Custom Payment';
    } else {
      print('${AppTheme.red}[Error] Invalid selection.${AppTheme.reset}');
      _pause();
      return;
    }

    if (amount <= 0) {
      print('${AppTheme.red}[Error] Payment amount must be greater than 0.${AppTheme.reset}');
      _pause();
      return;
    }

    String result = _riderService.recordDailyPayment(
      plate: bike.plateNumber,
      amount: amount,
      feeType: feeType,
    );
    print('\n${AppTheme.green}$result${AppTheme.reset}');
    _pause();
  }

  void _handleHistoryPrompt(Bike bike) {
    print('\n${AppTheme.cyan}${AppTheme.bold}--- PERSONAL PAYMENT LEDGER ---${AppTheme.reset}');
    var bikeLogs = _riderService.getAllLogs().where((l) => l.plateNumber == bike.plateNumber).toList();
    if (bikeLogs.isEmpty) {
      print('No transaction records found.');
    } else {
      for (var log in bikeLogs) {
        print(log);
      }
    }
    _pause();
  }

  void _pause() {
    stdout.write('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}
