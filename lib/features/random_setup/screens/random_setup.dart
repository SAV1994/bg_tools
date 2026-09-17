// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';

// import 'package:image_picker/image_picker.dart';

// import 'package:bg_tools/core/dataclasses/export.dart';

// class RandomSetupScreen extends StatefulWidget {
//   final int gameId;
//   const RandomSetupScreen({required this.gameId, super.key});

//   @override
//   _SetupGeneratorScreenState createState() => _SetupGeneratorScreenState();
// }

// class _SetupGeneratorScreenState extends State<RandomSetupScreen> {
//   // Название сетапа
//   final TextEditingController _setupNameController = TextEditingController();

//   // Список рандомизированных компонентов
//   List<RandomSetupListMutableData> _components = [];

//   // Предпросмотр сгенерированного сетапа
//   Map<String, String>? _generatedSetup;
//   bool _showPreview = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _setupNameController.dispose();
//     super.dispose();
//   }

//   // ============================================
//   // ДОБАВЛЕНИЕ / РЕДАКТИРОВАНИЕ КОМПОНЕНТА
//   // ============================================

//   void _showComponentDialog({RandomSetupListMutableData? component}) {
//     final nameController = TextEditingController(text: component?.name ?? '');
//     List<ListItemMutableData> options = component?.randomList.items ?? [];

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setStateDialog) {
//           return Dialog(
//             insetPadding: const EdgeInsets.all(16),
//             child: Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.85,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   // ===== ЗАГОЛОВОК =====
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             component == null
//                                 ? 'Новый компонент'
//                                 : 'Редактирование',
//                             style: const TextStyle(
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

//                   // ===== ИМЯ КОМПОНЕНТА =====
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Название компонента',
//                         hintText: 'Например: Фракция',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         prefixIcon: const Icon(Icons.category),
//                       ),
//                       autofocus: component == null,
//                     ),
//                   ),

//                   // ===== ЗАГОЛОВОК ВАРИАНТОВ =====
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Варианты:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           'Всего: ${options.fold(0, (s, o) => s + o.copiesNum)}',
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // ===== СПИСОК ВАРИАНТОВ =====
//                   Expanded(
//                     child: options.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.inbox_outlined,
//                                   size: 48,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Нет вариантов',
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             itemCount: options.length,
//                             itemBuilder: (context, index) {
//                               final option = options[index];
//                               return _buildOptionCard(
//                                 option: option,
//                                 onEdit: () => _showOptionDialog(
//                                   options: options,
//                                   option: option,
//                                   onSave: (updated) {
//                                     setStateDialog(() {
//                                       final idx = options.indexWhere(
//                                         (o) => o.id == updated.id,
//                                       );
//                                       if (idx != -1) {
//                                         options[idx] = updated;
//                                       }
//                                     });
//                                   },
//                                   setStateDialog: setStateDialog,
//                                 ),
//                                 onDelete: () {
//                                   setStateDialog(() {
//                                     options.removeWhere(
//                                       (o) => o.id == option.id,
//                                     );
//                                   });
//                                 },
//                               );
//                             },
//                           ),
//                   ),

//                   // ===== КНОПКА ДОБАВЛЕНИЯ ВАРИАНТА =====
//                   Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton.icon(
//                         onPressed: () => _showOptionDialog(
//                           options: options,
//                           onSave: (newOption) {
//                             setStateDialog(() {
//                               options.add(newOption);
//                             });
//                           },
//                           setStateDialog: setStateDialog,
//                         ),
//                         icon: const Icon(Icons.add),
//                         label: const Text('Добавить вариант'),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.deepPurple,
//                           side: const BorderSide(color: Colors.deepPurple),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // ===== КНОПКИ ДЕЙСТВИЙ =====
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(16),
//                         bottomRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text('Отмена'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           flex: 2,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               final name = nameController.text.trim();
//                               if (name.isEmpty) {
//                                 _showError('Введите название компонента');
//                                 return;
//                               }
//                               if (options.isEmpty) {
//                                 _showError('Добавьте хотя бы один вариант');
//                                 return;
//                               }

//                               setState(() {
//                                 if (component == null) {
//                                   _components.add(
//                                     RandomSetupListMutableData(
//                                       id: DateTime.now().millisecondsSinceEpoch,
//                                       name: name,
//                                       options: options,
//                                     ),
//                                   );
//                                 } else {
//                                   final idx = _components.indexWhere(
//                                     (c) => c.id == component.id,
//                                   );
//                                   if (idx != -1) {
//                                     _components[idx] = component.copyWith(
//                                       name: name,
//                                       options: options,
//                                     );
//                                   }
//                                 }
//                                 _showPreview = false;
//                               });

//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepPurple,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               component == null ? 'Создать' : 'Сохранить',
//                             ),
//                           ),
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

//   // ============================================
//   // ДИАЛОГ ВАРИАНТА
//   // ============================================

//   void _showOptionDialog({
//     required List<ListItemMutableData> options,
//     ListItemMutableData? option,
//     required Function(ListItemMutableData) onSave,
//     required Function(Function()) setStateDialog,
//   }) {
//     final nameController = TextEditingController(text: option?.name ?? '');
//     final countController = TextEditingController(
//       text: option?.copiesNum.toString() ?? '1',
//     );
//     String? imagePath = option?.imagePath;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setStateOptionDialog) {
//           return AlertDialog(
//             title: Text(option == null ? 'Новый вариант' : 'Редактирование'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Изображение
//                   GestureDetector(
//                     onTap: () async {
//                       final picker = ImagePicker();
//                       final picked = await picker.pickImage(
//                         source: ImageSource.gallery,
//                       );
//                       if (picked != null) {
//                         setStateOptionDialog(() {
//                           imagePath = picked.path;
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade300),
//                         image: imagePath != null
//                             ? DecorationImage(
//                                 image: FileImage(File(imagePath!)),
//                                 fit: BoxFit.cover,
//                               )
//                             : null,
//                       ),
//                       child: imagePath == null
//                           ? Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.add_photo_alternate_outlined,
//                                   size: 40,
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Добавить изображение',
//                                   style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Название
//                   TextField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Название',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     autofocus: true,
//                   ),
//                   const SizedBox(height: 12),
//                   // Количество копий
//                   TextField(
//                     controller: countController,
//                     decoration: InputDecoration(
//                       labelText: 'Количество копий',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       prefixIcon: const Icon(Icons.numbers),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               if (option != null)
//                 TextButton(
//                   onPressed: () {
//                     onSave(option.copyWith(name: '', count: 0));
//                     Navigator.pop(context);
//                   },
//                   style: TextButton.styleFrom(foregroundColor: Colors.red),
//                   child: const Text('Удалить'),
//                 ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Отмена'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final name = nameController.text.trim();
//                   final count = int.tryParse(countController.text) ?? 1;
//                   if (name.isEmpty) {
//                     _showError('Введите название');
//                     return;
//                   }
//                   if (count < 1) {
//                     _showError('Количество должно быть ≥ 1');
//                     return;
//                   }

