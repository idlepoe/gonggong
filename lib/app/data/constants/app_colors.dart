import 'dart:ui';

class AppColors {
  static const backgroundColor = Color(0xFFE8F7FC); // ⬅ 아이콘 배경 하늘색에 맞춘 밝은 톤
  static const accentGreen = Color(0xFF2E8B57); // 상승 그래프 색 (Seagreen 계열)
  static const accentRed = Color(0xFFE74C3C);   // 하락 그래프 색 (Tomato 계열)
  static const accentBlue = Color(0xFF3498DB);  // 포인트 색 (추가 사용 시)

  static const chipColor = Color(0xFFDFF2F8);   // Chip 및 강조 배경용 (연하늘)
  static const cardBackground = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF222222);
  static const textSecondary = Color(0xFF666666);

  // 포인트 노드나 강조 점 등에 쓰일 진한 버전
  static const dotGreen = Color(0xFF1C5E3B);
  static const dotRed = Color(0xFFB5342E);

  // 🌙 다크 모드
  static const darkBackgroundColor = Color(0xFF121212);
  static const darkCardBackground = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFEDEDED);
  static const darkTextSecondary = Color(0xFFAAAAAA);
  static const darkChipColor = Color(0xFF2A2A2A);
}
