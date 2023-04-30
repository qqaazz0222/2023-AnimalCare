part of 'pet_bloc.dart';

@immutable
abstract class PetEvent {}

class SelectPetEvent extends PetEvent{
  final int petId;

  SelectPetEvent(this.petId);
}