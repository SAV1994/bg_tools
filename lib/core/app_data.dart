import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:bg_tools/core/consts/export.dart';

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

  // -----------------------

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

  // -----------------------

  // Запись команд последней сессии (JSON)
  static Future<void> saveLastSessionTeams(List<dynamic> gamersData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(teamsOfLastSessionKey, jsonEncode(gamersData));
  }

  // Получение команд последней сессии (JSON)
  static Future<List<dynamic>> loadLastSessionTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(teamsOfLastSessionKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление команд последней сессии (JSON)
  static Future<void> clearLastSessionTeams() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(teamsOfLastSessionKey);
  }

  // -----------------------

  // Запись игрока последней сессии (JSON)
  static Future<void> saveLastSessionGamer(List<dynamic> gamersData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gamerOfLastSessionKey, jsonEncode(gamersData));
  }

  // Получение игрока последней сессии (JSON)
  static Future<List<dynamic>> loadLastSessionGamer() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(gamerOfLastSessionKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление игрока последней сессии (JSON)
  static Future<void> clearLastSessionGamer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(gamerOfLastSessionKey);
  }

  // -----------------------

  // Запись тайных ролей (JSON)
  static Future<void> saveLastSessionSecretRoles(
    List<dynamic> secretRolesData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      secretRolesOfLastSessionKey,
      jsonEncode(secretRolesData),
    );
  }

  // Получение тайных ролей (JSON)
  static Future<List<dynamic>> loadLastSessionSecretRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(secretRolesOfLastSessionKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление тайных ролей (JSON)
  static Future<void> clearLastSessionSecretRoles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(secretRolesOfLastSessionKey);
  }

  // -----------------------

  // Запись данных счётчиков (JSON)
  static Future<void> saveCounters(List<dynamic> secretRolesData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(countersKey, jsonEncode(secretRolesData));
  }

  // Получение данных счётчиков (JSON)
  static Future<List<dynamic>> loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(countersKey);

    return (json == null) ? [] : jsonDecode(json);
  }

  // Удаление данных счётчиков (JSON)
  static Future<void> clearCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(countersKey);
  }

  // -----------------------

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
