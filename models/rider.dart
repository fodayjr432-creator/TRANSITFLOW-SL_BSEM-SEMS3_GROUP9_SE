class Rider {
  final String riderId;
  final String fullName;
  final String phoneNumber;
  final String licenseNumber;
  final String zoneStation;
  final String password;
  final DateTime registrationDate;

  Rider({
    required this.riderId,
    required this.fullName,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.zoneStation,
    required this.password,
    DateTime? registrationDate,
  }) : registrationDate = registrationDate ?? DateTime.now();
}
