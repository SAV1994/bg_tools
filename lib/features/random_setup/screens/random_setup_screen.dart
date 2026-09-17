// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:math';

// // ============================================
// // МОДЕЛИ ДАННЫХ
// // ============================================

// /// Элемент результата (компонент с порядковым номером)
// class ResultItem {
//   final String id;
//   final String name;
//   final String? imagePath;
//   int order;

//   ResultItem({
//     required this.id,
//     required this.name,
//     this.imagePath,
//     required this.order,
//   });

//   ResultItem copyWith({
//     String? id,
//     String? name,
//     String? imagePath,
//     int? order,
//   }) {
//     return ResultItem(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       imagePath: imagePath ?? this.imagePath,
//       order: order ?? this.order,
//     );
//   }
// }

// /// Результат для одного списка
// class ListResult {
//   final String listId;
//   final String listName;
//   final List<ResultItem> items;

//   ListResult({
//     required this.listId,
//     required this.listName,
//     required this.items,
//   });

//   ListResult copyWith({
//     String? listId,
//     String? listName,
//     List<ResultItem>? items,
//   }) {
//     return ListResult(
//       listId: listId ?? this.listId,
//       listName: listName ?? this.listName,
//       items: items ?? this.items,
//     );
//   }
// }

// /// Сохранённый результат
// class SavedResult {
//   final String id;
//   final String name;
//   final String description;
//   final List<ListResult> lists;
//   final DateTime savedAt;

//   SavedResult({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.lists,
//     required this.savedAt,
//   });
// }

// // ============================================
// // ОСНОВНОЙ ЭКРАН
// // ============================================

// class GenerateSetupScreen extends StatefulWidget {
//   final List<RandomSetup> setups;
//   final List<SavedResult> savedResults;
//   final Function(SavedResult) onSaveResult;

//   const GenerateSetupScreen({
//     Key? key,
//     required this.setups,
//     required this.savedResults,
//     required this.onSaveResult,
//   }) : super(key: key);

//   @override
//   _GenerateSetupScreenState createState() => _GenerateSetupScreenState();
// }

// class _GenerateSetupScreenState extends State<GenerateSetupScreen> {
//   RandomSetup? _selectedSetup;
//   List<ListResult>? _result;
//   bool _isGenerating = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.setups.isNotEmpty) {
//       _selectedSetup = widget.setups.first;
//     }
//   }

//   // ============================================
//   // ГЕНЕРАЦИЯ
//   // ============================================

//   void _generate() {
//     if (_selectedSetup == null) return;

//     setState(() => _isGenerating = true);

//     // Имитация задержки
//     Future.delayed(const Duration(milliseconds: 500), () {
//       final random = Random();
//       final List<ListResult> result = [];

//       for (var list in _selectedSetup!.lists) {
//         // Собираем пул
//         final pool = <SelectedComponent>[];
//         for (var sc in list.components.where((c) => c.copies > 0)) {
//           for (int i = 0; i < sc.copies; i++) {
//             pool.add(sc);
//           }
//         }

//         if (pool.isEmpty) {
//           result.add(
//             ListResult(listId: list.id, listName: list.name, items: []),
//           );
//           continue;
//         }

//         // Перемешиваем
//         pool.shuffle(random);

//         // Выбираем
//         final selected = <SelectedComponent>[];
//         if (list.unique) {
//           final seen = <String>{};
//           for (var sc in pool) {
//             if (!seen.contains(sc.component.id)) {
//               seen.add(sc.component.id);
//               selected.add(sc);
//               if (selected.length >= list.count) break;
//             }
//           }
//         } else {
//           selected.addAll(pool.take(list.count));
//         }

//         // Формируем результат
//         final items = selected.asMap().entries.map((e) {
//           return ResultItem(
//             id: e.value.component.id,
//             name: e.value.component.name,
//             imagePath: e.value.component.imagePath,
//             order: e.key,
//           );
//         }).toList();

//         result.add(
//           ListResult(listId: list.id, listName: list.name, items: items),
//         );
//       }

//       setState(() {
//         _result = result;
//         _isGenerating = false;
//       });
//     });
//   }

//   // ============================================
//   // СОХРАНЕНИЕ РЕЗУЛЬТАТА
//   // ============================================

//   void _showSaveDialog() {
//     if (_result == null) return;

