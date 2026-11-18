import 'package:flutter/material.dart';

/// نظام القياس والتجاوب المعياري لمنصة المتفوّق الجزائري (ويب + موبايل + تابلت)
class ResponsiveUI {
  /// عرض المرجع لحساب أحجام الخطوط والأيقونات حتى لا تتضخم على شاشات الويب العريضة
  static double fontBasis(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w.clamp(360.0, 440.0);
  }

  /// ارتفاع المرجع لحساب المسافات الرأسية المتوازنة
  static double heightBasis(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return h.clamp(680.0, 880.0);
  }

  /// عدد الأعمدة التكيّفي لشبكات المواد والبطاقات
  static int gridColumns(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return desktop;
    if (w >= 680) return tablet;
    return mobile;
  }

  /// نسبة العرض إلى الارتفاع المناسبة للبطاقات حسب حجم الشاشة
  static double cardAspectRatio(
    BuildContext context, {
    double mobile = 1.05,
    double tablet = 1.15,
    double desktop = 1.25,
  }) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return desktop;
    if (w >= 680) return tablet;
    return mobile;
  }

  /// هل الشاشة كبيرة (ويب / تابلت أفقي)؟
  static bool isWide(BuildContext context) => MediaQuery.of(context).size.width >= 820;

  /// غلاف متمركز مريح للقراءة على الشاشات العريضة دون تقييد الهواتف
  static Widget constrainBody({required Widget child, double maxWidth = 1180}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
