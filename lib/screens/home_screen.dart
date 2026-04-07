import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

import '../core/consts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 30),
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      fixedSize: Size(350, 50),
      iconSize: 30
    );

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('games-list')},
              style: btnStyle,
              label: Text('Настольные игры'),
              icon: const Icon(Icons.layers),
            ),
            ElevatedButton.icon(
              onPressed: () => {},
              style: btnStyle,
              label: Text('Список игроков'),
              icon: const Icon(Icons.supervisor_account),
            ),
            ElevatedButton.icon(
              onPressed: () => {},
              style: btnStyle,
              label: Text('История партий'),
              icon: const Icon(Icons.assignment),
            ),
            ElevatedButton.icon(
              onPressed: () => {},
              style: btnStyle,
              label: Text('Мой рейтинг игр'),
              icon: const Icon(Icons.favorite),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('tags')},
              style: btnStyle,
              label: Text('Метки категорий'),
              icon: const Icon(Icons.location_on),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('designers')},
              style: btnStyle,
              label: Text('Геймдизайнеры'),
              icon: const Icon(Icons.account_balance),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('artists')},
              style: btnStyle,
              label: Text('Художники'),
              icon: const Icon(Icons.border_color),
            ),
          ],
        ),
      ),
    );
  }
}
