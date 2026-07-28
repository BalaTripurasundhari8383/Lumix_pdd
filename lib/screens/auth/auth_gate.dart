import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/theme.dart';
import '../../widgets/shared_widgets.dart';
import 'login_screen.dart';

// Note: These three imports will have red lines under them for now.
// That is 100% normal because we haven't created those folders yet!
import '../teacher/teacher_shell.dart';
import '../student/student_shell.dart';
import '../parent/parent_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SplashScreen();
        final session = snapshot.data?.session;
        return session != null ? const RoleResolver() : const LoginScreen();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LumixColors.bg900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LumixLogo(size: 64),
            SizedBox(height: 24),
            Text('Lumix', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: LumixColors.textPrimary, letterSpacing: -1.2)),
            SizedBox(height: 6),
            Text('AI Academic Intelligence', style: LumixText.caption),
            SizedBox(height: 48),
            SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: LumixColors.student, strokeWidth: 2)),
          ],
        ),
      ),
    );
  }
}

class RoleResolver extends StatefulWidget {
  const RoleResolver({super.key});
  @override
  State<RoleResolver> createState() => _RoleResolverState();
}

class _RoleResolverState extends State<RoleResolver> {
  Widget? _targetScreen;
  String? _error;

  @override
  void initState() { super.initState(); _resolveRole(); }

  Future<void> _resolveRole() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final profile = await Supabase.instance.client
          .from('profiles').select('role, full_name').eq('user_id', user.id).maybeSingle();
      if (profile == null) throw Exception('Profile not found.');
      final role = profile['role'];
      final name = profile['full_name'] ?? 'User';
      if (mounted) {
        setState(() {
          if (role == 'teacher') _targetScreen = TeacherShell(userName: name);
          else if (role == 'student') _targetScreen = StudentShell(userName: name);
          else if (role == 'parent') _targetScreen = ParentShell(userName: name);
          else _error = 'Unknown role: $role';
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: LumixColors.bg900,
        body: Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: LumixColors.danger),
              const SizedBox(height: 16),
              const Text('Error', style: LumixText.headline),
              const SizedBox(height: 8),
              Text(_error!, style: LumixText.caption, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Supabase.instance.client.auth.signOut(),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(backgroundColor: LumixColors.danger),
              ),
            ],
          ),
        )),
      );
    }
    if (_targetScreen != null) return _targetScreen!;
    return const SplashScreen();
  }
}