part of 'health_check_bloc.dart';

@immutable
abstract class HealthCheckEvent {}

class UploadFecesHealthCheckEvent extends HealthCheckEvent{
  final int petId;
  // final http.ByteStream img;
  final File img;
  final int imgLength;

  UploadFecesHealthCheckEvent(this.petId, this.img, this.imgLength);
  // UploadFecesHealthCheckEvent(this.petId);
}