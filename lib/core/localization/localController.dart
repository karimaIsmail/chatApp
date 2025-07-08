import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MylocalController extends GetxController {
  void changeLanguage(String languageCode) {
    Locale local = Locale(languageCode);
    // sharepref!.
    Get.updateLocale(local);
  }

  String formatDate(DateTime date, {bool shortFormat = false}) {
    String formatKey = shortFormat ? 'date_format_short' : 'date_format_long';
    String format = formatKey.tr;
    return DateFormat(format, Get.locale?.languageCode).format(date);
  }
}
