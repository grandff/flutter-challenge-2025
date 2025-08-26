import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/signup_model.dart';

final signupViewModelProvider =
    StateNotifierProvider<SignupViewModel, SignupModel>((ref) {
  return SignupViewModel();
});

class SignupViewModel extends StateNotifier<SignupModel> {
  SignupViewModel() : super(SignupModel.empty());

  void setBasicInfo({
    required String name,
    required String contact,
    required bool isEmail,
    required String dateOfBirth,
  }) {
    state = SignupModel(
      name: name,
      contact: contact,
      isEmail: isEmail,
      dateOfBirth: dateOfBirth,
      trackAcrossWeb: state.trackAcrossWeb,
    );
  }

  void setTrackAcrossWeb(bool value) {
    state = SignupModel(
      name: state.name,
      contact: state.contact,
      isEmail: state.isEmail,
      dateOfBirth: state.dateOfBirth,
      trackAcrossWeb: value,
    );
  }
}