//                   final newOption = ComponentOption(
//                     id:
//                         option?.id ??
//                         DateTime.now().millisecondsSinceEpoch.toString(),
//                     name: name,
//                     count: count,
//                     imagePath: imagePath,
//                     color: option?.color ?? _generateColor(options.length),
//                   );

//                   onSave(newOption);
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text(option == null ? 'Добавить' : 'Сохранить'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // ============================================
//   // КАРТОЧКА ВАРИАНТА
//   // ============================================

//   Widget _buildOptionCard({
//     required ComponentOption option,
//     required VoidCallback onEdit,
//     required VoidCallback onDelete,
//   }) {
//     return Dismissible(
//       key: Key(option.id),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) => onDelete(),
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         child: ListTile(
//           onTap: onEdit,
//           leading: option.imagePath != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.file(
//                     File(option.imagePath!),
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 50,
//                       height: 50,
//                       color: Colors.grey.shade200,
//                       child: Icon(
//                         Icons.broken_image,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: option.color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       option.name.isNotEmpty
//                           ? option.name[0].toUpperCase()
//                           : '?',
//                       style: TextStyle(
//                         color: option.color,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//           title: Text(
//             option.name,
//             style: const TextStyle(fontWeight: FontWeight.w500),
//           ),
//           subtitle: Text('Копий: ${option.count}'),
//           trailing: const Icon(Icons.edit_outlined, size: 20),
//         ),
//       ),
//     );
//   }

//   // ============================================
//   // КАРТОЧКА КОМПОНЕНТА
//   // ============================================

//   Widget _buildComponentCard(RandomComponent component) {
//     return Dismissible(
//       key: Key(component.id),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) {
//         setState(() {
//           _components.removeWhere((c) => c.id == component.id);
//           _showPreview = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${component.name} удален'),
//             action: SnackBarAction(
//               label: 'Отменить',
//               onPressed: () {
//                 setState(() {
//                   _components.insert(0, component);
//                 });
//               },
//             ),
//           ),
//         );
//       },
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Icon(Icons.delete, color: Colors.white, size: 28),
//             SizedBox(width: 8),
//             Text(
//               'Удалить',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: InkWell(
//           onTap: () => _showComponentDialog(component: component),
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Заголовок компонента
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         component.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       'Всего: ${component.totalCount}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.edit_outlined, size: 18),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 // Варианты
//                 Wrap(
//                   spacing: 6,
//                   runSpacing: 6,
//                   children: component.options.map((option) {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: option.color.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: option.color.withOpacity(0.5),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (option.imagePath != null)
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: Image.file(
//                                 File(option.imagePath!),
//                                 width: 16,
//                                 height: 16,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           else
//                             Container(
//                               width: 8,
//                               height: 8,
//                               decoration: BoxDecoration(
//                                 color: option.color,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${option.name} ×${option.count}',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: option.color,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================
//   // ВСПОМОГАТЕЛЬНЫЕ
//   // ============================================

//   Color _generateColor(int index) {
//     final colors = [
//       Colors.blue,
//       Colors.red,
//       Colors.green,
//       Colors.orange,
//       Colors.purple,
//       Colors.teal,
//       Colors.pink,
//       Colors.indigo,
//       Colors.amber,
//       Colors.cyan,
//     ];
//     return colors[index % colors.length];
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 2),
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
//         title: const Text('Генератор сетапа'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [],
//       ),
//       body: Column(
//         children: [
//           // ===== НАЗВАНИЕ СЕТАПА =====
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.deepPurple.shade50,
//             child: TextField(
//               controller: _setupNameController,
//               decoration: InputDecoration(
//                 labelText: 'Название сетапа',
//                 hintText: 'Например: Случайная партия',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 prefixIcon: const Icon(Icons.title),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),

//           // ===== СПИСОК КОМПОНЕНТОВ =====
//           Expanded(
//             child: _components.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(8),
//                     itemCount: _components.length,
//                     itemBuilder: (context, index) {
//                       return _buildComponentCard(_components[index]);
//                     },
//                   ),
//           ),

//           // ===== РЕЗУЛЬТАТ =====
//           if (_showPreview && _generatedSetup != null)
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 border: Border(top: BorderSide(color: Colors.green.shade200)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         '🎲 Результат:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => setState(() => _showPreview = false),
//                         child: const Text('Скрыть'),
//                       ),
//                     ],
//                   ),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: _generatedSetup!.entries.map((e) {
//                       return Chip(
//                         label: Text('${e.key}: ${e.value}'),
//                         backgroundColor: Colors.deepPurple.shade50,
//                         avatar: const Icon(
//                           Icons.check_circle,
//                           size: 16,
//                           color: Colors.deepPurple,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),

//           // ===== КНОПКИ =====
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(top: BorderSide(color: Colors.grey.shade200)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => _showComponentDialog(),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Добавить компонент'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
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
//           Icon(Icons.extension_outlined, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           Text(
//             'Нет компонентов',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Добавьте рандомизированные компоненты',
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }
// }
