import 'package:bg_tools/core/app_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class AdditionalOptionType {
  final bool Function(Map<String, dynamic>?) show;
  final IconButton btn;

  AdditionalOptionType({required this.show, required this.btn});
}

abstract class RandomInstancesScreen extends ConsumerStatefulWidget {
  const RandomInstancesScreen({super.key});
}

abstract class RandomInstancesScreenStateState
    extends ConsumerState<RandomInstancesScreen>
    with SingleTickerProviderStateMixin {
  Function get buildAddModal;
  AdditionalOptionType? get additionalOption;
  String get emtyListMsg;
  IconData get instIcon;
  IconData get singleInstIcon;

  List allData = [];
  List selectedData = [];
  List result = [];
  late final Map<String, dynamic>? sessionData;

  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  // Загрузка
  bool isLoading = false;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    await loadData();

    sessionData = await AppDataManager.loadActiveSession();

    setState(() => isLoading = false);
  }

  Future<void> loadData() async {}

  Future<void> saveData() async {}

  void _showAddDialog() {
    final notSelectedData = allData
        .where((g) => !selectedData.any((item) => g.id == item['id']))
        .toList();

    if (notSelectedData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Все записи уже выбраны')));
      return;
    }

    buildAddModal(context, notSelectedData, (dataItem) {
      setState(
        () => selectedData.add({
          'id': dataItem.id,
          'name': UniversalAttrGetter.getTitle(dataItem),
        }),
      );
    });
  }

  Future<void> _clearData() async {
    setState(() => isLoading = true);

    await clearAppData();

    setState(() {
      result.clear();
      selectedData.clear();
      isLoading = false;
    });
  }

  Future<void> clearAppData() async {}

  Future<void> _getRandom({bool single = false}) async {
    if (_inProgress) return;
    setState(() {
      _inProgress = true;
      result.clear();
    });

    _animationController.forward(from: 0);

    // Небольшая задержка для анимации
    Future.delayed(Duration(milliseconds: 500), () {
      List res = List.from(selectedData);
      res.shuffle();

      if (single) {
        res = res.sublist(0, 1);
      }
      setState(() {
        result = res;
        _inProgress = false;
      });

      saveData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(randomIcon, color: silverColor),
            Icon(instIcon),
          ],
        ),
        actions: [
          if (selectedData.isNotEmpty)
            IconButton(icon: Icon(delIcon), onPressed: () => _clearData()),

          if (additionalOption != null && additionalOption!.show(sessionData))
            additionalOption!.btn,

          IconButton(icon: Icon(addBtnIcon), onPressed: () => _showAddDialog()),
        ],
      ),
      body: selectedData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(instIcon, size: 64, color: textColor),
                  SizedBox(height: 16),
                  Text(
                    emtyListMsg,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedData.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value['name']),
                        onDeleted: () =>
                            setState(() => selectedData.removeAt(entry.key)),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 20,
                          color: redColor,
                        ),

                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ),

                Divider(thickness: 2),
                SizedBox(height: 10),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _inProgress
                            ? null
                            : () => _getRandom(single: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: firstColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _inProgress
                                  ? Icons.hourglass_empty
                                  : singleInstIcon,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _inProgress ? 'Шуршим...' : 'Выбрать одно',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _inProgress ? null : () => _getRandom(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: firstColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _inProgress ? Icons.hourglass_empty : instIcon,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _inProgress ? 'Шуршим...' : 'Случайный порядок',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (result.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Divider(thickness: 2),
                  SizedBox(height: 10),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> dataItem = result[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(dataItem['name']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
