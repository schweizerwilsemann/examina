import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'views/expense_list_screen.dart';

class ExaminaApp extends StatelessWidget {
  const ExaminaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Quản lý chi tiêu',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    locale: const Locale('vi'),
    supportedLocales: const [Locale('vi'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: const ExpenseListScreen(),
  );
}
