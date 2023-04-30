part of 'pet_bloc.dart';

class PetState {
  final Pet? selectedPet;
  final bool isLoading;

  PetState({this.selectedPet, this.isLoading = false});

  PetState copyWith({
    Pet? selectedPet,
    bool isLoading = false,
  })
  {
    return PetState(
      selectedPet: selectedPet ?? this.selectedPet,
      isLoading: isLoading
    );
  }
}