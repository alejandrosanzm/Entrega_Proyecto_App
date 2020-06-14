import 'hospital.dart';

class HospitalContainer {
  List<Hospital> hospitals;

  HospitalContainer({this.hospitals});

  factory HospitalContainer.fromJson(List<dynamic> json) {
    List<Hospital> hospitals = json.map((i) => Hospital.fromJson(i)).toList();

    return HospitalContainer(
      hospitals: hospitals,
    );
  }
}
