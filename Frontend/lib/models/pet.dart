import 'dart:io';

class Pet {
  final int petId;
  final String petName;
  final String petSex;
  final int petBirthYear;
  final int petBirthMonth;
  final int petAdoptYear;
  final int petAdoptMonth;
  final double petWeight;
  final File? petImg;
  final String uid;

  Pet(this.petId, this.petName, this.petSex, this.petBirthYear, this.petBirthMonth, this.petAdoptYear, this.petAdoptMonth, this.petWeight, this.petImg, this.uid);
}