// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import 'package:bg_tools/core/consts.dart';
// import 'package:bg_tools/core/database/app_database.dart';
// import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
// import 'package:bg_tools/core/providers/data_providers.dart';
// import 'package:bg_tools/core/providers/database_providers.dart';
// import 'package:bg_tools/core/utils/checkbox_view_builder.dart';
// import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';

// class GamingSessionDetailScreen extends ConsumerStatefulWidget {
//   final int gamingSessionId;

//   const GamingSessionDetailScreen({super.key, required this.gamingSessionId});

//   @override
//   ConsumerState<GamingSessionDetailScreen> createState() => _GamingSessionDetailScreenState();
// }

// class _GamingSessionDetailScreenState extends ConsumerState<GamingSessionDetailScreen> {
//   Future<void> _openUpdateForm() async {
//     final result = await context.pushNamed(
//       'games-update', pathParameters: {'gameId': widget.gameId.toString()}
//     );
    
//     if (result == true) {
//       ref.invalidate(gameFullDataProvider); // Обновляем провайдер
//       setState(() {});
//     }
//   }

//   Widget _buildInfoRow(String label, String? value, {Color? valueColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(color: Colors.grey.shade600),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value ?? emptyVal,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: valueColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildNotFound(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.person_off, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           const Text(
//             'Игра не найдена',
//             style: TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Назад'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildError(BuildContext context, Object error, WidgetRef ref) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//           const SizedBox(height: 16),
//           Text(
//             'Ошибка загрузки',
//             style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             error.toString(),
//             style: TextStyle(color: Colors.grey.shade600),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               ref.invalidate(gameFullDataProvider(widget.gameId));
//             },
//             child: const Text('Повторить'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent(BuildContext context, GameFullData data) {
//     final Game game = data.game;
//     final Game? baseGame = data.baseGame;
//     final List<Designer> designers = data.designers;
//     final List<Artist> artists = data.artists;
//     final List<Tag> tags = data.tags;
    
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 16,
//         children: [
//           // Заголовок с именем
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.blue.shade100,
//                     child: Text(
//                       game.name[0].toUpperCase(),
//                       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           game.name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Основная информация
//           const Text(
//             'Основная информация',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildInfoRow('Базовая игра', baseGame?.name),
//                   const Divider(),
//                   _buildInfoRow('Описание', game.description),
//                   const Divider(),
//                   _buildInfoRow('Год', game.year),
//                   const Divider(),
//                   _buildInfoRow('Минимальное количество игроков', game.minPlayers?.toString()),
//                   const Divider(),
//                   _buildInfoRow('Максимальное количество игроков', game.maxPlayers?.toString()),
//                   const Divider(),
//                   ListTile(
//                     title: Text('Наличие в коллекции'),
//                     trailing: buildCheckboxView(game.isInCollection),
//                   ),
//                   const Divider(),
//                   _buildInfoRow('Описание', game.description),
//                 ],
//               ),
//             ),
//           ),
//           _buildMultiValCard('Геймдизайнеры', Icons.account_balance, designers),
//           _buildMultiValCard('Художники', Icons.border_color, artists),
//           _buildMultiValCard('Метки категорий', Icons.location_on, tags),
//         ],
//       ),
//     );
//   }

//   Widget _buildMultiValCard(String title, IconData icon, List items) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         Card(
//           child: items.isEmpty ? const Padding(
//             padding: EdgeInsets.all(32),
//             child: Center(
//               child: Text(emptyVal),
//             ),
//           ) : ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: items.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return ListTile(
//                 leading: Icon(icon),
//                 title: Text(item.name),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gameAsync = ref.watch(gameFullDataProvider(widget.gameId));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Информация об игре'),
//         actions: [
//            // Кнопка редактирования
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {_openUpdateForm();},
//           ),
//           // Кнопка удаления
//           IconButton(
//             icon: const Icon(Icons.delete_outlined),
//             onPressed: () {
//               final game = gameAsync.value?.game;
//               if (game != null) {
//                 buildDelModal(context, ref, gameDaoProvider, mounted, game);
//               }
//             },
//           ),
//         ],
//       ),
//       body: gameAsync.when(
//         data: (data) {
//           if (data == null) {
//             return _buildNotFound(context);
//           }
//           return _buildContent(context, data);
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, _) => _buildError(context, error, ref),
//       ),
//     );
//   }
// }
