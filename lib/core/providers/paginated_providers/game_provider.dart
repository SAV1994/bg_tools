import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

final gamesPaginatedProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  () {
    return GamesNotifier();
  },
);

class GamesNotifier extends AsyncNotifier<List<Game>> {
  int _page = 0;
  late int _pageSize;
  int _totalItems = 0;
  String? _searchQuery;
  bool _reverseOrdering = false;
  bool _onlyFavorite = false;
  bool _onlyStandalone = true;

  @override
  Future<List<Game>> build() async {
    _pageSize = await AppDataManager.loadPageLimit();
    return await _loadGames();
  }

  Future<List<Game>> _loadGames() async {
    final dao = ref.read(gameDaoProvider);

    _totalItems = await dao.getTotalCount(searchQuery: _searchQuery);

    return await dao.getPaginated(
      page: _page,
      pageSize: _pageSize,
      reverseOrdering: _reverseOrdering,
      onlyFavorite: _onlyFavorite,
      onlyStandalone: _onlyStandalone,
      searchQuery: _searchQuery,
    );
  }

  Future<void> updatePageLimit() async {
    _pageSize = await AppDataManager.loadPageLimit();
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> goToPage(int page) async {
    if (page < 0 || page >= totalPages) return;

    _page = page;
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> search(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    _page = 0;
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> toggleOrdering() async {
    _reverseOrdering = !_reverseOrdering;
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> toggleOnlyFavorite() async {
    _onlyFavorite = !_onlyFavorite;
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> toggleOnlyStandalone() async {
    _onlyStandalone = !_onlyStandalone;
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _loadGames());
  }

  Future<void> reset() async {
    _searchQuery = null;
    _page = 0;
    _reverseOrdering = false;
    _onlyFavorite = false;
    _onlyStandalone = true;
    state = await AsyncValue.guard(() => _loadGames());
  }

  int get totalPages => (_totalItems / _pageSize).ceil();
  int get currentPage => _page;
  int get pageSize => _pageSize;
  int get totalItems => _totalItems;
  bool get hasPrevious => _page > 0;
  bool get hasNext => _page < totalPages - 1;
  bool get reverseOrdering => _reverseOrdering;
  bool get onlyFavorite => _onlyFavorite;
  bool get onlyStandalone => _onlyStandalone;
}
