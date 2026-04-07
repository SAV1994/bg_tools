import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ListWithModalFormConfig<T, D, C> {
  final String pageTitle;
  final ProviderBase<AsyncValue<List<T>>> dataProvider;
  final Provider<D> daoProvier;
  final C Function(String name) companionFactory;
  final String imputName;

  const ListWithModalFormConfig({
    required this.pageTitle,
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
            onPressed: () => {_showCreateForm(context, ref)},
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
                leading: Icon(Icons.article),
                title: Text(item.name),
                subtitle: Text('Нажмите для перехода'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              )
            );
          }
        ),
        loading: () => CircularProgressIndicator(),
        error: (err, _) => Text('Пусто ¯\\_(ツ)_/¯'),
      )
    );
  }

  void _showCreateForm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CreateModalForm(ref: ref, config: config),
    );
  }
}

class CreateModalForm extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final ListWithModalFormConfig config;

  const CreateModalForm({super.key, required this.ref, required this.config});

  @override
  ConsumerState<CreateModalForm> createState() => _CreateModalFormState();
}

class _CreateModalFormState extends ConsumerState<CreateModalForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _generalError;

  Future<void> _createDesigner() async {
    final dao = widget.ref.read(widget.config.daoProvier);
    try {
      await dao.create(widget.config.companionFactory(_nameController.text));
    
    if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _generalError = 'Запись уже существует';
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая запись'),
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
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
          onPressed: _createDesigner,
          child: Text('Добавить'),
        ),
      ],
    );
  }
}