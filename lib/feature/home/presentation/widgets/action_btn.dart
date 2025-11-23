import 'package:flutter/material.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class ActionBtn extends StatelessWidget {
  const ActionBtn({super.key, required this.tableCubit});

  final TableCubit tableCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        children: [
          SizedBox(
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (tableCubit.isUpdate) {
                  tableCubit.saveUpdatedItem(
                    tableCubit.pageController.page!.toInt(),
                  );
                } else if (tableCubit.validateAllForms()) {
                  tableCubit.addItemsToTable();
                }
              },
              child: Text(
                tableCubit.isUpdate ? 'Update Item' : 'Save All Items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
