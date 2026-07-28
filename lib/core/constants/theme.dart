import 'package:flutter/material.dart';

class LumixColors {
  static const bg900 = Color(0xFF080C14);
  static const bg800 = Color(0xFF0F1724);
  static const bg700 = Color(0xFF1A2538);
  static const bg600 = Color(0xFF243047);
  static const border = Color(0xFF2A3A55);

  static const textPrimary   = Color(0xFFF0F4FF);
  static const textSecondary = Color(0xFF7A90B0);
  static const textMuted     = Color(0xFF4A5E7A);

  static const teacher        = Color(0xFF3B82F6);
  static const teacherSurface = Color(0xFF0D1F3C);
  static const teacherGlow    = Color(0x223B82F6);

  static const student        = Color(0xFF6366F1);
  static const studentSurface = Color(0xFF10123A);
  static const studentGlow    = Color(0x226366F1);

  static const parent        = Color(0xFF0EA5E9);
  static const parentSurface = Color(0xFF061E35);
  static const parentGlow    = Color(0x220EA5E9);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger  = Color(0xFFEF4444);
  static const info    = Color(0xFF8B5CF6);

  static const successSurface = Color(0xFF052E16);
  static const warningSurface = Color(0xFF2D1A00);
  static const dangerSurface  = Color(0xFF2D0A0A);
}

class LumixText {
  static const display  = TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: LumixColors.textPrimary, letterSpacing: -0.8, height: 1.2);
  static const headline = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: LumixColors.textPrimary, letterSpacing: -0.3);
  static const title    = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: LumixColors.textPrimary);
  static const body     = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: LumixColors.textPrimary, height: 1.6);
  static const caption  = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: LumixColors.textSecondary, height: 1.4);
  static const label    = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: LumixColors.textMuted, letterSpacing: 0.8);
}

Color scoreColor(int s) {
  if (s >= 80) return LumixColors.success;
  if (s >= 60) return LumixColors.warning;
  return LumixColors.danger;
}