import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';

class ListWithModalFormConfig<T, D, C> {
  final String pageTitle;
  final IconData icon;
  final ProviderBase<AsyncValue<List<T>>> dataProvider;
  final Provider<D> daoProvier;
  final C Function(String name) companionFactory;
  final String imputName;

  const ListWithModalFormConfig({
    required this.pageTitle,
    required this.icon,
    required this.dataProvider,
    required this.daoProvier,
    required this.companionFactory,
    required this.imputName,
  });
}

class ListWithModalFormScreen<T> extends ConsumerWidget {
  final ListWithModalFormConfig config;

  const ListWithModalFormScreen({required this.config, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(config.dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.pageTitle),
        actions: [
          IconButton(
            onPressed: () => {_showModalForm(context, ref)},
            icon: Icon(Icons.add_box),
          )
        ],
      ),
      body: dataAsync.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(config.icon),
                title: Text(item.name),
                trailing: Icon(Icons.edit),
                onTap: () {_showModalForm(context, ref, item.id);},
              )
            );
          }
        ),
        loading: () => CircularProgressIndicator(),
        error: (err, _) => Text('Пусто ¯\\_(ツ)_/¯'),
      )
    );
  }

  void _showModalForm(BuildContext context, WidgetRef ref, [int? instanceId]) {
    showDialog(
      context: context,
      builder: (context) => ModalForm(ref: ref, config: config, instanceId: instanceId),
    );
  }
}

class ModalForm extends ConsumerStatefulWidget {
  final int? instanceId;
  final WidgetRef ref;
  final ListWithModalFormConfig config;

  const ModalForm({super.key, this.instanceId, required this.ref, required this.config});

  @override
  ConsumerState<ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends ConsumerState<ModalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Контроллеры
  late final TextEditingController _nameController;
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;
  // Сущность
  late final dynamic instance;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.instanceId == null) {
      _nameController = TextEditingController();
    } else {
      final dao = widget.ref.read(widget.config.daoProvier);
      instance = await dao.get(widget.instanceId);
      _nameController = TextEditingController(text: instance.name);
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _submitForm() async {
    final dao = widget.ref.read(widget.config.daoProvier);
    try {
      if (widget.instanceId == null) {
        await dao.create(widget.config.companionFactory(_nameController.text));
      } else {
         await dao.updInstance(widget.instanceId, widget.config.companionFactory(_nameController.text));
      }
    
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _generalError = 'Запись уже существует';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AlertDialog(
        title: Text(widget.instanceId == null ? 'Новая запись': 'Редактирование'),
        content: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Кидаем кубы...'),
            ],
          ),
        ),
      );
    }

    return AlertDialog(
      title: Text(widget.instanceId == null ? 'Новая запись': 'Редактирование'),
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.instanceId != null) IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () {buildDelModal(context, ref, widget.config.daoProvier, mounted, instance);},
            ),
            if (_generalError != null) Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _generalError!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: widget.config.imputName,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty == true ? 'Введите ФИО' : null,
            ),
          ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.instanceId == null ? 'Добавить': 'Сохранить'),
        ),
      ],
    );
  }
}
