class SignupModel {
  final String name;
  final String contact;
  final bool isEmail;
  final String dateOfBirth; // formatted as YYYY-MM-DD
  final bool trackAcrossWeb;

  SignupModel({
    required this.name,
    required this.contact,
    required this.isEmail,
    required this.dateOfBirth,
    required this.trackAcrossWeb,
  });

  SignupModel.empty()
      : name = '',
        contact = '',
        isEmail = true,
        dateOfBirth = '',
        trackAcrossWeb = true;

  SignupModel.fromJson({required Map<String, dynamic> json})
      : name = json['name'] ?? '',
        contact = json['contact'] ?? '',
        isEmail = json['isEmail'] ?? true,
        dateOfBirth = json['dateOfBirth'] ?? '',
        trackAcrossWeb = json['trackAcrossWeb'] ?? true;

  Map<String, dynamic> toJson() => {
        'name': name,
        'contact': contact,
        'isEmail': isEmail,
        'dateOfBirth': dateOfBirth,
        'trackAcrossWeb': trackAcrossWeb,
      };
}




