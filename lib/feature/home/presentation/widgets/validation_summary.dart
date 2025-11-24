import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class ValidationSummary extends StatefulWidget {
  const ValidationSummary({super.key});

  @override
  State<ValidationSummary> createState() => _ValidationSummaryState();
}

class _ValidationSummaryState extends State<ValidationSummary> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final tablecubit = context.watch<TableCubit>();
    final errorCount = tablecubit.formHasError
        .where((hasError) => hasError)
        .length;

    if (errorCount == 0) return SizedBox();
    return errorCount == 0
        ? SizedBox()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(
              horizontal: size.width < 1000 ? 24 : 80,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$errorCount form(s) have validation errors. Please fix them before saving.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
  }
}
