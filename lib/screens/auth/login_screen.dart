import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/theme.dart';
import '../../widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl     = TextEditingController();
  bool _isLoading  = false;
  bool _isSignUp   = false;
  bool _obscurePwd = true;
  String _selectedRole = 'student';

  static const _roles = [
    {'value': 'student', 'label': 'Student',  'icon': Icons.school_rounded},
    {'value': 'teacher', 'label': 'Teacher',  'icon': Icons.person_rounded},
    {'value': 'parent',  'label': 'Parent',   'icon': Icons.family_restroom_rounded},
  ];

  Color _roleColor(String v) {
    if (v == 'teacher') return LumixColors.teacher;
    if (v == 'parent') return LumixColors.parent;
    return LumixColors.student;
  }

  Future<void> _submit() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final name     = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty || (_isSignUp && name.isEmpty)) {
      _snack('Please fill in all fields', isError: true); return;
    }
    if (_isSignUp && password.length < 6) {
      _snack('Password must be at least 6 characters', isError: true); return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        final resp = await Supabase.instance.client.auth.signUp(email: email, password: password);
        if (resp.user != null) {
          await Supabase.instance.client.from('profiles').insert({
            'user_id':   resp.user!.id,
            'full_name': name,
            'role':      _selectedRole,
          });
          if (resp.session == null) {
            _emailCtrl.clear(); _passwordCtrl.clear(); _nameCtrl.clear();
            if (mounted) {
              setState(() => _isSignUp = false);
              _snack('Account created! Check your email to confirm before signing in.');
            }
          }
        } else {
          _snack('Sign-up failed. Please try again.', isError: true);
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      }
    } on AuthException catch (e) {
      if (mounted) _snack(e.message, isError: true);
    } catch (e) {
      if (mounted) _snack('Something went wrong. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? LumixColors.danger : LumixColors.student,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumixColors.bg900,
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Column(children: [
                const LumixLogo(size: 60),
                const SizedBox(height: 20),
                Text(_isSignUp ? 'Create Account' : 'Welcome back', style: LumixText.display),
                const SizedBox(height: 6),
                Text(_isSignUp ? 'Join the future of intelligent learning' : 'Sign in to your Lumix portal', style: LumixText.caption, textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 40),

              if (_isSignUp) ...[
                _field(_nameCtrl, 'Full Name', Icons.person_outline_rounded),
                const SizedBox(height: 14),
                Text('I am a…', style: LumixText.caption),
                const SizedBox(height: 10),
                Row(
                  children: _roles.map((r) {
                    final val = r['value'] as String;
                    final selected = _selectedRole == val;
                    final color = _roleColor(val);
                    return Expanded(child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected ? color.withOpacity(0.12) : LumixColors.bg800,
                          border: Border.all(color: selected ? color : LumixColors.border, width: selected ? 1.5 : 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(children: [
                          Icon(r['icon'] as IconData, size: 22, color: selected ? color : LumixColors.textSecondary),
                          const SizedBox(height: 6),
                          Text(r['label'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? color : LumixColors.textSecondary)),
                        ]),
                      ),
                    ));
                  }).toList(),
                ),
                const SizedBox(height: 14),
              ],

              _field(_emailCtrl, 'Email Address', Icons.email_outlined, type: TextInputType.emailAddress),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordCtrl, obscureText: _obscurePwd, style: LumixText.body,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePwd ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
                  ),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 28),

              _isLoading
                  ? const Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: LumixColors.student, strokeWidth: 2)))
                  : ElevatedButton(
                onPressed: _submit,
                child: Text(_isSignUp ? 'Create Account' : 'Sign In'),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() { _isSignUp = !_isSignUp; }),
                child: Text(
                  _isSignUp ? 'Already have an account? Sign In' : 'New here? Create an account',
                  style: const TextStyle(color: LumixColors.student, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ))),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c, keyboardType: type, style: LumixText.body,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20)),
    );
  }

  @override
  void dispose() { _emailCtrl.dispose(); _passwordCtrl.dispose(); _nameCtrl.dispose(); super.dispose(); }
}