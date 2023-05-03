part of 'health_check_bloc.dart';

@immutable
abstract class HealthCheckEvent {}

class UploadFecesHealthCheckEvent extends HealthCheckEvent{
  final int petId;
  final File img;

  UploadFecesHealthCheckEvent(this.petId, this.img);
}

class GetLastHealthCheckEvent extends HealthCheckEvent{
  final int petId;

  GetLastHealthCheckEvent(this.petId);
}