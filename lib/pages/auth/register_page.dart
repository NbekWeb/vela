import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';

import '../../styles/base_styles.dart';
import '../../styles/pages/login_page_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../shared/widgets/how_work_modal.dart';
import '../../core/stores/auth_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isAgree = true;
  String? _termsError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailRegister() async {
    if (!_isAgree) {
      setState(() {
        _termsError = 'You must accept the Terms of Use.';
      });
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authStore = context.read<AuthStore>();
    await authStore.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      onSuccess: () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/plan');
        }
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        textInputAction: label == 'First name' ? TextInputAction.next : 
                        label == 'Last name' ? TextInputAction.next :
                        label == 'Email address' ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: label == 'First name' ? (_) => FocusScope.of(context).nextFocus() :
                         label == 'Last name' ? (_) => FocusScope.of(context).nextFocus() :
                         label == 'Email address' ? (_) => FocusScope.of(context).nextFocus() : 
                         (_) => FocusScope.of(context).unfocus(),
        keyboardType: label == 'Email address' ? TextInputType.emailAddress : 
                     label == 'Password' ? TextInputType.visiblePassword : TextInputType.text,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: Colors.white,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: LoginPageStyles.subtitleStyle.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: LoginPageStyles.subtitleStyle.copyWith(color: Color(0xFFDCE6F0)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: LoginPageStyles.translucentBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          isDense: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: LoginPageStyles.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: LoginPageStyles.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: LoginPageStyles.borderColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(onTap: onSuffixTap, child: suffixIcon)
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardVisibilityBuilder(
              controller: KeyboardVisibilityController(),
              builder: (context, isKeyboardVisible) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: StarsAnimation(),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: isKeyboardVisible ? 0 : 0,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    bottom: isKeyboardVisible ? 20 : 0,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            const SizedBox(height: 24),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: BaseStyles.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () => Navigator.of(context).maybePop(),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/icons/logo.svg',
                                                      width: 60,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.info_outline,
                                                    color: BaseStyles.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    openPopupFromTop(context, const HowWorkModal());
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),
                                            Center(
                                              child: Text(
                                                'Create an account',
                                                style: const TextStyle(
                                                  fontFamily: 'Canela',
                                                  fontSize: 32,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context, '/login');
                                                },
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: "Already have an account? ",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFFF2EFEA),
                                                      fontFamily: 'Satoshi',
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: 'Sign in',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontFamily: 'Satoshi',
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration.underline,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 36),
                                            _buildTextField(
                                              label: 'First name',
                                              controller: _firstNameController,
                                              validator: (value) => Validators.validateRequired(value, 'First name'),
                                            ),
                                            _buildTextField(
                                              label: 'Last name',
                                              controller: _lastNameController,
                                              validator: (value) => Validators.validateRequired(value, 'Last name'),
                                            ),
                                            _buildTextField(
                                              label: 'Email address',
                                              controller: _emailController,
                                              validator: Validators.validateEmail,
                                            ),
                                            _buildTextField(
                                              label: 'Password',
                                              controller: _passwordController,
                                              obscure: _obscurePassword,
                                              validator: Validators.validatePassword,
                                              suffixIcon: Icon(
                                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                                color: Color(0xFFF2EFEA),
                                              ),
                                              onSuffixTap: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: _isAgree,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      _isAgree = val ?? false;
                                                      if (_isAgree) _termsError = null;
                                                    });
                                                  },
                                                  activeColor: const Color(0xFF3C6EAB),
                                                  checkColor: Colors.white,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isAgree = !_isAgree;
                                                        if (_isAgree) _termsError = null;
                                                      });
                                                    },
                                                    child: Text(
                                                      'I agree to the Terms of Use',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Satoshi',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (_termsError != null)
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                                                child: Text(
                                                  _termsError!,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontFamily: 'Satoshi',
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF3C6EAB),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  elevation: 2,
                                                ),
                                                onPressed: authStore.isLoading ? null : _handleEmailRegister,
                                                child: authStore.isLoading
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                        ),
                                                      )
                                                    : const Text(
                                                        'Continue with Email',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'Satoshi',
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                        SizedBox(height: isKeyboardVisible ? 20 : MediaQuery.of(context).size.height * 0.2),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isKeyboardVisible)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 40,
                          child: Center(
                            child: Text(
                              'By using Vela you agree to our Terms of Use',
                              style: TextStyle(
                                color: Color(0xFFDCE6F0),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: -0.5,
                                height: 21 / 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void openPopupFromTop(BuildContext context, Widget child) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha((0.3 * 255).toInt()),
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
