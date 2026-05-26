// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:bg_tools/core/utils/gamer_score_card_builder.dart';
// import 'package:bg_tools/core/utils/loading_screen_builder.dart';

// class ScoreResultScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> data;

//   const ScoreResultScreen({super.key, required this.data});

//   @override
//   ConsumerState<ScoreResultScreen> createState() => _ScoreResultScreenState();
// }

// class _ScoreResultScreenState extends ConsumerState<ScoreResultScreen> {
//   // Загрузка
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     List<Map<String, dynamic>> gamersData = widget.data['gamers']
//         .cast<Map<String, dynamic>>();
//     for (final Map<String, dynamic> gamerData in gamersData) {
//       _scoreControllers[gamerData['id']] = {
//         'username': gamerData['username'],
//         'controller': TextEditingController(
//           text: gamerData['score']?.toString() ?? '',
//         ),
//       };
//     }

//     setState(() => _isLoading = false);
//   }

//   void _updateScore(int gamerId, String value) {
//     final newScore = int.tryParse(value);
//     for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
//       if (gamerData['id'] == gamerId) {
//         gamerData['score'] = newScore;
//       }
//     }
//   }

//   @override
//   void dispose() {
//     for (final Map<String, dynamic> controllerData
//         in _scoreControllers.values) {
//       controllerData['controller'].dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         return _isLoading
//             ? buildLoadingScreen()
//             : Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.deepPurple.shade200, Colors.white],
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       children: [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           padding: const EdgeInsets.all(16),
//                           itemCount: widget.data['gamers'].length,
//                           itemBuilder: (context, index) {
//                             return buildGamerScoreCard(
//                               widget.data['gamers'][index],
//                               _updateScore,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//       },
//     );
//   }
// }