//     final nameController = TextEditingController();
//     final descController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Сохранить результат'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Название',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               autofocus: true,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descController,
//               decoration: InputDecoration(
//                 labelText: 'Описание',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final name = nameController.text.trim();
//               if (name.isEmpty) {
//                 _showError('Введите название');
//                 return;
//               }

//               final saved = SavedResult(
//                 id: DateTime.now().millisecondsSinceEpoch.toString(),
//                 name: name,
//                 description: descController.text.trim(),
//                 lists: _result!,
//                 savedAt: DateTime.now(),
//               );

//               widget.onSaveResult(saved);
//               Navigator.pop(context);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Результат сохранён'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Сохранить'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================
//   // ВЫБОР СОХРАНЁННОГО РЕЗУЛЬТАТА
//   // ============================================

//   void _showSavedResultsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: const EdgeInsets.all(16),
//         child: Container(
//           width: double.infinity,
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.8,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Заголовок
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Colors.deepPurple,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Сохранённые результаты',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),

//               // Список
//               Flexible(
//                 child: widget.savedResults.isEmpty
//                     ? const Padding(
//                         padding: EdgeInsets.all(32),
//                         child: Text('Нет сохранённых результатов'),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.all(8),
//                         itemCount: widget.savedResults.length,
//                         itemBuilder: (context, index) {
//                           final saved = widget.savedResults[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               leading: const CircleAvatar(
//                                 backgroundColor: Colors.deepPurple,
//                                 child: Icon(
//                                   Icons.save,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                               title: Text(
//                                 saved.name,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (saved.description.isNotEmpty)
//                                     Text(
//                                       saved.description,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   Text(
//                                     '${saved.lists.length} списков • ${_formatDate(saved.savedAt)}',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               trailing: const Icon(Icons.chevron_right),
//                               onTap: () {
//                                 setState(() {
//                                   _result = saved.lists;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
//   }

//   // ============================================
//   // РУЧНОЕ СОЗДАНИЕ
//   // ============================================

//   void _showManualCreateDialog() {
//     if (_selectedSetup == null) return;

//     final nameController = TextEditingController();
//     final descController = TextEditingController();
//     final Map<String, List<ResultItem>> manualResult = {};

