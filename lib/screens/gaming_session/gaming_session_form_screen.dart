// import 'package:flutter/material.dart';

// import 'package:drift/drift.dart' show Value;
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:bg_tools/core/database/app_database.dart';
// import 'package:bg_tools/core/providers/database_providers.dart';
// import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';

// class GamingSessionFormScreen extends ConsumerStatefulWidget {
//   final int? gamingSessionId;
  
//   const GamingSessionFormScreen({super.key, this.gamingSessionId});

//   @override
//   ConsumerState<GamingSessionFormScreen> createState() => _GamingSessionFormScreenState();
// }

// class _GamingSessionFormScreenState extends ConsumerState<GamingSessionFormScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
//   late final Gamer? gamer;
//   // Контроллеры
//   late final TextEditingController _usernameController;
//   late final TextEditingController _firstNameController;
//   late final TextEditingController _lastNameController;
//   late final TextEditingController _middleNameController;
//   // Загрузка
//   bool _isLoading = false;
//   // Ошибка
//   String? _generalError;

//   @override
//   void initState() {
//     _isLoading = true;
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     if (widget.gamingSessionId == null) {
//       gamer = null;
//     } else {
//       final gamerDao = ref.read(gamerDaoProvider);
//       gamer = await gamerDao.get(widget.gamingSessionId!);
//     }

//     _usernameController = TextEditingController(text: gamer?.username);
//     _firstNameController = TextEditingController(text: gamer?.firstName);
//     _lastNameController = TextEditingController(text: gamer?.lastName);
//     _middleNameController = TextEditingController(text: gamer?.middleName);

//     setState(() => _isLoading = false);
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final gamerDao = ref.read(gamerDaoProvider);
//       final gamerComp =  GamersCompanion(
//         username: Value(_usernameController.text),
//         firstName: Value(_firstNameController.text),
//         lastName: Value(_lastNameController.text.isEmpty ? null : _lastNameController.text),
//         middleName: Value(_middleNameController.text.isEmpty ? null : _middleNameController.text),
//       );
//       try {
//         if (widget.gamerId == null) {
//           await gamerDao.create(gamerComp);
//         } else {
//           await gamerDao.updInstance(widget.gamerId!, gamerComp);
//         }

//         if (mounted) {
//           Navigator.pop(context, true);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(widget.gamerId == null ? 'Игрок добавлен' : 'Изменения сохранены')),
//           );
//         }

//          _formKey.currentState!.save();      
//       } catch (e) {
//         print(e);
//         setState(() {
//           _generalError = 'Запись уже существует';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.gamerId == null ? 'Новый игрок': 'Редактирование игрока'),
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Кидаем кубы...'),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.gamerId == null ? 'Новый игрок': 'Редактирование игрока'),
//         actions: [
//           if (widget.gamerId != null && gamer!.isOwner == false) IconButton(
//             icon: Icon(Icons.delete_outlined),
//             onPressed: () => {buildDelModal(context, ref, gamerDaoProvider, mounted, gamer)},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             spacing: 16,
//             children: [
//               if (_generalError != null) Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(8),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red.shade200),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.error, color: Colors.red.shade700, size: 20),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         _generalError!,
//                         style: TextStyle(color: Colors.red.shade700),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: 'Ник *',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Пожалуйста, введите ник';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Имя *',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Пожалуйста, введите имя';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Фамилия',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextFormField(
//                 controller: _middleNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Отчество',
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//                Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _submitForm,
//                       child: Text('Сохранить'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
