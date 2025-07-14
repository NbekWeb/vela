import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../styles/base_styles.dart';
import '../../styles/pages/login_page_styles.dart';
import '../../shared/widgets/how_work_modal.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    final authService = AuthService();
    final userData = await authService.signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    if (userData != null && mounted) {
      Navigator.pushReplacementNamed(context, '/plan');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In was cancelled or an error occurred'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final userData = await authService.loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userData != null && mounted) {
        Navigator.pushReplacementNamed(context, '/plan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  Widget _buildSocialButton({
    required String asset,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: const Color(0xFF3B6EAA),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SvgPicture.asset(asset, width: 28, height: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              const StarsAnimation(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 40,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  'Continue to sign in',
                                  style: LoginPageStyles.titleStyle.copyWith(fontSize: 32, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  "If you already have an account, we'll log you in.",
                                  style: LoginPageStyles.subtitleStyle.copyWith(color: Color(0xFFF2EFEA)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 36),
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
                                  onPressed: _isLoading ? null : _handleEmailLogin,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: LoginPageStyles.orContinueStyle,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 48),
                              Center(
                                child: Text(
                                  '- or continue with -',
                                  style: LoginPageStyles.orContinueStyle.copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialButton(asset: 'assets/icons/apple.svg', onTap: () {}),
                                  const SizedBox(width: 16),
                                  _buildSocialButton(asset: 'assets/icons/google.svg', onTap: _isLoading ? (){} : _handleGoogleSignIn),
                                  const SizedBox(width: 16),
                                  _buildSocialButton(asset: 'assets/icons/facebook.svg', onTap: () {}),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: LoginPageStyles.subtitleStyle.copyWith(color: Color(0xFFDCE6F0)),
                                      children: [
                                        TextSpan(
                                          text: 'Sign up',
                                          style: LoginPageStyles.orContinueStyle.copyWith(
                                            color: Color(0xFFDCE6F0),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Center(
                  child: Text(
                    'By using Vela you agree to our Terms',
                    style: LoginPageStyles.signUpTextStyle.copyWith(
                      color: Color(0xFFDCE6F0),
                      fontSize: 14,
                      letterSpacing: -0.5,
                      height: 21/12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