//     // Инициализируем пустые списки
//     for (var list in _selectedSetup!.lists) {
//       manualResult[list.id] = [];
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setStateDialog) {
//           return Dialog(
//             insetPadding: EdgeInsets.zero,
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   // Заголовок
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     color: Colors.deepPurple,
//                     child: Row(
//                       children: [
//                         const Expanded(
//                           child: Text(
//                             'Ручное создание результата',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.white),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Форма
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: nameController,
//                           decoration: InputDecoration(
//                             labelText: 'Название',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             isDense: true,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextField(
//                           controller: descController,
//                           decoration: InputDecoration(
//                             labelText: 'Описание',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             isDense: true,
//                           ),
//                           maxLines: 2,
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Списки
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       itemCount: _selectedSetup!.lists.length,
//                       itemBuilder: (context, index) {
//                         final list = _selectedSetup!.lists[index];
//                         final selected = manualResult[list.id] ?? [];

//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Заголовок списка
//                                 Row(
//                                   children: [
//                                     Text(
//                                       list.name,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 6,
//                                         vertical: 2,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.deepPurple.shade100,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Text(
//                                         '${selected.length}/${list.count}',
//                                         style: const TextStyle(
//                                           fontSize: 11,
//                                           color: Colors.deepPurple,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     if (selected.isNotEmpty)
//                                       TextButton(
//                                         onPressed: () {
//                                           setStateDialog(() {
//                                             manualResult[list.id] = [];
//                                           });
//                                         },
//                                         child: const Text(
//                                           'Очистить',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),

//                                 // Пул компонентов
//                                 Wrap(
//                                   spacing: 6,
//                                   runSpacing: 6,
//                                   children: list.components.where((sc) => sc.copies > 0).map((
//                                     sc,
//                                   ) {
//                                     final isSelected = selected.any(
//                                       (item) => item.id == sc.component.id,
//                                     );
//                                     final order = isSelected
//                                         ? selected.indexWhere(
//                                                 (item) =>
//                                                     item.id == sc.component.id,
//                                               ) +
//                                               1
//                                         : null;

//                                     return GestureDetector(
//                                       onTap: () {
//                                         setStateDialog(() {
//                                           if (isSelected) {
//                                             manualResult[list.id]!.removeWhere(
//                                               (item) =>
//                                                   item.id == sc.component.id,
//                                             );
//                                             _renumber(manualResult[list.id]!);
//                                           } else {
//                                             manualResult[list.id]!.add(
//                                               ResultItem(
//                                                 id: sc.component.id,
//                                                 name: sc.component.name,
//                                                 imagePath:
//                                                     sc.component.imagePath,
//                                                 order: manualResult[list.id]!
//                                                     .length,
//                                               ),
//                                             );
//                                           }
//                                         });
//                                       },
//                                       child: Container(
//                                         width: 70,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                           border: Border.all(
//                                             color: isSelected
//                                                 ? Colors.deepPurple
//                                                 : Colors.grey.shade300,
//                                             width: isSelected ? 2 : 1,
//                                           ),
//                                           color: isSelected
//                                               ? Colors.deepPurple.shade50
//                                               : Colors.white,
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             // Картинка с номером
//                                             Stack(
//                                               children: [
//                                                 Container(
//                                                   height: 50,
//                                                   width: 70,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         const BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                 7,
//                                                               ),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                 7,
//                                                               ),
//                                                         ),
//                                                     color: Colors.grey.shade100,
//                                                   ),
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         const BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                 7,
//                                                               ),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                 7,
//                                                               ),
//                                                         ),
//                                                     child:
//                                                         sc
//                                                                 .component
//                                                                 .imagePath !=
//                                                             null
//                                                         ? Image.file(
//                                                             File(
//                                                               sc
//                                                                   .component
//                                                                   .imagePath!,
//                                                             ),
//                                                             fit: BoxFit.cover,
//                                                             errorBuilder:
//                                                                 (_, __, ___) =>
//                                                                     _buildMiniPlaceholder(),
//                                                           )
//                                                         : _buildMiniPlaceholder(),
//                                                   ),
//                                                 ),
//                                                 if (isSelected)
//                                                   Positioned(
//                                                     top: 2,
//                                                     left: 2,
//                                                     child: Container(
//                                                       width: 18,
//                                                       height: 18,
//                                                       decoration:
//                                                           const BoxDecoration(
//                                                             color: Colors
//                                                                 .deepPurple,
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                           ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           '$order',
//                                                           style:
//                                                               const TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                               ],
//                                             ),
//                                             // Название
//                                             Padding(
//                                               padding: const EdgeInsets.all(3),
//                                               child: Text(
//                                                 sc.component.name,
//                                                 style: TextStyle(
//                                                   fontSize: 9,
//                                                   fontWeight: isSelected
//                                                       ? FontWeight.bold
//                                                       : FontWeight.normal,
//                                                   color: isSelected
//                                                       ? Colors.deepPurple
//                                                       : Colors.black87,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // Кнопки
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade200),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         const Spacer(),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Отмена'),
//                         ),
//                         const SizedBox(width: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             final name = nameController.text.trim();
//                             if (name.isEmpty) {
//                               _showError('Введите название');
//                               return;
//                             }

//                             // Проверка: все списки заполнены
//                             for (var list in _selectedSetup!.lists) {
//                               final selected = manualResult[list.id] ?? [];
//                               if (selected.isEmpty) {
//                                 _showError('Заполните список "${list.name}"');
//                                 return;
//                               }
//                             }

//                             // Формируем результат
//                             final result = _selectedSetup!.lists.map((list) {
//                               return ListResult(
//                                 listId: list.id,
//                                 listName: list.name,
//                                 items: manualResult[list.id] ?? [],
//                               );
//                             }).toList();

//                             final saved = SavedResult(
//                               id: DateTime.now().millisecondsSinceEpoch
//                                   .toString(),
//                               name: name,
//                               description: descController.text.trim(),
//                               lists: result,
//                               savedAt: DateTime.now(),
//                             );

//                             widget.onSaveResult(saved);
//                             setState(() => _result = result);
//                             Navigator.pop(context);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Результат сохранён'),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepPurple,
//                             foregroundColor: Colors.white,
//                           ),
//                           child: const Text('Сохранить'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _renumber(List<ResultItem> items) {
//     for (int i = 0; i < items.length; i++) {
//       items[i].order = i;
//     }
//   }

