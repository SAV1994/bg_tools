import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: secondColor, // Глобальный цвет для всех AppBar
          foregroundColor: textColor, // Цвет текста и иконок по умолчанию
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodyLarge: TextStyle(color: textColor),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: textColor, // Цвет для основного текста и подзаголовков
          iconColor: borderColor, // Цвет для иконок (по желанию)
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: secondColor, // Цвет фона диалога
          titleTextStyle: TextStyle(
            color: titleColor, // Цвет заголовка
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: textColor, // Цвет текста (описания)
            fontSize: 16,
          ),
        ),
        cardTheme: CardThemeData(
          color: secondColor,
          margin: EdgeInsets.only(left: 8, right: 8, top: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: borderColor,
          thickness: 1.5,
          space: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: secondColor,
          padding: EdgeInsets.all(2.0),
          labelStyle: TextStyle(color: textColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: textColor),
          fillColor: borderColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: goldColor, width: 2),
          ),
          hintStyle: TextStyle(color: textColor),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: greenColor,
          selectionColor: greenColor.withValues(alpha: 0.3),
          selectionHandleColor: greenColor,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: secondColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: greenColor,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          modalBackgroundColor: secondColor,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(greenColor),
          thickness: WidgetStateProperty.all(8.0),
          radius: const Radius.circular(10),
          minThumbLength: 30,
          interactive: true,
        ),
        scaffoldBackgroundColor: firstColor,
        colorScheme: ColorScheme.fromSeed(seedColor: firstColor),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}
