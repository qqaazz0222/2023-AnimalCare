part of 'health_check_bloc.dart';

@immutable
abstract class HealthCheckEvent {}

class UploadFecesHealthCheckEvent extends HealthCheckEvent{
  final int petId;
  final File img;

  UploadFecesHealthCheckEvent(this.petId, this.img);
  // UploadFecesHealthCheckEvent(this.petId);
}

class GetLastHealthCheckEvent extends HealthCheckEvent{

}