//   // ============================================
//   // ВСПОМОГАТЕЛЬНЫЕ
//   // ============================================

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Widget _buildMiniPlaceholder() {
//     return Container(
//       color: Colors.grey.shade100,
//       child: Center(
//         child: Icon(
//           Icons.image_outlined,
//           size: 20,
//           color: Colors.grey.shade400,
//         ),
//       ),
//     );
//   }

//   // ============================================
//   // BUILD
//   // ============================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Генерация сетапа'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           // ✅ Сохранить (только если есть результат)
//           if (_result != null)
//             IconButton(
//               icon: const Icon(Icons.save),
//               tooltip: 'Сохранить результат',
//               onPressed: _showSaveDialog,
//             ),
//           // ✅ Сохранённые результаты
//           if (widget.savedResults.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.folder_open),
//               tooltip: 'Сохранённые результаты',
//               onPressed: _showSavedResultsDialog,
//             ),
//           // ✅ Ручное создание
//           if (_selectedSetup != null)
//             IconButton(
//               icon: const Icon(Icons.edit_note),
//               tooltip: 'Создать вручную',
//               onPressed: _showManualCreateDialog,
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // ===== ВЫБОР СЕТАПА =====
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.deepPurple.shade50,
//               border: Border(
//                 bottom: BorderSide(color: Colors.deepPurple.shade100),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<RandomSetup>(
//                         value: _selectedSetup,
//                         isExpanded: true,
//                         hint: const Text('Выберите сетап'),
//                         icon: const Icon(
//                           Icons.arrow_drop_down,
//                           color: Colors.deepPurple,
//                         ),
//                         items: widget.setups.map((setup) {
//                           return DropdownMenuItem<RandomSetup>(
//                             value: setup,
//                             child: Text(setup.name),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedSetup = value;
//                             _result = null;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton.icon(
//                   onPressed: _selectedSetup != null && !_isGenerating
//                       ? _generate
//                       : null,
//                   icon: _isGenerating
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.casino),
//                   label: Text(_isGenerating ? 'Генерация...' : 'Запустить'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ===== РЕЗУЛЬТАТ =====
//           Expanded(
//             child: _result == null
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: _result!.length,
//                     itemBuilder: (context, index) {
//                       return _buildListResult(_result![index]);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.casino_outlined, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           Text(
//             'Нажмите "Запустить"',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Результат появится здесь',
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================
//   // РЕЗУЛЬТАТ СПИСКА С DRAG & DROP
//   // ============================================

//   Widget _buildListResult(ListResult listResult) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Заголовок
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     listResult.listName,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${listResult.items.length} элементов',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             // Элементы с Drag & Drop
//             if (listResult.items.isEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   'Нет элементов',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               )
//             else
//               ReorderableListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 buildDefaultDragHandles: false,
//                 itemCount: listResult.items.length,
//                 onReorder: (oldIndex, newIndex) {
//                   setState(() {
//                     if (newIndex > oldIndex) newIndex--;
//                     final item = listResult.items.removeAt(oldIndex);
//                     listResult.items.insert(newIndex, item);
//                     _renumber(listResult.items);
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final item = listResult.items[index];
//                   return _buildResultItem(item, index, listResult);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultItem(ResultItem item, int index, ListResult listResult) {
//     return ReorderableDelayedDragStartListener(
//       key: ValueKey(item.id + index.toString()),
//       index: index,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 6),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           children: [
//             // Номер
//             Container(
//               width: 28,
//               height: 28,
//               decoration: const BoxDecoration(
//                 color: Colors.deepPurple,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '${index + 1}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),

//             // Миниатюра
//             ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: item.imagePath != null
//                   ? Image.file(
//                       File(item.imagePath!),
//                       width: 40,
//                       height: 40,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => _buildMiniPlaceholder(),
//                     )
//                   : SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: _buildMiniPlaceholder(),
//                     ),
//             ),
//             const SizedBox(width: 10),

//             // Название
//             Expanded(
//               child: Text(
//                 item.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),

//             // Иконка перетаскивания
//             Icon(Icons.drag_handle, color: Colors.grey.shade400, size: 22),
//           ],
//         ),
//       ),
//     );
//   }
// }
