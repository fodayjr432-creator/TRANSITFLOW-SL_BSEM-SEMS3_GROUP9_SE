class Bike {
  final String plateNumber;
  final String riderId;
  final String model;
  bool isInspected;
  double totalDuesPaid;

  Bike({
    required this.plateNumber,
    required this.riderId,
    required this.model,
    this.isInspected = false,
    this.totalDuesPaid = 0.0,
  });
}
