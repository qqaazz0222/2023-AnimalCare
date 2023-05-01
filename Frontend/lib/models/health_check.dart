import 'dart:io';

class HealthCheck {
  final int logId;
  final int logYear;
  final int logMonth;
  final int logDay;
  final File logImg;
  final String logResult;
  final int petId;

  HealthCheck(this.logId, this.logYear, this.logMonth, this.logDay, this.logImg, this.logResult, this.petId);
}