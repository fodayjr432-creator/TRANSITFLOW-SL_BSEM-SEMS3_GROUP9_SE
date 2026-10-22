class DailyLog {
  final String logId;
  final String plateNumber;
  final double amount;
  final String feeType;
  final DateTime timestamp;

  DailyLog({
    required this.logId,
    required this.plateNumber,
    required this.amount,
    required this.feeType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    String time = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return '[$time] Type:${feeType.padLeft(12)} | Paid: Le ${amount.toStringAsFixed(2)} \vert{} Bike:$plateNumber';
  }
}
