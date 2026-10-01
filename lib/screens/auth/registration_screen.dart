import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../../core/theme/app_colors.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  int _currentStep = 0;

  // Animations
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Registration Successful!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your account has been created.\nYou can now sign in to explore Gran Verde experiences.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pushReplacementNamed('/home'); // Go to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
            ),
            Positioned(
              top: -40,
              left: -50,
              child: Transform.rotate(
                angle: math.pi / 5,
                child: Icon(
                  Icons.spa_rounded,
                  size: 180,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: -40,
              child: Icon(
                Icons.eco_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      // ── Custom AppBar ────────────────────────────────
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 44),
                            ],
                          ),
                        ),
                      ),

                      // ── Step indicator ───────────────────────────────
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStepIndicator(),
                      ),

                      const SizedBox(height: 12),

                      // ── Form card ────────────────────────────────────
                      Expanded(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 6,
                              ),
                              child: _buildRegistrationCard(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
      child: Row(
        children: [
          _buildStepDot(0, 'Personal'),
          _buildStepLine(0),
          _buildStepDot(1, 'Security'),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.25),
            border: Border.all(
              color: isActive ? AppColors.accent : Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: isActive && _currentStep > step
                ? const Icon(Icons.check, size: 14, color: AppColors.primary)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.primary : Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Colors.white.withValues(alpha: isActive ? 0.95 : 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int afterStep) {
    final isActive = _currentStep > afterStep;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 2,
          color: isActive ? Colors.white.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildRegistrationCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visitor Registration',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Create your Gran Verde account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Full Name ────────────────────────────────────────
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.trim().split(' ').length < 2) {
                    return 'Please enter your first and last name';
                  }
                  return null;
                },
                onChanged: (_) => _updateStep(),
              ),
              const SizedBox(height: 14),

              // ── Email ────────────────────────────────────────────
              _buildLabel('Email Address'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (_) => _updateStep(),
              ),
              const SizedBox(height: 14),

              // ── Contact Number ───────────────────────────────────
              _buildLabel('Contact Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. 09123456789',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your contact number';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a valid contact number';
                  }
                  return null;
                },
                onChanged: (_) => _updateStep(),
              ),

              const SizedBox(height: 20),

              // ── Divider ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Security',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),

              const SizedBox(height: 14),

              // ── Password ─────────────────────────────────────────
              _buildLabel('Password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Create password (min 8 chars, 1 uppercase, 1 number)',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                    return 'Password must contain an uppercase letter';
                  }
                  if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                    return 'Password must contain a number';
                  }
                  return null;
                },
                onChanged: (_) {
                  _updateStep();
                  setState(() {});
                },
              ),
              const SizedBox(height: 6),

              _buildPasswordStrength(),

              const SizedBox(height: 14),

              // ── Confirm Password ─────────────────────────────────
              _buildLabel('Confirm Password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (_) => _updateStep(),
              ),

              const SizedBox(height: 16),

              // ── Terms & Conditions (Overflow proof) ───────────────
              GestureDetector(
                onTap: () {
                  setState(() => _agreeToTerms = !_agreeToTerms);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: _agreeToTerms,
                        onChanged: (v) {
                          setState(() => _agreeToTerms = v ?? false);
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Register Button ──────────────────────────────────
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Login link ───────────────────────────────────────
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    int strength = 0;
    String label = 'Weak';
    Color color = AppColors.error;

    if (password.length >= 8) strength++;
    if (RegExp(r'(?=.*[A-Z])').hasMatch(password)) strength++;
    if (RegExp(r'(?=.*[0-9])').hasMatch(password)) strength++;
    if (RegExp(r'(?=.*[!@#\$%\^&\*])').hasMatch(password)) strength++;

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (strength) {
      case 0:
      case 1:
        label = 'Weak';
        color = AppColors.error;
        break;
      case 2:
        label = 'Fair';
        color = AppColors.warning;
        break;
      case 3:
        label = 'Good';
        color = AppColors.primaryLight;
        break;
      case 4:
        label = 'Strong';
        color = AppColors.success;
        break;
    }

    return Column(
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: index < strength ? color : Colors.grey.shade200,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _updateStep() {
    final hasPersonalInfo = _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _contactController.text.isNotEmpty;
    final hasSecurityInfo = _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    int newStep = 0;
    if (hasPersonalInfo) newStep = 1;
    if (hasPersonalInfo && hasSecurityInfo) newStep = 1;

    if (newStep != _currentStep) {
      setState(() => _currentStep = newStep);
    }
  }
}
