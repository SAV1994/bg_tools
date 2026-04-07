// import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// class GamesAddScreen extends StatefulWidget {
//   @override
//   _GamesAddScreenState createState() => _GamesAddScreenState();
// }

// class _GamesAddScreenState extends State<GamesAddScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   String? _title = '';
//   String _description = '';
//   double year = 3.0;
//   bool _isInCollection = true;
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Расширенная форма')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Dropdown
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: 'Пол',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Мужской', 'Женский', 'Другой'].map((gender) {
//                   return DropdownMenuItem(
//                     value: gender,
//                     child: Text(gender),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Выберите пол';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
              
//               // Slider
//               Row(
//                 children: [
//                   Text('Возраст: ', style: TextStyle(fontSize: 16)),
//                   Expanded(
//                     child: Slider(
//                       value: _age.toDouble(),
//                       min: 18,
//                       max: 100,
//                       divisions: 82,
//                       label: _age.toString(),
//                       onChanged: (value) {
//                         setState(() {
//                           _age = value.toInt();
//                         });
//                       },
//                     ),
//                   ),
//                   Text('$_age', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//               SizedBox(height: 16),
              
//               // Date Picker
//               ListTile(
//                 title: Text('Дата рождения'),
//                 subtitle: Text(_selectedDate.toString().split(' ')[0]),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: _selectedDate,
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (picked != null) {
//                     setState(() {
//                       _selectedDate = picked;
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 16),
              
//               // Checkbox
//               CheckboxListTile(
//                 title: Text('Согласен с условиями'),
//                 value: _agreeToTerms,
//                 onChanged: (value) {
//                   setState(() {
//                     _agreeToTerms = value!;
//                   });
//                 },
//                 controlAffinity: ListTileControlAffinity.leading,
//               ),
//               SizedBox(height: 16),
              
//               // Radio Group
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Уровень удовлетворенности:', style: TextStyle(fontSize: 16)),
//                   RadioListTile(
//                     title: Text('Отлично'),
//                     value: 5,
//                     groupValue: _rating.toInt(),
//                     onChanged: (value) {
//                       setState(() {
//                         _rating = value!.toDouble();
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('Хорошо'),
//                     value: 4,
//                     groupValue: _rating.toInt(),
//                     onChanged: (value) {
//                       setState(() {
//                         _rating = value!.toDouble();
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('Нормально'),
//                     value: 3,
//                     groupValue: _rating.toInt(),
//                     onChanged: (value) {
//                       setState(() {
//                         _rating = value!.toDouble();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24),
              
//               // Кнопки отправки и сброса
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _submitForm,
//                       child: Text('Отправить'),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: _resetForm,
//                       child: Text('Сбросить'),
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
  
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
      
//       // Сбор данных
//       Map<String, dynamic> formData = {
//         'gender': _selectedGender,
//         'age': _age,
//         'birthDate': _selectedDate,
//         'agreed': _agreeToTerms,
//         'rating': _rating,
//       };
      
//       print('Данные формы: $formData');
      
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Успешно!'),
//           content: Text('Форма отправлена'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
  
//   void _resetForm() {
//     _formKey.currentState?.reset();
//     setState(() {
//       _selectedGender = null;
//       _age = 25;
//       _selectedDate = DateTime.now();
//       _agreeToTerms = false;
//       _rating = 3.0;
//     });
//   }
// }
