class CheckInCheckOut {
  String? centerId;
  String? timestamp;

  CheckInCheckOut({required this.centerId, required this.timestamp});

  CheckInCheckOut.fromJson(Map<String, dynamic> json)
      : centerId = json['centerId'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() {
    return {
      'centerId': centerId,
      'timestamp': timestamp,
    };
  }
}
