import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool isNavigationButton;
  final IconData? icon;

  const CommonButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.child,
    this.padding,
    this.isNavigationButton = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 네비게이션 버튼과 액션 버튼을 구분
    final bool isNav = isNavigationButton;
    final bool isDisabled = !isEnabled || isLoading;

    final Color bgColor = isNav
        ? Colors.transparent
        : (isDisabled
            ? Colors.grey[300]!
            : (backgroundColor ?? const Color(0xFFF9A8D4)));
    final Color txtColor = isNav
        ? (isDisabled ? Colors.grey : Colors.black)
        : (isDisabled ? Colors.grey[600]! : (textColor ?? Colors.black));
    final List<BoxShadow> shadows = isNav || isDisabled
        ? []
        : const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: Offset(4, 4),
            ),
          ];
    final Border? border = isNav
        ? null
        : Border.all(color: isDisabled ? Colors.grey : Colors.black, width: 1);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        border: border,
        boxShadow: shadows,
      ),
      child: ElevatedButton(
        onPressed: (isLoading || !isEnabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: padding,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : child ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: txtColor,
                        fontSize: fontSize ?? 16,
                        fontWeight: fontWeight ?? FontWeight.w600,
                        decoration: isNav
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: txtColor,
                        decorationThickness: 2,
                      ),
                    ),
                    if (isNav && icon != null) ...[
                      const SizedBox(width: 8),
                      HugeIcon(
                        icon: icon!,
                        color: txtColor,
                        size: 20,
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}

// 특화된 버튼들
class AuthMainButton extends StatelessWidget {
  final bool isSignUp;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const AuthMainButton({
    super.key,
    required this.isSignUp,
    required this.isLoading,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButtonWidget(
      text: isSignUp ? 'Create Account' : 'Enter',
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}

class AuthToggleButton extends StatelessWidget {
  final bool isSignUp;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const AuthToggleButton({
    super.key,
    required this.isSignUp,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButtonWidget(
      text: isSignUp ? 'Log in' : 'Create an account',
      onPressed: onPressed,
      isEnabled: isEnabled,
      isNavigationButton: true,
      icon: HugeIcons.strokeRoundedArrowRight01,
    );
  }
}
