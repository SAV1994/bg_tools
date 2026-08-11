import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Контроллеры
  late final TextEditingController _pageLimitController;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final int pageLimit = await AppDataManager.loadPageLimit();

    setState(() {
      _pageLimitController = TextEditingController(text: pageLimit.toString());
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Настройки')),
        body: LoadingScreen(),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (_pageLimitController.text.isNotEmpty) {
          AppDataManager.savePageLimit(
            int.parse(_pageLimitController.text),
          ).whenComplete(() {
            ref.read(gamesPaginatedProvider.notifier).updatePageLimit();
            ref.read(gamersPaginatedProvider.notifier).updatePageLimit();
            ref
                .read(gamingSessionsPaginatedProvider.notifier)
                .updatePageLimit();
            ref
                .read(countingTemplatesPaginatedProvider.notifier)
                .updatePageLimit();
            ref.read(designersPaginatedProvider.notifier).updatePageLimit();
            ref.read(artistsPaginatedProvider.notifier).updatePageLimit();
            ref.read(tagsPaginatedProvider.notifier).updatePageLimit();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Настройки')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  controller: _pageLimitController,
                  decoration: InputDecoration(
                    labelText: 'Количество записей на странице *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = int.tryParse(value);
                      if (num == null) return 'Некорректное число';
                      if (num < 1) return 'Должно быть не меньше 1';
                    }
                    return pageSize.toString();
                  },
                ),
                OutlinedButton.icon(
                  onPressed: () =>
                      buildClearSessionsModal(context, ref, mounted),
                  icon: const Icon(delIcon),
                  label: const Text('Очистить список игровых сессий'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
