import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../widgets/twitter_app_header.dart';
import '../view_model/signup_view_model.dart';
import 'customize_experience_view.dart';

class CreateAccountView extends ConsumerStatefulWidget {
  const CreateAccountView({super.key});

  @override
  ConsumerState<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends ConsumerState<CreateAccountView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final FocusNode _contactFocus = FocusNode();

  DateTime? _selectedDob;
  bool _showEmailError = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldsChanged);
    _contactController.addListener(_onFieldsChanged);
    _contactFocus.addListener(() {
      if (!_contactFocus.hasFocus) {
        // Lost focus: show error for invalid email input
        final text = _contactController.text.trim();
        final isEmail = !_isPhone(text);
        final emailValid = isEmail ? _isValidEmail(text) : true;
        setState(() {
          _showEmailError = isEmail && text.isNotEmpty && !emailValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _dobController.dispose();
    _contactFocus.dispose();
    super.dispose();
  }

  void _onFieldsChanged() {
    setState(() {});
  }

  bool get _isNameValid {
    final text = _nameController.text.trim();
    return text.isNotEmpty && text.length <= 10;
  }

  bool get _isContactValid {
    final text = _contactController.text.trim();
    if (text.isEmpty || text.length > 50) return false;
    if (_isPhone(text)) return true;
    return _isValidEmail(text);
  }

  bool _isPhone(String text) {
    return RegExp(r'^[0-9\-]+$').hasMatch(text);
  }

  bool _isValidEmail(String text) {
    // Simple but practical email regex
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$');
    return emailRegex.hasMatch(text);
  }

  bool get _isAllValid =>
      _isNameValid && _isContactValid && _selectedDob != null;

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDobCupertino() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    DateTime temp = _selectedDob ?? DateTime(now.year - 20);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() {
                          _selectedDob = temp;
                          _dobController.text = _formatDate(temp);
                        });
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: temp,
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(1900),
                  maximumDate: now,
                  onDateTimeChanged: (dt) {
                    temp = dt;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    );

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TwitterAppHeader(
                showCancel: true,
                onCancel: () => Navigator.pop(context),
              ),
              Gaps.v40,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Gaps.v20,
                    TextField(
                      controller: _nameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        enabledBorder: border,
                        focusedBorder: border,
                        suffixIcon: _isNameValid
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        counterText: '',
                      ),
                    ),
                    Gaps.v20,
                    TextField(
                      controller: _contactController,
                      focusNode: _contactFocus,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: _isPhone(_contactController.text)
                            ? 'Phone number'
                            : 'Email',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        enabledBorder: border,
                        focusedBorder: border,
                        errorText: _showEmailError
                            ? 'Please enter a valid email address.'
                            : null,
                        suffixIcon: _isContactValid &&
                                _contactController.text.isNotEmpty
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        counterText: '',
                      ),
                    ),
                    Gaps.v20,
                    GestureDetector(
                      onTap: _pickDobCupertino,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of birth',
                            hintText: _selectedDob == null
                                ? null
                                : _dobController.text,
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            enabledBorder: border,
                            focusedBorder: border,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: Sizes.size16,
                  bottom: Sizes.size16,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _isAllValid
                          ? const Color(0xFF1DA1F2)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: InkWell(
                      onTap: _isAllValid
                          ? () {
                              final name = _nameController.text.trim();
                              final contact = _contactController.text.trim();
                              final isEmail = !_isPhone(contact);
                              final dob = _dobController.text.trim();
                              ref
                                  .read(signupViewModelProvider.notifier)
                                  .setBasicInfo(
                                    name: name,
                                    contact: contact,
                                    isEmail: isEmail,
                                    dateOfBirth: dob,
                                  );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CustomizeExperienceView(),
                                ),
                              );
                            }
                          : null,
                      borderRadius: BorderRadius.circular(32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                          vertical: Sizes.size10,
                        ),
                        child: Text(
                          'Next',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
