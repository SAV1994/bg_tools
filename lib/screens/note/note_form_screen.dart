import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class NoteForm extends ConsumerStatefulWidget {
  final int gameId;
  final int? noteId;

  const NoteForm({super.key, required this.gameId, this.noteId});

  @override
  ConsumerState<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends ConsumerState<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  late final Note? note;

  String? _richContent = '';
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    if (widget.noteId == null) {
      note = null;
    } else {
      final noteDao = ref.read(noteDaoProvider);
      note = await noteDao.getSingle(widget.noteId!);
      _titleController.text = note!.title;
      _richContent = note!.content;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dao = ref.read(noteDaoProvider);

      if (note == null) {
        await dao.create(
          gameId: widget.gameId,
          title: _titleController.text.trim(),
          content: _richContent,
        );
      } else {
        await dao.updInstance(
          noteId: note!.id,
          title: _titleController.text.trim(),
          content: _richContent,
        );
      }

      final notifier = ref.read(notesPaginatedProvider.notifier);
      notifier.refresh();
      ref.invalidate(noteDataProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              note == null ? 'Заметка создана' : 'Заметка обновлена',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(
          notesIcon,
          color: widget.noteId == null ? bronzeColor : blueColor,
        ),
      ),
      body: _isLoading
          ? LoadingScreen()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Поле для краткого описания
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Заголовок заметки *',
                        hintText: 'Кратко опишите содержание...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введите заголовок заметки';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Содержание заметки',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Редактор форматированного текста
                    FleatherEditorWidget(
                      initialContent: _richContent!.isNotEmpty
                          ? _richContent
                          : null,
                      onContentChanged: (content) {
                        _richContent = content;
                      },
                      height: 400,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Сохранить заметку'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
