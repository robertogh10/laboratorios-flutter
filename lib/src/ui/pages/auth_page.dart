import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/auth_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

enum AuthPageMode { login, register }

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({required this.mode, super.key});

  final AuthPageMode mode;

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool get _isLogin {
    return widget.mode == AuthPageMode.login;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final authState = ref.watch(authControllerProvider);
    final firebaseEnabled = ref.watch(firebaseEnabledProvider);
    final errorText = authState.whenOrNull(
      error: (error, stackTrace) => error.toString(),
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 430;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(38, 32, 38, 20 + bottomPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - bottomPadding - 52,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _AuthMark(),
                      SizedBox(height: isNarrow ? 36 : 48),
                      Text(
                        _isLogin ? 'Welcome back' : 'Create your account',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _isLogin
                            ? 'Sign in to continue your shopping experience.'
                            : 'Register with your email and password.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 42),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _AuthTextField(
                              key: const ValueKey('auth-email-field'),
                              controller: _emailController,
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 14),
                            _AuthTextField(
                              key: const ValueKey('auth-password-field'),
                              controller: _passwordController,
                              label: 'Password',
                              obscureText: _obscurePassword,
                              validator: _validatePassword,
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 16),
                        _AuthMessage(text: errorText),
                      ],
                      if (!firebaseEnabled) ...[
                        const SizedBox(height: 16),
                        const _AuthMessage(
                          text:
                              'Firebase no esta configurado. Puedes entrar en modo demo para desarrollo local.',
                        ),
                      ],
                      const Spacer(),
                      const SizedBox(height: 34),
                      PrimaryButton(
                        label: authState.isLoading
                            ? 'Please wait...'
                            : _isLogin
                            ? 'Sign in'
                            : 'Create account',
                        onPressed: authState.isLoading ? () {} : _submit,
                      ),
                      if (!firebaseEnabled) ...[
                        const SizedBox(height: 12),
                        _SecondaryActionButton(
                          key: const ValueKey('auth-demo-button'),
                          label: 'Continue in demo mode',
                          onPressed: () => context.go(AppRoutes.storeHome),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.go(
                              _isLogin ? AppRoutes.register : AppRoutes.login,
                            );
                          },
                          child: Text(
                            _isLogin
                                ? 'Create a new account'
                                : 'I already have an account',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    final controller = ref.read(authControllerProvider.notifier);

    if (_isLogin) {
      await controller.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      await controller.register(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    if (!mounted || ref.read(authControllerProvider).hasError) {
      return;
    }

    context.go(AppRoutes.storeHome);
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Enter your email.';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.length < 6) {
      return 'Use at least 6 characters.';
    }

    return null;
  }
}

class _AuthMark extends StatelessWidget {
  const _AuthMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.lock_outline, color: Color(0xFF0A7CFF), size: 34),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        border: _border(const Color(0xFFD5D7DB)),
        enabledBorder: _border(const Color(0xFFD5D7DB)),
        focusedBorder: _border(const Color(0xFF0A7CFF), width: 2),
        errorBorder: _border(Theme.of(context).colorScheme.error),
        focusedErrorBorder: _border(
          Theme.of(context).colorScheme.error,
          width: 2,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _AuthMessage extends StatelessWidget {
  const _AuthMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF202129),
          height: 1.35,
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0A7CFF),
          side: const BorderSide(color: Color(0xFF0A7CFF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
