import 'dart:convert';

import 'package:bg_tools/core/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataManager {
  // Запись запущенной сессии (JSON)
  static Future<void> saveActiveSession(
    Map<String, dynamic> sessionData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionKey, jsonEncode(sessionData));
  }

  // Получение запущенной сессии (JSON)
  static Future<Map<String, dynamic>?> loadActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(sessionKey);

    return (json == null) ? null : jsonDecode(json);
  }

  // Удаление запущенной сессии
  static Future<void> clearActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionKey);
  }

  // Запись игроков последней сессии (JSON)
  static Future<void> saveLastSessionGamers(List<dynamic> gamersData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gamersOfLastSessionKey, jsonEncode(gamersData));
  }

  // Получение игроков последней сессии (JSON)
  static Future<List<dynamic>> loadLastSessionGamers() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(gamersOfLastSessionKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление игроков последней сессии (JSON)
  static Future<void> clearLastSessionGamers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(gamersOfLastSessionKey);
  }

  // Запись команд последней сессии (JSON)
  static Future<void> saveLastSessionTeams(List<dynamic> gamersData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(teamssOfLastSessionKey, jsonEncode(gamersData));
  }

  // Получение команд последней сессии (JSON)
  static Future<List<dynamic>> loadLastSessionTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(teamssOfLastSessionKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление команд последней сессии (JSON)
  static Future<void> clearLastSessionTeams() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(teamssOfLastSessionKey);
  }

  // Запись лимита записей настранице
  static Future<void> savePageLimit(int pageLimit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(pageLimitKey, pageLimit);
  }

  // Получение лимита записей настранице
  static Future<int> loadPageLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(pageLimitKey) ?? pageSize;
  }
}
