import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

class PaginationPanel extends StatelessWidget {
  final BaseNotifier notifier;

  const PaginationPanel({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final int lastItemNum =
        (notifier.currentPage + 1) * notifier.pageSize > notifier.totalItems
        ? notifier.totalItems
        : (notifier.currentPage + 1) * notifier.pageSize;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: secondColor,
        boxShadow: [BoxShadow(blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Информация
          Text(
            '${notifier.currentPage * notifier.pageSize + 1}-$lastItemNum из ${notifier.totalItems}',
            style: const TextStyle(fontSize: 12, color: goldColor),
          ),

          // Навигация
          Row(
            children: [
              // Первая страница
              IconButton(
                icon: Icon(
                  Icons.first_page,
                  size: 20,
                  color: notifier.hasPrevious ? goldColor : redColor,
                ),
                onPressed: notifier.hasPrevious
                    ? () => notifier.goToPage(0)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Назад
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: notifier.hasPrevious ? goldColor : redColor,
                ),
                onPressed: notifier.hasPrevious
                    ? () => notifier.goToPage(notifier.currentPage - 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              // Индикатор страницы
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      '${notifier.currentPage + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(fontSize: 14, color: goldColor),
                    ),
                    Text(
                      '${notifier.totalPages}',
                      style: const TextStyle(fontSize: 14, color: goldColor),
                    ),
                  ],
                ),
              ),

              // Вперед
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: notifier.hasNext ? goldColor : redColor,
                ),
                onPressed: notifier.hasNext
                    ? () => notifier.goToPage(notifier.currentPage + 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Последняя страница
              IconButton(
                icon: Icon(
                  Icons.last_page,
                  size: 20,
                  color: notifier.hasNext ? goldColor : redColor,
                ),
                onPressed: notifier.hasNext
                    ? () => notifier.goToPage(notifier.totalPages - 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
