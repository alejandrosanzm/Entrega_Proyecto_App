class Hospital {
  int id;
  String name;
  bool isSelected = false;

  Hospital({this.id, this.name});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(id: json['id'], name: json['name']);
  }
}
