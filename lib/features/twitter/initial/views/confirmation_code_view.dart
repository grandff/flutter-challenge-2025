import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../view_model/signup_view_model.dart';
import '../widgets/twitter_app_header.dart';
import 'password_view.dart';

class ConfirmationCodeView extends ConsumerStatefulWidget {
  const ConfirmationCodeView({super.key});

  @override
  ConsumerState<ConfirmationCodeView> createState() =>
      _ConfirmationCodeViewState();
}

class _ConfirmationCodeViewState extends ConsumerState<ConfirmationCodeView> {
  static const int _codeLength = 6;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      _isComplete = _controllers.every((c) => c.text.isNotEmpty);
    });

    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Widget _buildOtpBox(BuildContext context, int index) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 44,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (e) {
          _onKey(e, index);
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          autofocus: index == 0,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: const InputDecoration(
            isDense: true,
            counterText: '',
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD3D8DE), width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          onChanged: (v) => _onChanged(v, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signup = ref.watch(signupViewModelProvider);

    final contactValue = signup.contact;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TwitterAppHeader(
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Text(
                      'We sent you a code',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      'Enter it below to verify $contactValue.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    Gaps.v60,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          _codeLength, (i) => _buildOtpBox(context, i)),
                    ),
                    Gaps.v24,
                    if (_isComplete)
                      const Center(
                        child: Icon(Icons.check_circle,
                            color: Colors.green, size: 28),
                      )
                    else
                      Gaps.v28,
                    Gaps.v40,
                    Text(
                      "Didn't receive email?",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: const Color(0xFF1DA1F2)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.size16),
              child: SizedBox(
                width: double.infinity,
                height: Sizes.size56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isComplete ? Colors.black : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: _isComplete
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PasswordView(),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
