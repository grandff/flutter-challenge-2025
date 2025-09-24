class AuthModel {
  final String email;
  final String password;
  final String? userId;
  final String? sessionToken;
  final bool isAuthenticated;

  AuthModel({
    required this.email,
    required this.password,
    this.userId,
    this.sessionToken,
    this.isAuthenticated = false,
  });

  // Returns an empty instance
  AuthModel.empty()
      : email = "",
        password = "",
        userId = null,
        sessionToken = null,
        isAuthenticated = false;

  // Creates an instance from a JSON map
  AuthModel.fromJson({required Map<String, dynamic> json})
      : email = json["email"] ?? "",
        password = json["password"] ?? "",
        userId = json["userId"],
        sessionToken = json["sessionToken"],
        isAuthenticated = json["isAuthenticated"] ?? false;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "userId": userId,
        "sessionToken": sessionToken,
        "isAuthenticated": isAuthenticated,
      };

  // Copy with method for state updates
  AuthModel copyWith({
    String? email,
    String? password,
    String? userId,
    String? sessionToken,
    bool? isAuthenticated,
  }) {
    return AuthModel(
      email: email ?? this.email,
      password: password ?? this.password,
      userId: userId ?? this.userId,
      sessionToken: sessionToken ?? this.sessionToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  // Validation methods
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get isValidPassword {
    return password.length >= 6;
  }

  bool get isValidForm {
    return isValidEmail && isValidPassword;
  }
}







