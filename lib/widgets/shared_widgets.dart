import 'package:flutter/material.dart';
import '../core/constants/theme.dart';

class LumixLogo extends StatelessWidget {
  final double size;
  const LumixLogo({super.key, this.size = 40});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [BoxShadow(color: LumixColors.student.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: size * 0.52),
    );
  }
}

class LumixCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool glow;
  final Color? glowColor;
  const LumixCard({super.key, required this.child, this.padding, this.color, this.onTap, this.glow = false, this.glowColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? LumixColors.bg800,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: LumixColors.border),
            borderRadius: BorderRadius.circular(16),
            boxShadow: glow && glowColor != null ? [BoxShadow(color: glowColor!.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 4))] : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

class LumixChip extends StatelessWidget {
  final String label;
  final Color color;
  const LumixChip({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), border: Border.all(color: color.withOpacity(0.4)), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
    );
  }
}

class LumixScoreBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  const LumixScoreBar({super.key, required this.value, required this.color, this.height = 6});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: value, minHeight: height,
        backgroundColor: LumixColors.bg700,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

void push(BuildContext ctx, Widget screen) {
  Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));
}