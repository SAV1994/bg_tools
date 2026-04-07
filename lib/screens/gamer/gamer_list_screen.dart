import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

class GamersListScreen extends ConsumerStatefulWidget {
  const GamersListScreen({super.key});

  @override
  ConsumerState<GamersListScreen> createState() => _GamersListScreenState();
}

class _GamersListScreenState extends ConsumerState<GamersListScreen> {

  Future<void> _openAddForm() async {
    final result = await context.pushNamed('gamers-add');
    
    if (result == true) {
      ref.invalidate(gamerDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openUpdatePage(int gamerId) async {
    final result = await context.pushNamed('gamers-update', pathParameters: {'gamerId': gamerId.toString()});;
    
    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamerDao = ref.watch(gamerDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Список игроков'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          )
        ],
      ),
      body: FutureBuilder<List<Gamer>> (
        future: gamerDao.getAll(),
        builder: (context, snapshot) {
          // Показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Если данных нет
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyListMsg));
          }
          
          // Получаем данные
          final gamers = snapshot.data!;

          return ListView.builder(
            itemCount: gamers.length,
            itemBuilder: (context, index) {
              final gamer = gamers[index];

              String fio = '';
              
              if (gamer.lastName != null) {
                fio += '${gamer.lastName} ';
              } 
              fio += '${gamer.firstName} ';
              if (gamer.middleName != null) {
                fio += '${gamer.middleName}';
              } 

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.wc),
                  title: Text(gamer.username),
                  subtitle: Text(fio),
                  trailing: Icon(Icons.edit),
                  onTap: () {_openUpdatePage(gamer.id);},
                )
              );
            }
          );
        },
      )
    );
  }
}
