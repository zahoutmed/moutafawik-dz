import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _darkModeKey = 'theme_dark_mode';
  static const _fontSizeKey = 'theme_font_size';
  static const _primaryColorKey = 'theme_primary_color';

  ThemeProvider() {
    _loadPreferences();
  }

  // الألوان
  Color _primaryColor = Colors.deepPurple;
  Color _secondaryColor = Colors.teal;
  Color _backgroundColor = Colors.white;

  // الخطوط
  TextStyle _bodyTextStyle = TextStyle(fontFamily: 'Amiri');
  TextStyle _headingTextStyle =
      TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold);

  // خاصية الوضع الداكن
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  // المقاييس
  double _fontSize = 16.0;
  double _iconSize = 24.0;
  // Getter
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get backgroundColor => _backgroundColor;

  TextStyle get bodyTextStyle => _bodyTextStyle;
  TextStyle get headingTextStyle => _headingTextStyle;

  double get fontSize => _fontSize;
  double get iconSize => _iconSize;

  // تحديث الألوان
  void updatePrimaryColor(Color newColor) {
    _primaryColor = newColor;
    _saveInt(_primaryColorKey, newColor.toARGB32());
    notifyListeners();
  }

  void updateSecondaryColor(Color newColor) {
    _secondaryColor = newColor;
    notifyListeners();
  }

  void updateBackgroundColor(Color newColor) {
    _backgroundColor = newColor;
    notifyListeners();
  }

  // تحديث الخطوط
  void updateBodyTextStyle(TextStyle newStyle) {
    _bodyTextStyle = newStyle;
    notifyListeners();
  }

  void updateHeadingTextStyle(TextStyle newStyle) {
    _headingTextStyle = newStyle;
    notifyListeners();
  }

  // تحديث المقاييس
  void updateFontSize(double newSize) {
    _fontSize = newSize;
    _saveDouble(_fontSizeKey, newSize);
    notifyListeners();
  }

  void updateIconSize(double newSize) {
    _iconSize = newSize;
    notifyListeners();
  }

  // تحديث وضع السمة (Dark Mode)
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    final colorValue = prefs.getInt(_primaryColorKey);
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}
