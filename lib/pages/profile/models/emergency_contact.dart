class EmergencyContact {
  String? firstName;
  String? lastName;
  String? relationship;
  String? phoneNumber;

  EmergencyContact(
      {this.firstName, this.lastName, this.relationship, this.phoneNumber});

  EmergencyContact.fromJson(Map<String, dynamic> json) {
    this.firstName = json['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    return data;
  }
}
