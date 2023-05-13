part of 'pet_list_bloc.dart';

@immutable
abstract class PetListEvent {}

class GetFocusedCardPetListEvent extends PetListEvent{}

class GetAllPetListEvent extends PetListEvent{}