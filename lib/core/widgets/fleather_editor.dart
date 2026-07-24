import 'dart:convert';

import 'package:bg_tools/core/consts/theme_consts.dart';
import 'package:flutter/material.dart';

import 'package:fleather/fleather.dart';

class FleatherEditorWidget extends StatefulWidget {
  final String? initialContent;
  final ValueChanged<String> onContentChanged;
  final double height;

  const FleatherEditorWidget({
    super.key,
    this.initialContent,
    required this.onContentChanged,
    this.height = 250,
  });

  @override
  State<FleatherEditorWidget> createState() => _FleatherEditorWidgetState();
}

class _FleatherEditorWidgetState extends State<FleatherEditorWidget> {
  late FleatherController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.initialContent != null && widget.initialContent!.isNotEmpty) {
      try {
        final jsonMap = jsonDecode(widget.initialContent!);
        final document = ParchmentDocument.fromJson(jsonMap);
        _controller = FleatherController(document: document);
      } catch (e) {
        // Если JSON некорректный, создаем пустой документ
        _controller = FleatherController();
      }
    } else {
      _controller = FleatherController();
    }

    _controller.addListener(_onContentChange);
  }

  void _onContentChange() {
    widget.onContentChanged(jsonEncode(_controller.document.toJson()));
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Панель инструментов
          Container(
            height: widget.height,
            alignment: AlignmentGeometry.topStart,
            color: secondColor,
            child: Column(
              children: [
                FleatherToolbar.basic(
                  controller: _controller,
                  hideHeadingStyle: true,
                  hideLink: true,
                ),
                SizedBox(height: 30),
                Divider(height: 2),
                FleatherEditor(controller: _controller, focusNode: FocusNode()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FleatherViewer extends StatelessWidget {
  final String content;

  const FleatherViewer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const Text('Нет содержимого');
    }

    try {
      final jsonMap = jsonDecode(content);
      final document = ParchmentDocument.fromJson(jsonMap);
      return FleatherEditor(
        controller: FleatherController(document: document),
        readOnly: true,
        focusNode: FocusNode(),
      );
    } catch (e) {
      return Text('Ошибка отображения: $e');
    }
  }
}
