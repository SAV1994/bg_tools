import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';

abstract class BaseNotifier extends AsyncNotifier<List<dynamic>> {
  int page = 0;
  late int pageSize;
  int totalItems = 0;
  String? searchQuery;
  bool reverseOrdering = false;

  @override
  Future<List<dynamic>> build() async {
    pageSize = await AppDataManager.loadPageLimit();
    return await load();
  }

  Future<List<dynamic>> load();

  Future<void> updatePageLimit() async {
    pageSize = await AppDataManager.loadPageLimit();
    state = await AsyncValue.guard(() => load());
  }

  Future<void> goToPage(int newPage) async {
    if (newPage < 0 || newPage >= totalPages) return;

    page = newPage;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> search(String query) async {
    searchQuery = query.isEmpty ? null : query;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> toggleOrdering() async {
    reverseOrdering = !reverseOrdering;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => load());
  }

  Future<void> reset() async {
    searchQuery = null;
    page = 0;
    resetAdditionalParams();
    state = await AsyncValue.guard(() => load());
  }

  void resetAdditionalParams() {
    reverseOrdering = false;
  }

  int get currentPage => page;
  int get totalPages => (totalItems / pageSize).ceil();
  bool get hasPrevious => page > 0;
  bool get hasNext => page < totalPages - 1;
}
